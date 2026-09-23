# Stdio-мост к локальному Vanessa Automation MCP (streamable HTTP).
#
# HTTP сверен со спецификацией MCP 2025-11-25 (Streamable HTTP) и с живым
# сервером 127.0.0.1:<VA_MCP_PORT>/mcp процесса 1cv8c:
# - POST, заголовок Accept: application/json, text/event-stream
# - initialize отвечает 200, Content-Type: text/event-stream, заголовок mcp-session-id
# - этот идентификатор уходит во все следующие запросы как MCP-Session-Id
# - после initialize на запросы добавляется MCP-Protocol-Version согласованной версии
# - уведомление и ответ клиента: сервер отвечает 202 без тела
# - результат запроса — один объект application/json либо события text/event-stream
#
# Stdio в спецификации MCP (2024-11-05 и 2025-11-25) — это JSON-RPC,
# разделённый переводом строки. Кадр Content-Length — формат LSP; его тоже
# принимаем. Ответ пишется тем же кадром, каким пришёл первый запрос.
# Stdout занят протоколом: только байты кадров и flush. Журнал — в stderr.
# Логин и пароль 1С этот процесс не читает: их забирает Start-VanessaMcp.ps1.

from __future__ import annotations

import ctypes
import json
import os
import socket
import subprocess
import sys
import time
from ctypes import wintypes
from pathlib import Path

_MAX_FRAME = 32 * 1024 * 1024
_HEADER_LIMIT = 65_536
_PORT_WAIT_SECONDS = 180


def log(text: str) -> None:
    """Пишет одну строку журнала в stderr и сбрасывает буфер."""
    sys.stderr.buffer.write((text + "\n").encode("utf-8"))
    sys.stderr.buffer.flush()


def repo_root() -> Path:
    """Корень репозитория: каталог скрипта — tools/va."""
    return Path(__file__).resolve().parents[2]


def read_mcp_port(root: Path) -> int:
    """Возвращает VA_MCP_PORT из .dev.env либо 9876. Остальные ключи не использует."""
    path = root / ".dev.env"
    if not path.is_file():
        return 9876
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        if key.strip() != "VA_MCP_PORT":
            continue
        value = value.strip()
        if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
            value = value[1:-1].strip()
        if not value:
            return 9876
        port = int(value)
        if port < 1 or port > 65535:
            raise ValueError(f"VA_MCP_PORT вне диапазона: {port}")
        return port
    return 9876


def _listening_pids(port: int) -> list[int]:
    """PID процессов, которые слушают TCP-порт IPv4. Никого не завершает."""
    af_inet = 2
    tcp_table_owner_pid_listener = 3
    error_insufficient_buffer = 122
    iphlpapi = ctypes.WinDLL("iphlpapi")
    get_table = iphlpapi.GetExtendedTcpTable
    get_table.argtypes = [
        ctypes.c_void_p,
        ctypes.POINTER(wintypes.DWORD),
        wintypes.BOOL,
        wintypes.ULONG,
        ctypes.c_int,
        wintypes.ULONG,
    ]
    get_table.restype = wintypes.DWORD
    size = wintypes.DWORD(0)
    status = get_table(None, ctypes.byref(size), False, af_inet, tcp_table_owner_pid_listener, 0)
    if status not in (0, error_insufficient_buffer):
        raise OSError(f"GetExtendedTcpTable не вернул размер, код {status}")
    buffer = ctypes.create_string_buffer(max(size.value, 4))
    size = wintypes.DWORD(len(buffer))
    status = get_table(
        ctypes.cast(buffer, ctypes.c_void_p),
        ctypes.byref(size),
        False,
        af_inet,
        tcp_table_owner_pid_listener,
        0,
    )
    if status != 0:
        raise OSError(f"GetExtendedTcpTable завершился с кодом {status}")
    count = ctypes.cast(buffer, ctypes.POINTER(wintypes.DWORD)).contents.value

    class Row(ctypes.Structure):
        _fields_ = [
            ("dwState", wintypes.DWORD),
            ("dwLocalAddr", wintypes.DWORD),
            ("dwLocalPort", wintypes.DWORD),
            ("dwRemoteAddr", wintypes.DWORD),
            ("dwRemotePort", wintypes.DWORD),
            ("dwOwningPid", wintypes.DWORD),
        ]

    row_size = ctypes.sizeof(Row)
    base = ctypes.addressof(buffer) + ctypes.sizeof(wintypes.DWORD)
    found: list[int] = []
    for index in range(count):
        row = Row.from_address(base + index * row_size)
        local_port = socket.ntohs(row.dwLocalPort & 0xFFFF)
        if local_port == port:
            found.append(int(row.dwOwningPid))
    return found


def _process_stem(pid: int) -> str:
    """Имя файла процесса без пути. UNKNOWN, если образ недоступен."""
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    open_process = kernel32.OpenProcess
    open_process.argtypes = [wintypes.DWORD, wintypes.BOOL, wintypes.DWORD]
    open_process.restype = wintypes.HANDLE
    query_name = kernel32.QueryFullProcessImageNameW
    query_name.argtypes = [
        wintypes.HANDLE,
        wintypes.DWORD,
        wintypes.LPWSTR,
        ctypes.POINTER(wintypes.DWORD),
    ]
    query_name.restype = wintypes.BOOL
    handle = open_process(0x1000, False, pid)
    if not handle:
        return "UNKNOWN"
    try:
        size = wintypes.DWORD(32768)
        buffer = ctypes.create_unicode_buffer(size.value)
        if not query_name(handle, 0, buffer, ctypes.byref(size)):
            return "UNKNOWN"
        return Path(buffer.value).stem or "UNKNOWN"
    finally:
        kernel32.CloseHandle(handle)


def listener_process_name(port: int) -> str | None:
    """Имя слушателя порта. None — порта никто не слушает. Процессы не завершает."""
    pids = _listening_pids(port)
    if not pids:
        return None
    names = [_process_stem(pid) for pid in pids]
    for name in names:
        if name.casefold() != "1cv8c":
            return name
    return "1cv8c"


def tcp_open(port: int) -> bool:
    """Проверяет, принимает ли 127.0.0.1 TCP-соединение на порту."""
    try:
        with socket.create_connection(("127.0.0.1", port), timeout=0.5):
            return True
    except OSError:
        return False


def _relay_script_output(data: bytes) -> None:
    """Переносит вывод скрипта запуска в stderr, не печатая строку запуска с /P."""
    if data.startswith(b"\xff\xfe") or (len(data) >= 4 and data[1:2] == b"\x00"):
        text = data.decode("utf-16-le", errors="replace")
    else:
        text = data.decode("utf-8", errors="replace")
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if "/P\"" in stripped or "IB_PASSWORD" in stripped:
            log("Вывод скрипта запуска скрыт.")
            continue
        log(stripped)


def ensure_vanessa(root: Path, port: int) -> None:
    """Открывает мост только к 1cv8c. Чужой слушатель — ошибка, без завершения процесса.

    Если порта нет, один раз запускает tools/va/Start-VanessaMcp.ps1 из корня
    репозитория и ждёт появления 1cv8c. Повторно скрипт не вызывает.
    """
    owner = listener_process_name(port)
    if owner is not None:
        if owner.casefold() != "1cv8c":
            log(
                f"Порт {port} занят процессом {owner}. "
                "Сеанс Vanessa не запускался, процесс не завершался."
            )
            raise SystemExit(1)
        log(f"Порт {port} уже слушает 1cv8c. Второй сеанс не запускается.")
        return

    script = root / "tools" / "va" / "Start-VanessaMcp.ps1"
    log(f"Порт {port} не слушает. Один запуск {script.name}.")
    flags = getattr(subprocess, "CREATE_NO_WINDOW", 0)
    try:
        completed = subprocess.run(
            ["powershell.exe", "-NoProfile", "-File", str(script)],
            cwd=str(root),
            capture_output=True,
            timeout=_PORT_WAIT_SECONDS,
            creationflags=flags,
        )
    except subprocess.TimeoutExpired:
        log("Start-VanessaMcp.ps1 не завершился за 180 с. Повторный запуск не выполняется.")
        raise SystemExit(1) from None
    _relay_script_output(completed.stdout)
    _relay_script_output(completed.stderr)
    if completed.returncode != 0:
        log(
            f"Start-VanessaMcp.ps1 завершился с кодом {completed.returncode}. "
            "Повторный запуск не выполняется."
        )
        raise SystemExit(1)

    deadline = time.monotonic() + _PORT_WAIT_SECONDS
    announced = 0.0
    while time.monotonic() < deadline:
        if tcp_open(port):
            break
        now = time.monotonic()
        if now - announced >= 15:
            log(f"Ожидание 127.0.0.1:{port}.")
            announced = now
        time.sleep(1)
    else:
        log(f"Порт {port} не открылся за {_PORT_WAIT_SECONDS} с. Повторный запуск не выполняется.")
        raise SystemExit(1)

    owner = listener_process_name(port)
    if owner is None or owner.casefold() != "1cv8c":
        shown = owner or "неизвестный процесс"
        log(f"Порт {port} занят процессом {shown}. Процесс не завершался.")
        raise SystemExit(1)
    log(f"Порт {port} слушает 1cv8c.")


