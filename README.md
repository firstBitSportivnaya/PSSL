# Проектная библиотека подсистем

[![Quality Gate Status](https://sonar.openbsl.ru/api/project_badges/measure?project=PSSL&metric=alert_status)](https://sonar.openbsl.ru/dashboard?id=PSSL)
[![Stars](https://img.shields.io/github/stars/firstBitSportivnaya/PSSL.svg?label=Github%20%E2%98%85&a)](https://github.com/firstBitSportivnaya/PSSL/stargazers)
[![Release](https://img.shields.io/github/v/release/firstBitSportivnaya/PSSL?include_prereleases&label=last%20release&style=badge)](https://github.com/firstBitSportivnaya/PSSL/releases/latest)
[![GitHub issues](https://img.shields.io/github/issues-raw/firstBitSportivnaya/PSSL?style=badge)](https://github.com/firstBitSportivnaya/PSSL/issues)
[![License](https://img.shields.io/github/license/firstBitSportivnaya/PSSL?style=badge)](https://github.com/firstBitSportivnaya/PSSL/blob/develop/LICENSE)
[![OpenYellow](https://img.shields.io/endpoint?url=https://openyellow.org/data/badges/4/751858948.json)](https://openyellow.org/grid?data=top&repo=751858948)

![image](https://repository-images.githubusercontent.com/751858948/a45ea547-c23c-4ce1-b30e-609d9ac8d558)

## Cписок подсистем

В библиотеке собраны подсистемы, реализующие методы для удобного расширения функциональности типовых конфигураций, максимально соответствуя регламенту разработки и облегчая будущую доработку и обновление этих конфигураций.

Реализованные на данный момент подсистемы:

1. [Предопределенные значения](docs/ПредопределенныеЗначения.md)
2. [Соответствия объектов ИБ](docs/СоответствиеОбъектовИнформационнойБазы.md)
3. [Программная модификация форм](docs/МодификацияФорм.md)
4. [Подписки на события](docs/ПодпискиНаСобытия.md)
5. Управление интеграциями
6. [Пользовательские функции](docs/ПользовательскиеФункции.md)
7. [Настройки отбора объектов](docs/ПолучениеДанныхПоНастройкеОтбора.md)
8. [Загрузка файла через табличный документ](docs/ЗагрузкаФайлаЧерезТабличныйДокумент.md)
9. [Переопределения методов БСП](docs/ПереопределениеМетодовБСП.md)

## Заимствованные разработки

1. [Коннектор: удобный HTTP-клиент](https://github.com/vbondarevsky/Connector)
2. [Динамическое Формирование Интерфейса](https://github.com/KotovDima1C/DFI)
3. [Консоль кода](https://github.com/salexdv/bsl_console)
4. [Просмотр файлов JSON с разметкой](https://github.com/plastinin/AllYouNeedIsLove)

## Информация для контрибьюторов

### Правила установки версии конфигурации

- Версия конфигурации ведется в [стандартном формате компании 1С](https://its.1c.ru/db/v8std/content/483/hdoc): редакция.подредакция.версия.сборка
- Номер сборки необходимо повышать при каждом PR (кроме PR меняющих скрипты/тесты/документацию)
- Номер версии повышается при значительной доработке существующей функциональности или добавлении новой подсистемы
- Номер подредакции повышается при полной переработке архитектуры
- Версия так же меняется в модуле пбп_ОбновлениеИнформационнойБазыПБП для корректной работы в связке с БСП

> Релиз выпускается при повышении версии конфигурации. Так же для анализа SonarQube версия проекта создается только для новых версий конфигурации, номер сборки игнорируется. Новый код вычисляется от версии проекта

### Версия платформы и режим совместимости

> Разработка ведется на версии 8.3.23
> Режим совместимости 8.3.18

### Руководство контрибьютора

1. [Руководство по написанию юнит-тестов YaXUnit](docs/РуководствоПоНаписаниюТестовYAxUnit.md)
