# Рекомендации по ревью проекта

## Язык ревью

- Всегда делай ревью на русском языке

## Runtime

Облачный образ (`.cursor/install.sh`) ставит BSL Language Server и MCP Inspector (`mcp-inspector`, skill `mcp-inspector`). Прогон YaXUnit и загрузка КФ/CFE — на локальной машине через Unica (skill `pssl-library`), платформа 1С в этот образ не входит.