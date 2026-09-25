# Агентский контракт PSSL

Репозиторий исходников конфигурации **Проектная библиотека подсистем** (ПБП / PSSL).

- Конфигурация: `src/cf` (`DUMP_PATH=src/cf`, source-set `main`). Расширение тестов: `src/cfe/YAXUnit` (source-set `YAXUNIT`, движок YAxUnit **25.12**). Руководство: `docs/РуководствоПоНаписаниюТестовYAxUnit.md`.
- Имя конфигурации: `ПроектнаяБиблиотекаПодсистем`. Не подставлять `config_name` ERP.УХ / УТ и т.п. для фактов **этой** выгрузки конфигурации.
- Префикс ядра: `пбп_`. Модули `пбп_Переадресация*` присутствуют.
- Платформа разработки: 8.3.27. Режим совместимости конфигурации: 8.3.24.
- Правило Cursor: `.cursor/rules/psslrule.mdc` (единственный alwaysApply). Фичи Jenkins: `.cursor/rules/vanessa-jenkins.mdc` (`features/**/*.feature`). Skill ядра: `pssl-library`. Skill конвейера Issue: `pssl-pr-flow` (один клон из `WORKSPACE_ROOT` в `.dev.env`, без отдельного git worktree). CodeRabbit — комментарии `coderabbitai[bot]` в GitHub PR после открытия (skill `pssl-pr-flow`). Локальный CLI — skill `coderabbit-review`, только по отдельной просьбе, не шаг ревьюера.
- Unica: `cwd` = `WORKSPACE_ROOT` из `.dev.env`. Пока MCP готов — правки BSL/XML только Unica (`unica_code_patch` и leaf write), не правкой файлов напрямую. Загрузка в ИБ и YaXUnit — `pssl-library`, на фазе тестировщика `pssl-pr-flow` в той же сессии, сразу после записи запрошенного объёма в исходники (отдельный `build` на каждый source-set, не `-AllExtensions`). Пока код ещё пишется, сеансы не закрывать и тесты не запускать. Если `/F` у `1cv8c` совпадает с `INFOBASE_PATH`, закрыть только этот сеанс и продолжать загрузку. Сеансы другой ИБ не завершать.
- Локальные пути ИБ и каталог платформы — только в `.dev.env` и `v8project.local.yaml` (не в Git). Шаблоны: `.dev.env.example`, `v8project.yaml.example`, `v8project.local.yaml.example`.
- Vanessa: протокол MCP — user rule `ui-testing-tools` и skill `vanessa-automation` (все проекты). Старт — общий `Start-VanessaMcp.ps1 -RepoRoot` (корень клона). Пины этого репозитория: каталог и очистка — `pssl-library`, Jenkins — `.cursor/rules/vanessa-jenkins.mdc`, CI — `tools/VBParams.json`, пакетный Unica `test` `va` — `tools/VBParams.local.json` (gitignore), живой MCP — `tools/VAParams.json`. Фичи — через Vanessa MCP, не через Unica `test` `va`. Не путать с Unica dump/build.
- Индекс Cursor: скопировать `.cursorignore.example` → `.cursorignore` (файл в `.gitignore`).
- MCP проекта не коммитится; используйте user MCP (Unica, BSL LS, Напарник, Vanessa).
