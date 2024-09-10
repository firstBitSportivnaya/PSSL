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

#Область ПрограммныйИнтерфейс

// Инициализирует предопределенные значения из таблицы.
//
// Параметры:
//  МенеджерОбъекта - СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
//
Процедура ИнициализироватьПредопределенныеЗначения(МенеджерОбъекта) Экспорт
	
	ТипЗначения = ТипЗнч(МенеджерОбъекта);
	Если ТипЗначения = Тип("ПланВидовХарактеристикМенеджер.пбп_ПредопределенныеЗначения") Тогда
		ТЗПредопределенныхЗначений = пбп_ПредопределенныеЗначенияПереопределяемый.ПредопределенныеЗначения();
	ИначеЕсли ТипЗначения = Тип("СправочникМенеджер.пбп_ИнтегрируемыеСистемы") Тогда
		ТЗПредопределенныхЗначений =
			пбп_ПредопределенныеЗначенияПереопределяемый.ПредопределенныеЗначенияИнтегрируемыеСистемы();
	ИначеЕсли ТипЗначения = Тип("СправочникМенеджер.пбп_ИнтеграционныеПотоки") Тогда
		ТЗПредопределенныхЗначений = пбп_ПредопределенныеЗначенияПереопределяемый.ПредопределенныеЗначенияИнтеграционныеПотоки();
	ИначеЕсли ТипЗначения = Тип("СправочникМенеджер.пбп_НастройкиИнтеграции") Тогда
		ТЗПредопределенныхЗначений =
			пбп_ПредопределенныеЗначенияПереопределяемый.ПредопределенныеЗначенияНастройкиИнтеграции();
	ИначеЕсли ТипЗначения = Тип("СправочникМенеджер.пбп_ТипСоответствияОбъектовИБ") Тогда
		ТЗПредопределенныхЗначений =
			пбп_ПредопределенныеЗначенияПереопределяемый.ПредопределенныеЗначенияТипСоответствияОбъектовИБ();
	Иначе
		Возврат;
	КонецЕсли;
	
	ОбработатьПредопределенныеЗначения(ТЗПредопределенныхЗначений, МенеджерОбъекта);
	
КонецПроцедуры

// Создание предопределенных значений на основании заполненной таблицы
//
// Параметры:
//  ТаблицаПредопределенных - ТаблицаЗначений - см. пбп_ПредопределенныеЗначенияПереопределяемыйТаблицаПредопределенных,
//										 пбп_ТипСоответствияОбъектовИБПереопределяемый.ТаблицаПредопределенных
//  МенеджерОбъекта			- СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
//  ПолноеИмяОбъекта		- Строка - Полное имя объекта метаданных.
//
Процедура СоздатьОбновитьПредопределенныеЗначения(ТаблицаПредопределенных, МенеджерОбъекта, ПолноеИмяОбъекта = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаПредопределенных) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ПолноеИмяОбъекта) Тогда
		ПолноеИмяОбъекта = ПолноеИмяОбъектаПоУмолчанию();
	КонецЕсли;
	
	Группы = Новый Соответствие;
	КолонкаСуществует = ТаблицаПредопределенных.Колонки.Найти("ЭтоГруппа") <> Неопределено;
	
	Если КолонкаСуществует Тогда
		
		// Сначала создаются группы, затем элементы
		ТаблицаПредопределенных.Сортировать("ЭтоГруппа УБЫВ, УровеньИерархии");
		
		ТекстЗапроса = 
			"ВЫБРАТЬ
			|	пбп_ПредопределенныеЗначения.Ссылка КАК Ссылка,
			|	пбп_ПредопределенныеЗначения.ИдентификаторНастройки КАК ИдентификаторНастройки
			|ИЗ
			|	%1 КАК пбп_ПредопределенныеЗначения
			|ГДЕ
			|	пбп_ПредопределенныеЗначения.ЭтоГруппа";
		
		Запрос = Новый Запрос;
		Запрос.Текст = СтрШаблон(ТекстЗапроса, ПолноеИмяОбъекта);
		
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Группы.Вставить(ВыборкаДетальныеЗаписи.ИдентификаторНастройки, ВыборкаДетальныеЗаписи.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаПредопределенных Цикл
		Если СтрокаТаблицы.Служеб_ОбновитьРасположениеЭлемента Тогда
			ОбновитьПредопределенныйЭлемент(МенеджерОбъекта, СтрокаТаблицы, Группы);
		Иначе
			Если КолонкаСуществует И СтрокаТаблицы.ЭтоГруппа Тогда
				СоздатьПредопределеннуюГруппу(МенеджерОбъекта, СтрокаТаблицы, Группы);
			Иначе
				СоздатьПредопределенныйЭлемент(МенеджерОбъекта, СтрокаТаблицы, Группы, КолонкаСуществует);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Получает все предопределенные элементы объекта, помечает на удаление те, которые удалены из кода.
// При установке пометки удаления для групп, также устанавливается для всех подчиенных элементов.
//
// Параметры:
//  ТаблицаПредопределенных - ТаблицаЗначений - см. пбп_ПредопределенныеЗначенияПереопределяемыйТаблицаПредопределенных,
//										 пбп_ТипСоответствияОбъектовИБПереопределяемый.ТаблицаПредопределенных.
//  ПолноеИмяОбъекта		- Строка - Полное имя объекта метаданных.
//
Процедура ОбработатьНеиспользуемыеЭлементы(ТаблицаПредопределенных, ПолноеИмяОбъекта = "") Экспорт
	
	Если ПустаяСтрока(ПолноеИмяОбъекта) Тогда
		ПолноеИмяОбъекта = ПолноеИмяОбъектаПоУмолчанию();
	КонецЕсли;
	
	ТаблицаПредопределенных.Индексы.Добавить("ИдентификаторНастройки");
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	пбп_ПредопределенныеЗначения.Ссылка КАК Ссылка,
		|	пбп_ПредопределенныеЗначения.ИдентификаторНастройки КАК ИдентификаторНастройки
		|ИЗ
		|	%1 КАК пбп_ПредопределенныеЗначения
		|ГДЕ
		|	НЕ пбп_ПредопределенныеЗначения.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	Ссылка
		|ИТОГИ ПО
		|	Ссылка ИЕРАРХИЯ";
	
	Если пбп_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты("пбп_ИспользоватьПользовательскиеФункции") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ГДЕ
		|	НЕ пбп_ПредопределенныеЗначения.ПометкаУдаления",
		"ГДЕ
		|	НЕ пбп_ПредопределенныеЗначения.ПометкаУдаления
		|	И пбп_ПредопределенныеЗначения.ИдентификаторНастройки <> """"");
	КонецЕсли;
	
	Запрос.Текст = СтрШаблон(ТекстЗапроса, ПолноеИмяОбъекта);
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	ПометитьНаУдалениеВсеВложения(Выборка, ТаблицаПредопределенных);
	
КонецПроцедуры

// Подготавливает параметры необходимые для обработки предопределенных элементов
//
// Параметры:
//  МенеджерОбъекта - СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
// 
// Возвращаемое значение:
//  Структура 	- Данные Менеджера объекта
//  * Менеджер 	- СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
//  * ПолноеИмя - Строка - Полное имя объекта метаданных.
//
Функция ПараметрыМенеджераОбъекта(МенеджерОбъекта) Экспорт

	Параметры = Новый Структура;
	Параметры.Вставить("Менеджер", МенеджерОбъекта);
	Параметры.Вставить("ПолноеИмя", Метаданные.НайтиПоТипу(ТипЗнч(МенеджерОбъекта)).ПолноеИмя());
	
	Возврат Параметры;
	
КонецФункции

// Обрабатывает таблицу предопределенных элементов. Операции включают в себя: установка пометок удаления
// на неиспользуемые элементы, отбор предопределенных значений, создание предопределенных элементов.
//
// Параметры:
//  ТаблицаПредопределенных - ТаблицаЗначений - см. пбп_ПредопределенныеЗначенияПереопределяемыйТаблицаПредопределенных,
//										 пбп_ТипСоответствияОбъектовИБПереопределяемый.ТаблицаПредопределенных.
//  МенеджерОбъекта			- СправочникМенеджер, ПланВидовХарактеристикМенеджер - менеджер объекта.
//
Процедура ОбработатьПредопределенныеЗначения(ТаблицаПредопределенных, МенеджерОбъекта) Экспорт
	
	Параметры = ПараметрыМенеджераОбъекта(МенеджерОбъекта);
	
	ОбработатьНеиспользуемыеЭлементы(ТаблицаПредопределенных, Параметры.ПолноеИмя);
	УдалитьИзТаблицыСуществующиеЭлементы(ТаблицаПредопределенных, Параметры.ПолноеИмя);
	СоздатьОбновитьПредопределенныеЗначения(ТаблицаПредопределенных, Параметры.Менеджер, Параметры.ПолноеИмя);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УдалитьИзТаблицыСуществующиеЭлементы(ТаблицаПредопределенных, ПолноеИмяОбъекта = "") Экспорт
	
	Если Не ЗначениеЗаполнено(ТаблицаПредопределенных) Тогда
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ПолноеИмяОбъекта) Тогда
		ПолноеИмяОбъекта = ПолноеИмяОбъектаПоУмолчанию();
	КонецЕсли;
	
	ИдентификаторыНастроек = ТаблицаПредопределенных.ВыгрузитьКолонку("ИдентификаторНастройки");
	
	Запрос = Новый Запрос;
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	пбп_ПредопределенныеЗначения.Ссылка КАК Ссылка,
		|	пбп_ПредопределенныеЗначения.ИдентификаторНастройки КАК ИдентификаторНастройки,
		|	ЕСТЬNULL(Родители.ИдентификаторНастройки, """") КАК ИдентификаторНастройкиРодитель
		|ИЗ
		|	%1 КАК пбп_ПредопределенныеЗначения
		|		ЛЕВОЕ СОЕДИНЕНИЕ %1 КАК Родители
		|		ПО пбп_ПредопределенныеЗначения.Родитель = Родители.Ссылка
		|ГДЕ
		|	пбп_ПредопределенныеЗначения.ИдентификаторНастройки В(&СписокИдентификаторов)";
		
	Запрос.Текст = СтрШаблон(ТекстЗапроса, ПолноеИмяОбъекта);
	
	Запрос.УстановитьПараметр("СписокИдентификаторов", ИдентификаторыНастроек);
	
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	
	СтрокиДляУдаления = Новый Массив;
	Для Каждого Строка Из ТаблицаПредопределенных Цикл
		ВыборкаДетальныеЗаписи.Сбросить();
		Если ВыборкаДетальныеЗаписи.НайтиСледующий(Строка.ИдентификаторНастройки, "ИдентификаторНастройки") Тогда
			Если ВыборкаДетальныеЗаписи.ИдентификаторНастройкиРодитель = Строка.Родитель Тогда
				СтрокиДляУдаления.Добавить(Строка);
			Иначе
				Строка.Служеб_СсылкаНаПредопределенныйЭлемент = ВыборкаДетальныеЗаписи.Ссылка;
				Строка.Служеб_ОбновитьРасположениеЭлемента = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Строка Из СтрокиДляУдаления Цикл
		ТаблицаПредопределенных.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

Процедура СоздатьПредопределеннуюГруппу(МенеджерОбъекта, СтрокаТаблицы, Группы)
	
	НоваяГруппа = МенеджерОбъекта.СоздатьГруппу();
	ЗаполнитьЗначенияСвойств(НоваяГруппа, СтрокаТаблицы, "Наименование,ИдентификаторНастройки");
	Если ЗначениеЗаполнено(СтрокаТаблицы.Родитель) Тогда
		Родитель = Группы.Получить(СтрокаТаблицы.Родитель);
		НоваяГруппа.Родитель = Родитель;
	КонецЕсли;
	
	Попытка
		НоваяГруппа.Записать();
	Исключение
		пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
	Группы.Вставить(СтрокаТаблицы.ИдентификаторНастройки, НоваяГруппа.Ссылка);
	
КонецПроцедуры

Процедура СоздатьПредопределенныйЭлемент(МенеджерОбъекта, СтрокаТаблицы, Родители, ЗаполнитьРодителя = Ложь)
	
	НовыйЭлемент = МенеджерОбъекта.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйЭлемент, СтрокаТаблицы);
	Если ЗаполнитьРодителя И ЗначениеЗаполнено(СтрокаТаблицы.Родитель) Тогда
		Родитель = Родители.Получить(СтрокаТаблицы.Родитель);
		НовыйЭлемент.Родитель = Родитель;
	КонецЕсли;
	
	// инициализация значения по умолчанию
	ПроверяемыйТип = ТипЗнч(МенеджерОбъекта);
	Если ПроверяемыйТип = Тип("ПланВидовХарактеристикМенеджер.пбп_ПредопределенныеЗначения") Тогда
		НовыйЭлемент.Значение = СтрокаТаблицы.ТипЗначения.ПривестиЗначение();
	КонецЕсли;
	
	Попытка
		НовыйЭлемент.Записать();
	Исключение
		пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьПредопределенныйЭлемент(МенеджерОбъекта, СтрокаТаблицы, Родители)
	
	Если Не ЗначениеЗаполнено(СтрокаТаблицы.Служеб_СсылкаНаПредопределенныйЭлемент) Тогда
		Возврат;
	КонецЕсли;
	
	Элемент = СтрокаТаблицы.Служеб_СсылкаНаПредопределенныйЭлемент.ПолучитьОбъект();
	Элемент.Родитель = Родители[СтрокаТаблицы.Родитель];
	
	Попытка
		Элемент.Записать();
		СообщитьОбИзмененииРасположенияЭлемента(Элемент);
	Исключение
		пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры

Процедура ПометитьНаУдалениеВсеВложения(ИерархическаяВыборка, ТаблицаАктуальныхЭлементов)
	
	Пока ИерархическаяВыборка.Следующий() Цикл
		
		Строка = ТаблицаАктуальныхЭлементов.Найти(ИерархическаяВыборка.ИдентификаторНастройки, "ИдентификаторНастройки");
		Если Строка = Неопределено Тогда
			Элемент = ИерархическаяВыборка.Ссылка.ПолучитьОбъект();
			Элемент.УстановитьПометкуУдаления(Истина, Истина);
			СообщитьОПомеченномНаУдалениеЭлементе(Элемент);
			Продолжить;
		КонецЕсли;
		
		СпособВыборки = ОбходРезультатаЗапроса.ПоГруппировкамСИерархией;
		
		Если ИерархическаяВыборка.ТипЗаписи() = ТипЗаписиЗапроса.ИтогПоИерархии Тогда
			ДочерняяВыборка = ИерархическаяВыборка.Выбрать(СпособВыборки, ИерархическаяВыборка.Группировка());
		Иначе
			ДочерняяВыборка = ИерархическаяВыборка.Выбрать(СпособВыборки);
		КонецЕсли;
		
		ПометитьНаУдалениеВсеВложения(ДочерняяВыборка, ТаблицаАктуальныхЭлементов);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолноеИмяОбъектаПоУмолчанию()
	Возврат "ПланВидовХарактеристик.пбп_ПредопределенныеЗначения";
КонецФункции

Процедура СообщитьОПомеченномНаУдалениеЭлементе(Элемент)
	
	ТекстСообщения = НСтр("ru = 'Элемент ''%1'' помечен на удаление';
							|en = 'The item ''%1'' is marked for deletion'");
	Если ЗначениеЗаполнено(Элемент.Родитель) Тогда
		ТекстСообщения = ТекстСообщения + НСтр("ru = ', включая все его подчиненные элементы.';
												|en = ', including all its subordinate items.'");
	КонецЕсли;
	ТекстСообщения = пбп_СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения,
		Элемент.Ссылка);
	пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(ТекстСообщения, Элемент);
	
КонецПроцедуры

Процедура СообщитьОбИзмененииРасположенияЭлемента(Элемент)
	
	ТекстСообщения = НСтр("ru = 'Расположение элемента ''%1'' изменено. Текущее положение: ''%2''';
							|en = 'The location of element ''%1'' has changed. Current position: ''%2'''");
	Родитель = ?(ЗначениеЗаполнено(Элемент.Родитель), Элемент.Родитель, НСтр("ru = '''<корень>'''; en = '''<root>'''"));
	ТекстСообщения = пбп_СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения,
		Элемент.Ссылка,
		Родитель);
	пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(ТекстСообщения, Элемент);
	
КонецПроцедуры

#КонецОбласти