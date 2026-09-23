#!/usr/bin/env bash
#
# Установка инструментов разработки для библиотеки PSSL.
#
# Ставит:
# - BSL Language Server (статический анализатор кода 1С/BSL) — тот же
#   анализатор, что используется на стадии SonarQube в CI;
# - MCP Inspector (https://github.com/modelcontextprotocol/inspector) —
#   веб, CLI и TUI для отладки MCP-серверов, команда mcp-inspector.
# Скрипт идемпотентен: при повторном запуске повторно ничего не скачивает,
# если нужная версия уже установлена.
#
# Примечание: полный набор проверок проекта (edtValidate, syntaxCheck,
# YAXUnit, BDD, smoke) выполняется через vanessa-runner и требует
# проприетарной платформы 1С:Предприятие, которую нельзя установить без
# лицензии, поэтому в это окружение она не входит.

set -euo pipefail

BSL_LS_VERSION="1.0.7"
INSPECTOR_VERSION="2.7.0"
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

echo ">>> Установка MCP Inspector ${INSPECTOR_VERSION}..."

inspector_node_ok() {
  "$1" -e 'const p=process.versions.node.split(".").map(Number); if(!(p[0]>22||(p[0]===22&&p[1]>=19))) process.exit(1)'
}

if [ -s "${HOME}/.nvm/nvm.sh" ]; then
  # nvm.sh читает необязательные переменные и падает при set -u.
  set +u
  # shellcheck disable=SC1091
  . "${HOME}/.nvm/nvm.sh"
  set -u
fi

INSPECTOR_NODE=""
declare -a inspector_node_candidates=()
if [ -d "${HOME}/.nvm/versions/node" ]; then
  while IFS= read -r candidate; do
    inspector_node_candidates+=("${candidate}")
  done < <(find "${HOME}/.nvm/versions/node" -mindepth 2 -maxdepth 3 -type f -path '*/bin/node' | sort -V -r)
fi
if command -v node >/dev/null 2>&1; then
  inspector_node_candidates+=("$(command -v node)")
fi

if [ "${#inspector_node_candidates[@]}" -gt 0 ]; then
  for candidate in "${inspector_node_candidates[@]}"; do
    if [ -x "${candidate}" ] && inspector_node_ok "${candidate}"; then
      INSPECTOR_NODE="${candidate}"
      break
    fi
  done
fi

if [ -z "${INSPECTOR_NODE}" ] && command -v nvm >/dev/null 2>&1; then
  echo "Node.js >= 22.19 не найден, ставим ветку 22 через nvm..."
  set +u
  nvm install 22 >&2
  INSPECTOR_NODE="$(nvm which 22)"
  set -u
  if ! [ -x "${INSPECTOR_NODE}" ] || ! inspector_node_ok "${INSPECTOR_NODE}"; then
    INSPECTOR_NODE=""
  fi
fi

if [ -z "${INSPECTOR_NODE}" ]; then
  echo "ОШИБКА: MCP Inspector требует Node.js >= 22.19." >&2
  exit 1
fi

echo "Node для Inspector: $("${INSPECTOR_NODE}" -v) (${INSPECTOR_NODE})"

NPM_CLI="$(cd "$(dirname "${INSPECTOR_NODE}")/../lib/node_modules/npm/bin" && pwd)/npm-cli.js"
if [ ! -f "${NPM_CLI}" ]; then
  echo "ОШИБКА: npm не найден рядом с ${INSPECTOR_NODE}" >&2
  exit 1
fi

run_npm() {
  "${INSPECTOR_NODE}" "${NPM_CLI}" "$@"
}

INSPECTOR_DIR="/opt/mcp-inspector"
INSPECTOR_PKG="${INSPECTOR_DIR}/node_modules/@modelcontextprotocol/inspector/package.json"
INSPECTOR_LAUNCHER="${INSPECTOR_DIR}/node_modules/@modelcontextprotocol/inspector/clients/launcher/build/index.js"
installed_inspector=""
if [ -f "${INSPECTOR_PKG}" ]; then
  installed_inspector="$("${INSPECTOR_NODE}" -p "require(process.argv[1]).version" "${INSPECTOR_PKG}")"
fi

if [ "${installed_inspector}" = "${INSPECTOR_VERSION}" ] && [ -f "${INSPECTOR_LAUNCHER}" ]; then
  echo "MCP Inspector ${INSPECTOR_VERSION} уже установлен — пропускаем загрузку."
else
  echo "Загрузка @modelcontextprotocol/inspector@${INSPECTOR_VERSION}"
  sudo mkdir -p "${INSPECTOR_DIR}"
  sudo chown "$(id -u):$(id -g)" "${INSPECTOR_DIR}"
  if [ ! -f "${INSPECTOR_DIR}/package.json" ]; then
    printf '%s\n' '{"name":"mcp-inspector-install","private":true}' > "${INSPECTOR_DIR}/package.json"
  fi
  (
    cd "${INSPECTOR_DIR}"
    run_npm install --omit=dev "@modelcontextprotocol/inspector@${INSPECTOR_VERSION}"
  )
fi

if [ ! -f "${INSPECTOR_LAUNCHER}" ]; then
  echo "ОШИБКА: не найден launcher MCP Inspector: ${INSPECTOR_LAUNCHER}" >&2
  exit 1
fi

sudo tee /usr/local/bin/mcp-inspector >/dev/null <<EOF
#!/usr/bin/env bash
exec ${INSPECTOR_NODE} ${INSPECTOR_LAUNCHER} "\$@"
EOF
sudo chmod 0755 /usr/local/bin/mcp-inspector

# Каталог bin выбранного Node стоит в PATH раньше /usr/local/bin.
nvm_inspector_bin="$(dirname "${INSPECTOR_NODE}")/mcp-inspector"
if [ -e "${nvm_inspector_bin}" ]; then
  rm -f "${nvm_inspector_bin}"
fi

installed_inspector="$("${INSPECTOR_NODE}" -p "require(process.argv[1]).version" "${INSPECTOR_PKG}")"
echo ">>> Готово. BSL LS: $(bsl-ls --version); MCP Inspector: ${installed_inspector}"
