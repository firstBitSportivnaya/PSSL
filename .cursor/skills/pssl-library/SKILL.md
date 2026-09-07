---
name: pssl-library
description: >-
  Overlay репозитория PSSL (Проектная библиотека подсистем): ядро с префиксом
  пбп_, дамп src/cf, модули пбп_Переадресация*, загрузка в ИБ, тесты YaXUnit
  (YAXUNIT, модули ОМ_*). Использовать при правках этой библиотеки, прогоне
  yaxunit/юнит/ЮТТесты, правках src/cfe/YAXUnit, локальном Vanessa MCP;
  не при адаптации ERP/УТ с другим префиксом. Unica — XML и поиск;
  1c-pssl — карта подсистем при встраивании в чужую КФ.
---

# pssl-library — ядро ПБП в этом репозитории

Дамп: `src/cf` (source-set `main`). Конфигурация `ПроектнаяБиблиотекаПодсистем` (vendor Первый БИТ). Префикс **`пбп_`**. Разработка на платформе **8.3.27**, режим совместимости **8.3.24**.

Расширение тестов: `src/cfe/YAXUnit`, имя в метаданных `YAXUNIT` (source-set `YAXUNIT`). Это не `tools-download` артефакт.

Режим БСП: модули `пбп_Переадресация`, `пбп_ПереадресацияКлиент`, `пбп_ПереадресацияКлиентСервер` и ПовтИсп **есть**. Новые вызовы сервисов БСП в этом дампе — через переадресацию (`docs/ПереопределениеМетодовБСП.md`), не напрямую `ОбщегоНазначения.*`, если для метода есть обёртка.

Это **исходники библиотеки**, не готовое внедрение в типовую конфигурацию.

Общий контракт Unica — `v8project.yaml`. ИБ и платформа — только `v8project.local.yaml`. Те же пины в `.dev.env`. `cwd` — абсолютный корень workspace (см. `psslrule.mdc`).

## Куда класть правки

- Новые объекты и общие модули ядра — с префиксом `пбп_`, в существующих подсистемах ПБП (`docs/*.md`).
- Формы и подписки библиотеки — по документации подсистем и user skill `1c-pssl` (имена с `пбп_`).
- Обработка первого внедрения — `src/epf`, не смешивать с дампом КФ без нужды.
- XML форм/метаданных — Unica leaf (`form-*`, `meta-*`). Поиск по дампу — `unica_code_search` / `unica_source_resolve`.
- Правка BSL дампа — `unica_code_patch` (после `unica_source_resolve`). Не `StrReplace` / `Write` / `Shell` по `src/cf/**/*.bsl` и `src/cfe/YAXUnit/**/*.bsl`, пока `user-unica` готов.
- Сценарии YaXUnit — в `src/cfe/YAXUnit`, не в `src/cf`.

## Запреты для этого репозитория

- Не создавать объекты без префикса `пбп_`, если это не заимствованный код (Connector, DFI и т.п. уже в составе).
- Не удалять `пбп_Переадресация*` «как в конфигурации на полной БСП».
- Не копировать в модули пути локальной ИБ и не писать машинно-зависимые константы.

После правки BSL: Unica `unica_code_diagnostics` `findings` по модулю (`sourceSet=YAXUNIT` для тестов), если `user-unica` готов; иначе LS. Затем Напарник `check_1c_code` → `review_1c_code`, без двойного синтаксиса на одном файле.

## Загрузка в ИБ

В `build` передавать `sourceSet`, не параметр `extension`.

1. Закрыть клиент/конфигуратор (`1cv8` / `1cv8c`) — Designer занимает базу эксклюзивно.
2. Пользователь явно просил загрузить. КФ: `unica_runtime_job_start` `operation=build` `sourceSet=main` `fullRebuild=true` `dryRun=false`.
3. Затем тесты: тот же вызов с `sourceSet=YAXUNIT` `fullRebuild=true`. Не один `build` «на все расширения».
4. Смотреть `unica_runtime_job_wait` / `unica_runtime_job_logs`. Пустой лог до конца у обычного build — норма.

`build` грузит XML и обновляет конфигурацию БД **этого** source-set. Не вызывать `unica_build_*`. Не обходить `unica_runtime_*` прямым `v8-runner.exe`. Длинный build — только `job.start`, не синхронный `unica_runtime_execute`.

После `/LoadCfg` в Конфигураторе: `/UpdateDBCfg` без `-Extension` для основной КФ, затем `/UpdateDBCfg -Extension YAXUNIT` (не безопасный режим). Флаг `-AllExtensions` не использовать.

## YaXUnit — написание

Канон: `docs/РуководствоПоНаписаниюТестовYAxUnit.md`. Параметры CI: `tools/yaxunit.json`. Дизайн тестов Unica `test-authoring` — общее; пины и запуск — здесь.

- Модуль теста: `ОМ_<Объект>` (существующие: `ОМ_ПредопределенныеЗначения`, `ОМ_КоннекторHTTP`, …).
- Экспорт `ИсполняемыеСценарии()` → `ЮТТесты.ДобавитьТестовыйНабор` / `ДобавитьТест` / `СПараметрами`.
- Утверждения: `ЮТест.ОжидаетЧто(...)`.
- Не менять движок `ЮТ*` без явной просьбы.

## YaXUnit — applied-запуск

Только если пользователь просил выполнить тесты. Preview (`dryRun=true`) не считать прогоном. Сначала загрузить `main` и `YAXUNIT` (раздел выше).

`unica_runtime_job_start` `operation=test` `testRunner=yaxunit` `dryRun=false`:

- весь набор: `testScope=all`;
- модуль: `testScope=module`, `module=CommonModule.ОМ_…` (например `CommonModule.ОМ_ПредопределенныеЗначения`);
- `fullOutput=true` — полный вывод раннера (это не `fullRebuild`).

Наблюдать `unica_runtime_job_wait` / `unica_runtime_job_logs`. Артефакты: `tools/yaxunit.json` → `./build/out/yaxunit/`. Сохранить путь при падении.

Не `testRunner=va`, если речь про YaXUnit. Не выдумывать пути фич.

Если Unica недоступен и пользователь просил прогон: параметры `tools/yaxunit.json`, подключение ИБ из `.dev.env` / `tools/vrunner.json`. Не выдумывать ключи платформы.

## Vanessa Automation (MCP)

Последовательность инструментов — skill `vanessa-automation`. `project-notes.md` DemoSSL не применять. Пины и автоподъём — `.cursor/rules/psslrule.mdc`.

CI/Jenkins: `tools/VBParams.json`. Пакетный Unica `test` `va`: `tools/VBParams.local.json` (gitignore). Живой MCP: `tools/va/VAParams.json` (`ВыполнитьСценарии` = false), скрипт `tools/va/Start-VanessaMcp.ps1`.

Если `user-VanessaAutomation` `error` или порт не слушает `1cv8c`: Shell `tools/va/Start-VanessaMcp.ps1` (без Bypass), затем `GetDynamicTools` / `get_VanessaAutomation_state`. Прогон фич — `run_scenario`, не Unica `test` `va`. Не `unica launch mcp-va` applied. Не использовать Vanessa MCP для фактов дампа XML (это Unica).