def _json_bytes(message: dict) -> bytes:
    """Кодирует одно JSON-RPC-сообщение без перевода строки внутри."""
    return json.dumps(message, ensure_ascii=False, separators=(",", ":")).encode("utf-8")


def _media_type(value: str | None) -> str:
    """Возвращает тип содержимого без параметров."""
    if not value:
        return ""
    return value.split(";", 1)[0].strip().lower()


def _header_separator(buffer: bytes) -> tuple[int, bytes] | None:
    """Находит конец блока заголовков Content-Length."""
    found: tuple[int, bytes] | None = None
    for marker in (b"\r\n\r\n", b"\n\n"):
        index = buffer.find(marker)
        if index != -1 and (found is None or index < found[0]):
            found = (index, marker)
    return found


def _sse_separator(buffer: bytes) -> tuple[int, bytes] | None:
    """Находит границу SSE-события."""
    return _header_separator(buffer)


def _content_length_of(header_blob: bytes) -> int:
    """Достаёт длину тела из заголовков кадра. Длина — в байтах UTF-8."""
    for raw in header_blob.splitlines():
        if b":" not in raw:
            continue
        name, value = raw.split(b":", 1)
        if name.strip().lower() == b"content-length":
            return int(value.strip())
    raise RuntimeError("В кадре stdio нет заголовка Content-Length")


def _sse_event_message(raw_event: bytes) -> dict | None:
    """Собирает JSON-RPC из поля data SSE. Пустое data — служебное событие."""
    data_lines: list[bytes] = []
    for raw in raw_event.splitlines():
        if not raw or raw.startswith(b":"):
            continue
        if raw.lower().startswith(b"data:"):
            data_lines.append(raw.split(b":", 1)[1].lstrip(b" "))
    if not data_lines:
        return None
    data = b"\n".join(data_lines).strip()
    if not data:
        return None
    message = json.loads(data.decode("utf-8"))
    if not isinstance(message, dict):
        raise RuntimeError("SSE data не является объектом JSON-RPC")
    return message


def _pop_sse_messages(buffer: bytes) -> tuple[list[dict], bytes]:
    """Отделяет уже целые SSE-события от хвоста буфера."""
    messages: list[dict] = []
    while True:
        found = _sse_separator(buffer)
        if found is None:
            return messages, buffer
        index, marker = found
        raw_event = buffer[:index]
        buffer = buffer[index + len(marker) :]
        message = _sse_event_message(raw_event)
        if message is not None:
            messages.append(message)


def iter_sse(response):
    """Читает поток text/event-stream до закрытия ответа и отдаёт сообщения по мере готовности."""
    buffer = b""
    while True:
        chunk = response.read(8192)
        if not chunk:
            if buffer.strip():
                message = _sse_event_message(buffer)
                if message is not None:
                    yield message
            return
        buffer += chunk
        if len(buffer) > _MAX_FRAME:
            raise RuntimeError("Событие SSE превышает допустимый размер")
        messages, buffer = _pop_sse_messages(buffer)
        for message in messages:
            yield message


class StdioFramer:
    """Читает и пишет кадры stdio. Режим выбирается по первому запросу клиента."""

    def __init__(self) -> None:
        self.mode: str | None = None
        self._buf = b""
        self._stdin_fd = sys.stdin.fileno()

    def read_message(self) -> dict | None:
        """Возвращает следующее сообщение либо None при закрытом stdin."""
        while True:
            try:
                message = self._pull()
            except json.JSONDecodeError as exc:
                log(f"Не разобран JSON кадра stdio: {exc.msg}")
                continue
            if message is not None:
                return message
            # BufferedReader.read ждёт полный размер или EOF. На канале Windows это
            # зависает, пока клиент не закрыл stdin. os.read возвращает уже пришедшие байты.
            chunk = os.read(self._stdin_fd, 65536)
            if not chunk:
                if self._buf.strip():
                    log("stdin закрыт на неполном кадре")
                return None
            self._buf += chunk

    def write_message(self, message: dict) -> None:
        """Пишет один кадр в stdout байтами и сразу сбрасывает буфер."""
        payload = _json_bytes(message)
        if self.mode == "content-length":
            frame = b"Content-Length: " + str(len(payload)).encode("ascii") + b"\r\n\r\n" + payload
        else:
            frame = payload + b"\n"
        sys.stdout.buffer.write(frame)
        sys.stdout.buffer.flush()

    def _pull(self) -> dict | None:
        """Достаёт один целый кадр из буфера. None — данных пока не хватает."""
        if self.mode is None:
            stripped = self._buf.lstrip(b"\r\n")
            if not stripped:
                self._buf = b""
                return None
            self._buf = stripped
            if stripped.startswith(b"{") or stripped.startswith(b"["):
                self.mode = "ndjson"
                log("Кадр stdio: NDJSON")
            elif len(stripped) < 14:
                return None
            elif stripped[:14].lower() == b"content-length":
                self.mode = "content-length"
                log("Кадр stdio: Content-Length")
            else:
                raise RuntimeError("Неизвестный кадр stdio")
        if self.mode == "ndjson":
            return self._pull_ndjson()
        return self._pull_content_length()

    def _pull_ndjson(self) -> dict | None:
        """Одно JSON-RPC-сообщение на строку, как в спецификации stdio MCP."""
        while True:
            newline = self._buf.find(b"\n")
            if newline < 0:
                if len(self._buf) > _MAX_FRAME:
                    raise RuntimeError("Кадр NDJSON превышает допустимый размер")
                return None
            line = self._buf[:newline].rstrip(b"\r")
            self._buf = self._buf[newline + 1 :]
            if line.strip():
                message = json.loads(line.decode("utf-8"))
                if not isinstance(message, dict):
                    raise RuntimeError("Кадр NDJSON не является объектом JSON-RPC")
                return message

    def _pull_content_length(self) -> dict | None:
        """Кадр LSP: Content-Length в байтах и тело без завершающего перевода строки."""
        self._buf = self._buf.lstrip(b"\r\n")
        found = _header_separator(self._buf)
        if found is None:
            if len(self._buf) > _HEADER_LIMIT:
                raise RuntimeError("Заголовок Content-Length слишком длинный")
            return None
        index, marker = found
        length = _content_length_of(self._buf[:index])
        if length < 0 or length > _MAX_FRAME:
            raise RuntimeError("Недопустимая длина кадра Content-Length")
        start = index + len(marker)
        end = start + length
        if len(self._buf) < end:
            return None
        body = self._buf[start:end]
        self._buf = self._buf[end:]
        message = json.loads(body.decode("utf-8"))
        if not isinstance(message, dict):
            raise RuntimeError("Тело Content-Length не является объектом JSON-RPC")
        return message


class VaMcpStdioProxy:
    """Пересылает JSON-RPC клиента на http://127.0.0.1:<port>/mcp и держит сессию."""

    def __init__(self, port: int) -> None:
        self.port = port
        self.session_id: str | None = None
        self.protocol_version: str | None = None
        self.framer = StdioFramer()

    def run(self) -> None:
        """Читает stdin до EOF. Процесс 1cv8c при выходе не трогает."""
        while True:
            message = self.framer.read_message()
            if message is None:
                return
            try:
                self.forward(message)
            except Exception as exc:
                detail = str(exc).splitlines()[0][:200]
                log(f"Запрос к Vanessa MCP не выполнен: {type(exc).__name__}: {detail}")
                self._fail(message, "Vanessa MCP request failed")

    def forward(self, message: dict) -> None:
        """Отправляет одно сообщение POST-ом и пишет клиенту ответы сервера."""
        import http.client

        body = _json_bytes(message)
        method = message.get("method")
        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
            "Content-Length": str(len(body)),
        }
        if method != "initialize":
            if self.session_id:
                headers["MCP-Session-Id"] = self.session_id
            if self.protocol_version:
                headers["MCP-Protocol-Version"] = self.protocol_version
        connection = http.client.HTTPConnection("127.0.0.1", self.port, timeout=None)
        try:
            connection.request("POST", "/mcp", body=body, headers=headers)
            response = connection.getresponse()
            self._handle(message, response)
        finally:
            connection.close()

    def _handle(self, request: dict, response) -> None:
        """Разбирает ответ streamable HTTP и пересылает JSON-RPC в stdout."""
        status = response.status
        session_header = response.getheader("mcp-session-id")
        if request.get("method") == "initialize" and session_header:
            self.session_id = session_header
            log("Получен MCP-Session-Id ответа initialize")
        if status == 404:
            self.session_id = None
            log("Сервер закрыл сессию HTTP (404). Следующий initialize пойдёт без MCP-Session-Id.")
        if status == 202:
            response.read()
            log(f"POST {request.get('method') or 'response'} -> 202")
            if "method" in request and "id" in request:
                self._fail(request, "Vanessa MCP returned 202 for a request")
            return

        content_type = _media_type(response.getheader("Content-Type"))
        log(f"POST {request.get('method') or 'response'} -> {status} {content_type or 'no-content-type'}")
        if content_type == "text/event-stream":
            wrote_response = False
            for message in iter_sse(response):
                self._observe(request, message)
                self.framer.write_message(message)
                if self._is_response_to(request, message):
                    wrote_response = True
            if "method" in request and "id" in request and not wrote_response:
                self._fail(request, "Vanessa MCP event stream ended without a response")
            return

        raw = response.read()
        if not raw:
            if "method" in request and "id" in request:
                self._fail(request, f"Vanessa MCP HTTP {status} with an empty body")
            return
        try:
            message = json.loads(raw.decode("utf-8"))
        except json.JSONDecodeError:
            if "method" in request and "id" in request:
                self._fail(request, f"Vanessa MCP HTTP {status} is not JSON")
            else:
                log(f"Тело HTTP {status} не является JSON")
            return
        if not isinstance(message, dict):
            self._fail(request, "Vanessa MCP JSON body is not an object")
            return
        self._observe(request, message)
        self.framer.write_message(message)

    def _observe(self, request: dict, message: dict) -> None:
        """Запоминает согласованную версию протокола из ответа initialize."""
        if request.get("method") != "initialize":
            return
        result = message.get("result")
        if isinstance(result, dict) and isinstance(result.get("protocolVersion"), str):
            self.protocol_version = result["protocolVersion"]
            log(f"Согласована версия протокола {self.protocol_version}")
            return
        params = request.get("params")
        if self.protocol_version is None and isinstance(params, dict):
            requested = params.get("protocolVersion")
            if isinstance(requested, str):
                self.protocol_version = requested

    def _is_response_to(self, request: dict, message: dict) -> bool:
        """Сообщение является ответом JSON-RPC на исходный запрос."""
        return "id" in request and message.get("id") == request.get("id") and "method" not in message

    def _fail(self, request: dict, text: str) -> None:
        """Возвращает клиенту ошибку JSON-RPC, чтобы запрос с id не завис."""
        if "id" not in request or "method" not in request:
            log(text)
            return
        self.framer.write_message(
            {
                "jsonrpc": "2.0",
                "id": request["id"],
                "error": {"code": -32000, "message": text},
            }
        )


def main() -> None:
    """Точка входа командного MCP-сервера."""
    try:
        root = repo_root()
        port = read_mcp_port(root)
        ensure_vanessa(root, port)
        log(f"Мост к http://127.0.0.1:{port}/mcp")
        VaMcpStdioProxy(port).run()
    except BrokenPipeError:
        raise SystemExit(0)
    except SystemExit:
        raise
    except Exception as exc:
        detail = str(exc).splitlines()[0][:200]
        log(f"Прокси остановлен: {type(exc).__name__}: {detail}")
        raise SystemExit(1)


if __name__ == "__main__":
    main()
