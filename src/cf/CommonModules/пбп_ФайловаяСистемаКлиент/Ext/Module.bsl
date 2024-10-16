﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
// включая доработку типовых конфигураций.
//
// Copyright First BIT company
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
// URL:    https://github.com/firstBitSportivnaya/PSSL/
//

////////////////////////////////////////////////////////////////////////////////
// Файловая система клиент: аналог модуля БСП

#Область ПрограммныйИнтерфейс

// Аналог метода БСП. Получение имени временного каталога.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение о результате получения со следующими параметрами.
//    -- ИмяКаталога             - Строка - путь к созданному каталогу.
//    -- ДополнительныеПараметры - Структура - значение, которое было указано при создании объекта ОписаниеОповещения.
//  Расширение - Строка - суффикс в имени каталога, который поможет идентифицировать каталог при анализе.
//
Процедура СоздатьВременныйКаталог(Знач Оповещение, Расширение = "") Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Оповещение", Оповещение);
	Контекст.Вставить("Расширение", Расширение);
	
	Оповещение = Новый ОписаниеОповещения("СоздатьВременныйКаталогПослеПроверкиРасширенияРаботыСФайлами",
		пбп_ФайловаяСистемаСлужебныйКлиент, Контекст);
	ПодключитьРасширениеДляРаботыСФайлами(Оповещение, 
		НСтр("ru = 'Для создания временной папки установите расширение для работы с 1С:Предприятием.'"), Ложь);
	
КонецПроцедуры

// Аналог метода БСП. Предлагает пользователю установить расширение для работы с 1С:Предприятием в веб-клиенте.
// Предназначена для использования в начале участков кода, в которых ведется работа с файлами.
//
// Параметры:
//  ОписаниеОповещенияОЗакрытии - ОписаниеОповещения - описание процедуры, которая будет вызвана после закрытия
//          формы со следующими параметрами:
//    -- РасширениеПодключено - Булево - Истина, если расширение было подключено.
//    -- ДополнительныеПараметры - Произвольный - параметры, заданные в ОписаниеОповещенияОЗакрытии.
//  ТекстПредложения - Строка - текст сообщения. Если не указан, то выводится текст по умолчанию.
//  ВозможноПродолжениеБезУстановки - Булево - если Истина, будет показана кнопка ПродолжитьБезУстановки,
//          если Ложь, будет показана кнопка Отмена.
//
// Пример:
//
//  Оповещение = Новый ОписаниеОповещения("ПечатьДокументаЗавершение", ЭтотОбъект);
//  ТекстСообщения = НСтр("ru = 'Для печати документа необходимо установить расширение для работы с 1С:Предприятием.'");
//  ФайловаяСистемаКлиент.ПодключитьРасширениеДляРаботыСФайлами(Оповещение, ТекстСообщения);
//
//  Процедура ПечатьДокументаЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
//    Если РасширениеПодключено Тогда
//     // код печати документа, рассчитывающий на то, что расширение подключено.
//     // ...
//    Иначе
//     // код печати документа, который работает без подключенного расширения.
//     // ...
//    КонецЕсли;
//
Процедура ПодключитьРасширениеДляРаботыСФайлами(
		ОписаниеОповещенияОЗакрытии, 
		ТекстПредложения = "",
		ВозможноПродолжениеБезУстановки = Истина) Экспорт
	
	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриОтветеНаВопросОбУстановке", пбп_ФайловаяСистемаСлужебныйКлиент,
		ОписаниеОповещенияОЗакрытии);
	
#Если Не ВебКлиент Тогда
	// В мобильном, тонком и толстом клиентах расширение подключено всегда.
	ВыполнитьОбработкуОповещения(ОписаниеОповещенияЗавершение, "ПодключениеНеТребуется");
	Возврат;
#КонецЕсли
	
	Контекст = Новый Структура;
	Контекст.Вставить("ОписаниеОповещенияЗавершение", ОписаниеОповещенияЗавершение);
	Контекст.Вставить("ТекстПредложения",             ТекстПредложения);
	Контекст.Вставить("ВозможноПродолжениеБезУстановки", ВозможноПродолжениеБезУстановки);
	
	Оповещение = Новый ОписаниеОповещения(
		"НачатьПодключениеРасширенияРаботыСФайламиПриУстановкеРасширения", пбп_ФайловаяСистемаСлужебныйКлиент, Контекст);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс