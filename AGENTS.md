# Агентский контракт PSSL

Репозиторий исходников конфигурации **Проектная библиотека подсистем** (ПБП / PSSL).

- Конфигурация: `src/cf` (`DUMP_PATH=src/cf`, source-set `main`). Расширение тестов: `src/cfe/YAXUnit` (source-set `YAXUNIT`, движок YAxUnit **25.12**). Руководство: `docs/РуководствоПоНаписаниюТестовYAxUnit.md`.
- Имя конфигурации: `ПроектнаяБиблиотекаПодсистем`. Не подставлять `config_name` ERP.УХ / УТ и т.п. для фактов **этого** дампа.
- Префикс ядра: `пбп_`. Модули `пбп_Переадресация*` присутствуют.
- Платформа разработки: 8.3.27. Режим совместимости конфигурации: 8.3.24.
- Правило Cursor: `.cursor/rules/psslrule.mdc` (единственный alwaysApply). Фичи Jenkins: `.cursor/rules/vanessa-jenkins.mdc` (`features/**/*.feature`). Skill: `pssl-library`. CodeRabbit CLI: skill `coderabbit-review` (база `develop`, не пользовательский `code-review`).
- Unica: процесс MCP из корня workspace. Аргумент `cwd` не дублировать, если здесь есть `v8project.yaml` (skill `unica-mcp`). Пока MCP готов — правки BSL/XML только Unica (`unica_code_patch` и leaf write), не правкой файлов напрямую. Загрузка в ИБ и YaXUnit — `pssl-library` (отдельный `build` на каждый source-set, не `-AllExtensions`).
- Локальные пути ИБ и каталог платформы — только в `.dev.env` и `v8project.local.yaml` (не в Git). Шаблоны: `.dev.env.example`, `v8project.yaml.example`, `v8project.local.yaml.example`.
- Vanessa: протокол MCP — user rule `ui-testing-tools` и skill `vanessa-automation` (все проекты). Пины этого репозитория: CI `tools/VBParams.json`, старт `tools/va/Start-VanessaMcp.ps1`. Stdio-мост — пользовательский инструмент, не файл репозитория. Поверх общего навыка: каталог и очистка — `pssl-library`, Jenkins — `.cursor/rules/vanessa-jenkins.mdc`. Пакетный Unica `test` `va` — `tools/VBParams.local.json` (gitignore). Не путать с Unica dump/build.
- Индекс Cursor: скопировать `.cursorignore.example` → `.cursorignore` (файл в `.gitignore`).
- MCP проекта не коммитится; используйте user MCP (Unica, BSL LS, Напарник, Vanessa).
