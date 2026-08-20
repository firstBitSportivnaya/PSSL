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

echo ">>> Проверка Java..."
if ! command -v java >/dev/null 2>&1; then
  echo "ОШИБКА: java не найдена в PATH. BSL Language Server требует JRE 21+." >&2
  exit 1
fi
java -version

echo ">>> Установка BSL Language Server ${BSL_LS_VERSION}..."
sudo mkdir -p "${BSL_LS_DIR}"
sudo chown "$(id -u):$(id -g)" "${BSL_LS_DIR}"

installed_version=""
if [ -f "${BSL_LS_JAR}" ]; then
  installed_version="$(java -jar "${BSL_LS_JAR}" --version 2>/dev/null | sed -n 's/^version: //p' || true)"
fi

if [ "${installed_version}" = "${BSL_LS_VERSION}" ]; then
  echo "BSL Language Server ${BSL_LS_VERSION} уже установлен — пропускаем загрузку."
else
  echo "Загрузка ${BSL_LS_URL}"
  curl -fsSL -o "${BSL_LS_JAR}" "${BSL_LS_URL}"
fi

echo ">>> Создание обёртки /usr/local/bin/bsl-ls..."
sudo tee /usr/local/bin/bsl-ls >/dev/null <<'EOF'
#!/usr/bin/env bash
# Обёртка для запуска BSL Language Server.
exec java -Xmx4g -jar /opt/bsl-language-server/bsl-language-server.jar "$@"
EOF
sudo chmod 0755 /usr/local/bin/bsl-ls

echo ">>> Готово. Версия: $(bsl-ls --version)"
