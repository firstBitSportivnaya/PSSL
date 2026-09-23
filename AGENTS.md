# Агентский контракт PSSL

Репозиторий исходников конфигурации **Проектная библиотека подсистем** (ПБП / PSSL).

- Дамп: `src/cf` (`DUMP_PATH=src/cf`, source-set `main`). Расширение тестов: `src/cfe/YAXUnit` (source-set `YAXUNIT`, движок YAxUnit **25.12**). Руководство: `docs/РуководствоПоНаписаниюТестовYAxUnit.md`.
- Имя конфигурации: `ПроектнаяБиблиотекаПодсистем`. Не подставлять `config_name` ERP.УХ / УТ и т.п. для фактов **этого** дампа.
- Префикс ядра: `пбп_`. Модули `пбп_Переадресация*` присутствуют.
- Платформа разработки: 8.3.27. Режим совместимости конфигурации: 8.3.24.
- Правило Cursor: `.cursor/rules/psslrule.mdc` (единственный alwaysApply). Фичи Jenkins: `.cursor/rules/vanessa-jenkins.mdc` (`features/**/*.feature`). Skill: `pssl-library`. CodeRabbit CLI: skill `coderabbit-review` (база `develop`, не пользовательский `code-review`).
- Unica: всегда `cwd` = корень workspace. Пока MCP готов — правки дампа BSL/XML только Unica (`unica_code_patch` и leaf write), не правкой файлов напрямую. Загрузка в ИБ и YaXUnit — `pssl-library` (отдельный `build` на каждый source-set, не `-AllExtensions`).
- Локальные пути ИБ и каталог платформы — только в `.dev.env` и `v8project.local.yaml` (не в Git). Шаблоны: `.dev.env.example`, `v8project.yaml.example`, `v8project.local.yaml.example`.
- Vanessa: CI — `tools/VBParams.json`. Живой MCP — `tools/va/Start-VanessaMcp.ps1` (тест-менеджер `/TESTMANAGER`). Если в этой сессии `9876` не слушает `1cv8c` — сначала этот скрипт, затем `mcp_auth`. MCP не `ready` — **не писать `.feature`**. После правки фичи — `run_scenario`; копирование шагов не заменяет прогон. Канон фич — skill `pssl-library`. Jenkins — `.cursor/rules/vanessa-jenkins.mdc` (выпадающий список фиксировать до ввода другого поля; не `ВвестиТекст` в PasswordMode). Пакетный Unica `test` `va` — `tools/VBParams.local.json` (gitignore). Не путать с Unica dump/build.
- Индекс Cursor: скопировать `.cursorignore.example` → `.cursorignore` (файл в `.gitignore`).
- MCP проекта не коммитится; используйте user MCP (Unica, BSL LS, Напарник, Vanessa).
