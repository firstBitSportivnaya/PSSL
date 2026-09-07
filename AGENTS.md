# Агентский контракт PSSL

Репозиторий исходников конфигурации **Проектная библиотека подсистем** (ПБП / PSSL).

- Дамп: `src/cf` (`DUMP_PATH=src/cf`, source-set `main`). Расширение тестов: `src/cfe/YAXUnit` (source-set `YAXUNIT`).
- Имя конфигурации: `ПроектнаяБиблиотекаПодсистем`. Не подставлять `config_name` ERP.УХ / УТ и т.п. для фактов **этого** дампа.
- Префикс ядра: `пбп_`. Модули `пбп_Переадресация*` присутствуют.
- Платформа разработки: 8.3.23. Режим совместимости конфигурации: 8.3.18.
- Правило Cursor: `.cursor/rules/psslrule.mdc`. Skill: `pssl-library`.
- Unica: всегда `cwd` = корень workspace. Загрузка в ИБ и YaXUnit — `pssl-library` (отдельный `build` на каждый source-set, не `-AllExtensions`).
- Локальные пути ИБ и каталог платформы — только в `.dev.env` и `v8project.local.yaml` (не в Git). Шаблоны: `.dev.env.example`, `v8project.yaml.example`, `v8project.local.yaml.example`.
- Vanessa: CI — `tools/VBParams.json` и `tools/vrunner.json`. Локальный MCP — `tools/VBParams.local.json.example` → `tools/VBParams.local.json` и `tools/vrunner.local.json.example` → `tools/vrunner.local.json` (оба в `.gitignore`). User MCP `user-VanessaAutomation` (`http://localhost:9876/mcp`) после запуска 1С с `runMcp;mcpPort=9876`.
- Индекс Cursor: скопировать `.cursorignore.example` → `.cursorignore` (файл в `.gitignore`).
- MCP проекта не коммитится; используйте user MCP (Unica, BSL LS, Напарник, Vanessa).
