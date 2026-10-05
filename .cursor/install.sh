#!/usr/bin/env bash
#
# Установка инструментов разработки для библиотеки PSSL.
#
# Ставит BSL Language Server (статический анализатор кода 1С/BSL) — тот же
# анализатор, что используется на стадии SonarQube в CI. Скрипт идемпотентен:
# при повторном запуске повторно ничего не скачивает, если нужная версия уже
# установлена.
#
# Примечание: полный набор проверок проекта (edtValidate, syntaxCheck,
# YAXUnit, BDD, smoke) выполняется через vanessa-runner и требует
# проприетарной платформы 1С:Предприятие, которую нельзя установить без
# лицензии, поэтому в это окружение она не входит.

set -euo pipefail

BSL_LS_VERSION="1.0.7"
BSL_LS_DIR="/opt/bsl-language-server"
BSL_LS_JAR="${BSL_LS_DIR}/bsl-language-server.jar"
BSL_LS_URL="https://github.com/1c-syntax/bsl-language-server/releases/download/v${BSL_LS_VERSION}/bsl-language-server-${BSL_LS_VERSION}-exec.jar"

java_major_of() {
  "$1" -version 2>&1 | sed -n 's/.*version "\([0-9]*\).*/\1/p' | head -n 1
}

echo ">>> Проверка Java..."
JAVA_BIN="$(command -v java || true)"
java_major=""
if [ -n "${JAVA_BIN}" ]; then
  java_major="$(java_major_of "${JAVA_BIN}")"
fi

if [ -z "${java_major}" ] || [ "${java_major}" -lt 21 ]; then
  echo "JRE 21+ не найдена — установка openjdk-21-jre-headless..."
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq openjdk-21-jre-headless
  # Альтернатива java может остаться на старой версии, поэтому берём бинарник 21 явно.
  JAVA_BIN="$(ls -1 /usr/lib/jvm/java-21-openjdk-*/bin/java 2>/dev/null | head -n 1 || true)"
  java_major=""
  if [ -n "${JAVA_BIN}" ]; then
    java_major="$(java_major_of "${JAVA_BIN}")"
  fi
fi

if [ -z "${java_major}" ] || [ "${java_major}" -lt 21 ]; then
  echo "ОШИБКА: после установки не найдена Java 21+ (найдено: '${JAVA_BIN:-нет}', major '${java_major:-нет}')." >&2
  exit 1
fi
"${JAVA_BIN}" -version

echo ">>> Установка BSL Language Server ${BSL_LS_VERSION}..."
sudo mkdir -p "${BSL_LS_DIR}"
sudo chown "$(id -u):$(id -g)" "${BSL_LS_DIR}"

installed_version=""
if [ -f "${BSL_LS_JAR}" ]; then
  installed_version="$("${JAVA_BIN}" -jar "${BSL_LS_JAR}" --version 2>/dev/null | sed -n 's/^version: //p' || true)"
fi

if [ "${installed_version}" = "${BSL_LS_VERSION}" ]; then
  echo "BSL Language Server ${BSL_LS_VERSION} уже установлен — пропускаем загрузку."
else
  echo "Загрузка ${BSL_LS_URL}"
  curl -fsSL -o "${BSL_LS_JAR}" "${BSL_LS_URL}"
fi

echo ">>> Создание обёртки /usr/local/bin/bsl-ls..."
sudo tee /usr/local/bin/bsl-ls >/dev/null <<EOF
#!/usr/bin/env bash
# Обёртка для запуска BSL Language Server на Java 21+.
exec "${JAVA_BIN}" -Xmx4g -jar "${BSL_LS_JAR}" "\$@"
EOF
sudo chmod 0755 /usr/local/bin/bsl-ls

echo ">>> Готово. Версия: $(bsl-ls --version)"
