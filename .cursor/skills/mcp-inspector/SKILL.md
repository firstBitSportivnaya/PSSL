---
name: mcp-inspector
description: >-
  Проверка MCP-сервера через CLI mcp-inspector: initialize, tools/list,
  resources/list, prompts/list, tools/call. Используй, когда пользователь
  просит inspector, mcp-inspector, handshake, список tools или smoke MCP,
  и когда правка меняет контракт MCP-сервера. Веб и TUI не запускать, пока
  явно не просили окно. Не подменяет Unica, Vanessa и Напарник.
---

# MCP Inspector (PSSL)

Команда `mcp-inspector`. Пакет `@modelcontextprotocol/inspector` **2.7.0** ставит `.cursor/install.sh` в `/opt/mcp-inspector`. Обёртка `/usr/local/bin/mcp-inspector` вызывает Node.js не ниже 22.19. Версию пакета и обёртку не менять, пока пользователь не попросил.

Inspector — клиент проверки. Серверы Cursor по-прежнему в `mcp.json`. Unica, Vanessa и Напарник этим CLI не заменять.

## Когда запускать

Пользователь просит проверить MCP-сервер, либо без прогона нельзя подтвердить, что сервер отвечает и отдаёт заявленные tools.

Дамп 1С, YaXUnit и Vanessa-фичи этим skill не проверять.

Агенту — только `--cli`. Веб (`mcp-inspector` без режима) и `--tui` поднимают интерфейс. Их запускать, только если пользователь просил окно.

## Вызов

Режим `--cli` — первый флаг. Дальше аргументы уходят CLI. На каждый шаг отдельный процесс. Всегда `--format json` и `--connect-timeout 10000` (`0` не ставить: зависший хост не отпустит шаг).

Порядок для незнакомого сервера: `initialize`, затем `tools/list`, затем один безопасный `tools/call`, если пользователь назвал tool или без вызова вывод неполный. Вызов должен быть идемпотентным и без побочных эффектов.

stdio. Команда сервера идёт до флагов Inspector:

```bash
mcp-inspector --cli node build/index.js --connect-timeout 10000 --format json --method initialize
mcp-inspector --cli node build/index.js --connect-timeout 10000 --format json --method tools/list
mcp-inspector --cli node build/index.js --connect-timeout 10000 --format json \
  --method tools/call --tool-name my_tool --tool-args-json '{"q":"ping"}'
```

Флаги самого сервера — до `--`, флаги Inspector — после:

```bash
mcp-inspector --cli node build/index.js --config ./server.conf -- --method tools/list --format json --connect-timeout 10000
```

HTTP или SSE. Без браузерного входа — `--stored-auth-only`. Токен только заголовком. В URL и в аргументы stdio секреты не класть.

```bash
mcp-inspector --cli --transport http --server-url "$URL" \
  --connect-timeout 10000 --stored-auth-only --format json --method tools/list
```

Аргументы tool передавать `--tool-args-json`. `--tool-arg key=value` разбирает значение как JSON: строка из цифр уходит числом.

Список серверов каталога без подключения: `--method servers/list`.

`--catalog` (по умолчанию `~/.mcp-inspector/mcp.json`) Inspector может создать и записать. Чужой файл — `--config`, только чтение; если файла нет, CLI завершается с ошибкой. `--catalog`, `--config` и разовую команду или URL вместе не передавать.

stdout — результат. stderr — диагностика. В `jq` stderr не сливать.

Проверка, что tool есть (`jq` и `pipefail`, иначе ненулевой код CLI теряется за успешным `jq`):

```bash
mcp-inspector --cli node build/index.js --connect-timeout 10000 --format json --method tools/list \
  | jq -e '.result.tools | map(.name) | index("my_tool")' > /dev/null
```

Тот же приём для `.result.resources`, `.result.resourceTemplates`, `.result.prompts`.

## Коды выхода

| Код | Смысл |
| --- | --- |
| 0 | Успех |
| 1 | Ошибка вызова или непредвиденная ошибка |
| 2 | У инструмента нет MCP App (`--app-info`) |
| 3 | Нужна авторизация |
| 4 | Сервер недоступен |
| 5 | Ошибка инструмента (`isError` или tool не найден) |
| 6 | `--strict` нашёл ошибку переносимости схемы |

Ненулевой код — провал шага. Причина — последняя строка stderr (JSON `ErrorEnvelope`), поле `.error.code`. Код сохранить через `status=0; out=$(…) || status=$?`. Группа `|| { … }` подменяет код выхода успехом последней команды внутри группы.

`--strict` вместе с `tools/list` — когда схемы tools порождаются кодом и нужна проверка переносимости. Ошибки схемы дают код 6. Предупреждения код не меняют.

## Как отдать результат

Кратко по-русски: цель (команда или URL без секретов), метод, код выхода, `protocolVersion` и имена tools либо текст ошибки. Большой JSON не вставлять.

Токены, заголовок `Authorization` и прочие секреты в ответ не копировать.

## Правки

Код сервера менять только по просьбе исправить. Повторный прогон — те же методы, что показали сбой. За одну задачу не больше двух прогонов, пока пользователь не попросил ещё.
