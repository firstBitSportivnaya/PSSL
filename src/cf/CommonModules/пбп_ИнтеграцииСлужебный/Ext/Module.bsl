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

#Область СлужебныйПрограммныйИнтерфейс

#Область ИсторияИнтеграции

// Функция возвращает структуру со всеми необходимыми значениями для заполнения записи истории интеграции
//
// Возвращаемое значение:
//  Структура - описание свойств истории интеграции
//
Функция ПолучитьСтруктуруЗаписиИстории() Экспорт
	
	СтруктураЗаписиИстории = Новый Структура;
	СтруктураЗаписиИстории.Вставить("ИнтеграционныйПоток",		Неопределено);
	СтруктураЗаписиИстории.Вставить("ВходящееСообщение",		"");
	СтруктураЗаписиИстории.Вставить("ИсходящееСообщение",		"");
	СтруктураЗаписиИстории.Вставить("ИнтегрируемаяСистема",		Неопределено);
	СтруктураЗаписиИстории.Вставить("ОписаниеОшибки",			"");
	СтруктураЗаписиИстории.Вставить("ПротоколОбмена",			"");
	СтруктураЗаписиИстории.Вставить("ДатаНачалаИнтеграции",		ТекущаяДатаСеанса());
	СтруктураЗаписиИстории.Вставить("ДлительностьВызова",		0);
	СтруктураЗаписиИстории.Вставить("ФорматИнтеграции",			Перечисления.пбп_ФорматыИнтеграций.XML);
	СтруктураЗаписиИстории.Вставить("ИмяФайлаСообщения",		"");
	СтруктураЗаписиИстории.Вставить("ФайлСообщения",			Неопределено);
	ОбъектыИнтеграции = Новый ТаблицаЗначений;
	ОбъектыИнтеграции.Колонки.Добавить("ОбъектИнтеграции");
	ОбъектыИнтеграции.Колонки.Добавить("СозданОбновлен");
	СтруктураЗаписиИстории.Вставить("ОбъектыИнтеграции", ОбъектыИнтеграции);
	
	Возврат СтруктураЗаписиИстории;
	
КонецФункции

// Процедура создает запись справочника История интеграции с информацией о событии интеграции
//
// Параметры:
//	СтруктураЗаписиИстории - Структура - описание действия (см. ПолучитьСтруктуруЗаписиИстории)
//	ЭтоЗагрузка - Булево - Истина если это Загрузка, Ложь если это Выгрузка
//
Процедура СоздатьСообщениеИсторииИнтеграции(СтруктураЗаписиИстории, ЭтоЗагрузка) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДополнительноОбработатьЗапросыИнтеграцииПередЗаписьюВИсторию(СтруктураЗаписиИстории);
	
	НовоеСообщение = Справочники.пбп_ИсторияИнтеграции.СоздатьЭлемент();
	НовоеСообщение.ДатаИнтеграции = ТекущаяДатаСеанса();
	НовоеСообщение.ДатаИнтеграцииВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
	НовоеСообщение.Код = Новый УникальныйИдентификатор();
	НовоеСообщение.Ошибка = ЗначениеЗаполнено(СтруктураЗаписиИстории.ОписаниеОшибки);
	НовоеСообщение.Пользователь = пбп_ПользователиСлужебный.ТекущийПользователь();
	НовоеСообщение.ДлительностьОбмена = НовоеСообщение.ДатаИнтеграции - СтруктураЗаписиИстории.ДатаНачалаИнтеграции;
	НовоеСообщение.ДлительностьВызова = СтруктураЗаписиИстории.ДлительностьВызова;
	Если ЭтоЗагрузка Тогда
		Если НовоеСообщение.Ошибка Тогда
			НовоеСообщение.Статус = Перечисления.пбп_СтатусыИнтеграции.ОшибкаЗагрузки;
		Иначе
			НовоеСообщение.Статус = Перечисления.пбп_СтатусыИнтеграции.Загружено;
		КонецЕсли;
	Иначе
		Если НовоеСообщение.Ошибка Тогда
			НовоеСообщение.Статус = Перечисления.пбп_СтатусыИнтеграции.ОшибкаВыгрузки;
		Иначе
			НовоеСообщение.Статус = Перечисления.пбп_СтатусыИнтеграции.Выгружено;
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(НовоеСообщение, СтруктураЗаписиИстории);
	Для Каждого Строка Из СтруктураЗаписиИстории.ОбъектыИнтеграции Цикл
		НоваяСтрока = НовоеСообщение.ОбъектыИнтеграции.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
	КонецЦикла;
	
	НовоеСообщение.Записать();
	
КонецПроцедуры

// Процедура добавляет сообщения в протокол обмена через указанный разделитель
// 
// Параметры:
//  СтруктураОтвета - Структура - см. ИнтеграцииСервер.ПолучитьСтруктуруЗаписиИстории
//  ТекстСообщения - Строка - Текст, который будет записан в протокол обмена
//  Разделитель - Строка - Разделитель записей
Процедура ДобавитьЗаписьВПротоколОбмена(СтруктураОтвета, ТекстСообщения, Разделитель = "") Экспорт
	
	Если ПустаяСтрока(Разделитель) Тогда
		Разделитель = ";" + Символы.ПС;
	КонецЕсли;
	
	ВыводРазделителя = ?(ПустаяСтрока(СтруктураОтвета.ПротоколОбмена), "", Разделитель);
	
	СтруктураОтвета.ПротоколОбмена = СтруктураОтвета.ПротоколОбмена + ВыводРазделителя + НСтр(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти // ИсторияИнтеграции

#Область РаботаСДанными

// Возвращает структуру с настройками для интеграции
//
// Параметры:
//  НастройкаИнтеграции - СправочникСсылка.пбп_НастройкиИнтеграции - Ссылка на элемент справочника Настройки интеграции
//
// Возвращаемое значение:
//  Структура
Функция ПолучитьСтруктуруНастроекИнтеграции(НастройкаИнтеграции) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СтруктураНастроек = пбп_ОбщегоНазначенияСлужебный.ЗначенияРеквизитовОбъекта(
		НастройкаИнтеграции, "СтрокаПодключения, Порт, ИмяОбъекта");
	ДанныеБезопасногоХранилища = пбп_ОбщегоНазначенияСлужебный.ПрочитатьДанныеИзБезопасногоХранилища(НастройкаИнтеграции);
	
	Для Каждого КлючИЗначение Из ДанныеБезопасногоХранилища Цикл
		СтруктураНастроек.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру с настройками для интеграции
//
// Параметры:
//  ИнтеграционныйПоток - СправочникСсылка.пбп_ИнтеграционныеПотоки - Ссылка на элемент справочника интеграционные потоки
//
// Возвращаемое значение:
//  Структура
Функция ПолучитьСтруктуруПотокаИНастроекИнтеграции(ИнтеграционныйПоток) Экспорт
	
	СтруктураПотокаИНастроек = пбп_ОбщегоНазначенияСлужебный.ЗначенияРеквизитовОбъекта(
		ИнтеграционныйПоток, "НастройкаИнтеграции, ТочкаВхода");
	СтруктураНастроек = ПолучитьСтруктуруНастроекИнтеграции(СтруктураПотокаИНастроек.НастройкаИнтеграции);
	пбп_ОбщегоНазначенияСлужебныйКлиентСервер.ДополнитьСтруктуру(СтруктураПотокаИНастроек, СтруктураНастроек);
	
	Возврат СтруктураПотокаИНастроек;
	
КонецФункции

// Получает структуру параметров интеграционного потока со значениями по умолчанию
//
// Параметры:
//  ИнтеграционныйПоток - СправочникСсылка.пбп_ИнтеграционныеПотоки - ссылка на метод, параметры которого получаем.
//  ЗаполнятьПоУмолчанию - Булево - добавлять ли в возвращаемую структуру значения по умолчанию
//    - Ложь - возвращает структуру вида ИмяПараметра<Строка>:ТипЗначения<ПеречислениеСсылка.пбп_ТипыJSON>
//    - Истина - возвращает структуру вида ИмяПараметра<Строка>:ЗначениеПоУмолчанию<Строка>
//
// Возвращаемое значение:
//   Структура
//
Функция ПолучитьСтруктуруПараметровВхода(ИнтеграционныйПоток, ЗаполнятьПоУмолчанию = Ложь) Экспорт

	Возврат Справочники.пбп_ИнтеграционныеПотоки.ПолучитьСтруктуруПараметровВхода(
		ИнтеграционныйПоток, ЗаполнятьПоУмолчанию);

КонецФункции

// Получает предопределенный метод интеграции по идентификатору настройки
//
// Параметры:
//  ИдентификаторНастройки - Строка - строковый идентификатор предопределенного значения, реквизит ИдентификаторНастройки
//
// Возвращаемое значение:
//  СправочникСсылка.пбп_МетодыИнтеграции - искомый метод интеграции
//
Функция ИнтеграционныйПоток(ИдентификаторНастройки) Экспорт
	Возврат Справочники.пбп_ИнтеграционныеПотоки.НайтиПоРеквизиту("ИдентификаторНастройки", ИдентификаторНастройки);
КонецФункции

// Получает предопределенную интегрируемую систему по идентификатору настройки
//
// Параметры:
//  ИдентификаторНастройки - Строка - строковый идентификатор предопределенного значения, реквизит ИдентификаторНастройки
//
// Возвращаемое значение:
//  СправочникСсылка.пбп_ИнтегрируемыеСистемы - искомая система интеграции
//
Функция ИнтегрируемаяСистема(ИдентификаторНастройки) Экспорт
	Возврат Справочники.пбп_ИнтегрируемыеСистемы.НайтиПоРеквизиту("ИдентификаторНастройки", ИдентификаторНастройки);
КонецФункции

// Получает предопределенную настройку интеграции по идентификатору настройки
//
// Параметры:
//  ИдентификаторНастройки - Строка - строковый идентификатор предопределенного значения, реквизит ИдентификаторНастройки
//
// Возвращаемое значение:
//  СправочникСсылка.пбп_НастройкиИнтеграции - искомая настройка интеграции
//
Функция НастройкаИнтеграции(ИдентификаторНастройки) Экспорт
	Возврат Справочники.пбп_НастройкиИнтеграции.НайтиПоРеквизиту("ИдентификаторНастройки", ИдентификаторНастройки);
КонецФункции

#КонецОбласти // РаботаСДанными

#КонецОбласти // СлужебныйПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

// Процедура обрабатывает запросы в структуре записи истории
//
// Параметры:
//  СтруктураЗаписиИстории - Структура - см. ПолучитьСтруктуруЗаписиИстории
//
Процедура ДополнительноОбработатьЗапросыИнтеграцииПередЗаписьюВИсторию(СтруктураЗаписиИстории)
	
	Если НЕ ПустаяСтрока(СтруктураЗаписиИстории.ИсходящееСообщение)
		И СтрНайти(СтруктураЗаписиИстории.ИсходящееСообщение, "xml") <> 0 Тогда
		
		ОчиститьДлинныеАтрибутыСообщенияXML(СтруктураЗаписиИстории.ИсходящееСообщение);
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(СтруктураЗаписиИстории.ВходящееСообщение)
		И СтрНайти(СтруктураЗаписиИстории.ВходящееСообщение, "xml") <> 0 Тогда
		
		ОчиститьДлинныеАтрибутыСообщенияXML(СтруктураЗаписиИстории.ВходящееСообщение);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура очищает XML строку от длинных записей (например base64 строк)
//
// Параметры:
//  XMLСтрока - Строка - XML-текст, которые необходимо преобразовать
//
Процедура ОчиститьДлинныеАтрибутыСообщенияXML(XMLСтрока)
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLСтрока);
	
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	ТребуетсяПерезаписатьXML = Ложь;
	
	// Перебрать все узлы
	МаксимальныйРазмерСтроки = 1000;
	ИтераторДерева = Новый ОбходДереваDOM(ДокументDOM);
	Пока ИтераторДерева.СледующийУзел() <> Неопределено Цикл
		Если ТипЗнч(ИтераторДерева.ТекущийУзел) = Тип("ЭлементDOM") Тогда
			Если СтрДлина(ИтераторДерева.ТекущийУзел.ТекстовоеСодержимое) > МаксимальныйРазмерСтроки Тогда
				ИтераторДерева.ТекущийУзел.ТекстовоеСодержимое = "X";
				ТребуетсяПерезаписатьXML = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если ТребуетсяПерезаписатьXML Тогда
		
		ЗаписьXML = Новый ЗаписьXML;
		ЗаписьXML.УстановитьСтроку(Новый ПараметрыЗаписиXML(, , Истина, Истина));
		
		ЗаписьDOM = Новый ЗаписьDOM;
		ЗаписьDOM.Записать(ДокументDOM, ЗаписьXML);
		
		XMLСтрока = ЗаписьXML.Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции