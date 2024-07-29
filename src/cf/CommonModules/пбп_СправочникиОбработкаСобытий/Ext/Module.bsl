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

///////////////////////////////////////////////////////////////////////////////
// Справочники (обработка событий)

#Область ПрограммныйИнтерфейс

// Возникает при создании элемента справочника копированием.
//
// Параметры:
//  Источник			 - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  ОбъектКопирования	 - СправочникОбъект - Исходный элемент, который является источником копирования.
//
Процедура ПриКопировании(Источник, ОбъектКопирования) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.СправочникиПриКопировании().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(ОбъектКопирования);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Источник = ПараметрыМетода[0];
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает при вводе справочника на основании, а также при выполнении метода Заполнить,
// при вводе на основании, а также при интерактивном вводе нового.
//
// Параметры:
//  Источник			 - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  ДанныеЗаполнения	 - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения		 - Строка, Неопределено - Текст, используемый для заполнения справочника.
//  СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.СправочникиОбработкаЗаполнения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(ДанныеЗаполнения);
			ПараметрыМетода.Добавить(ТекстЗаполнения);
			ПараметрыМетода.Добавить(СтандартнаяОбработка);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Источник = ПараметрыМетода[0];
			СтандартнаяОбработка = ПараметрыМетода[3];
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает перед выполнением записи элемента справочника.
// Процедура-обработчик вызывается после начала транзакции записи, но до начала записи элемента справочника.
//
// Параметры:
//  Источник - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ	 - Булево - Признак отказа от записи элемента.
//
Процедура ПередЗаписью(Источник, Отказ) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.СправочникиПередЗаписью().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Источник = ПараметрыМетода[0];
			Отказ = ПараметрыМетода[1];
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает при записи объекта.
// Процедура-обработчик вызывается после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Источник - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ	 - Булево - Признак отказа от записи.
//
Процедура ПриЗаписи(Источник, Отказ) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.СправочникиПриЗаписи().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Отказ = ПараметрыМетода[1];
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает при записи документа.
// Основное назначение процедуры-обработчика данного события -
// проверка правильности заполнения значений реквизитов объекта.
//
// Параметры:
//  Источник			 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ				 - Булево - Признак проведения документа.
//  ПроверяемыеРеквизиты - Массив - Массив проверяемых реквизитов.
//
Процедура ОбработкаПроверкиЗаполнения(Источник, Отказ, ПроверяемыеРеквизиты) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.СправочникиОбработкаПроверкиЗаполнения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			ПараметрыМетода.Добавить(ПроверяемыеРеквизиты);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Отказ = ПараметрыМетода[1];
			ПроверяемыеРеквизиты = ПараметрыМетода[2];
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти