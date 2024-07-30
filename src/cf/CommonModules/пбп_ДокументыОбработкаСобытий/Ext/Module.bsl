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
// Документы (обработка событий)

#Область ПрограммныйИнтерфейс

// Возникает при создании документа копированием.
//
// Параметры:
//  Источник			 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  ОбъектКопирования	 - ДокументОбъект - Исходный документ, который является источником копирования.
//
Процедура ПриКопировании(Источник, ОбъектКопирования) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыПриКопировании().Получить(ТипЗнч(Источник));
	
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

// Возникает при вводе документа на основании, а также при выполнении метода Заполнить,
// при вводе на основании, а также при интерактивном вводе нового.
//
// Параметры:
//  Источник			 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  ДанныеЗаполнения	 - Произвольный - Значение, которое используется как основание для заполнения.
//  ТекстЗаполнения		 - Строка, Неопределено - Текст, используемый для заполнения документа.
//  СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
//
Процедура ОбработкаЗаполнения(Источник, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыОбработкаЗаполнения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(ДанныеЗаполнения);
			ПараметрыМетода.Добавить(ТекстЗаполнения);
			ПараметрыМетода.Добавить(СтандартнаяОбработка);
			
			Источник = ПараметрыМетода[0];
			СтандартнаяОбработка = ПараметрыМетода[3];
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает перед выполнением записи объекта.
// Процедура-обработчик вызывается после начала транзакции записи, но до начала записи документа.
//
// Параметры:
//  Источник		 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ			 - Булево - Признак отказа от записи.
//  РежимЗаписи		 - РежимЗаписиДокумента - Текущий режим записи документа.
//  РежимПроведения	 - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыПередЗаписью().Получить(ТипЗнч(Источник));
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			ПараметрыМетода.Добавить(РежимЗаписи);
			ПараметрыМетода.Добавить(РежимПроведения);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Источник = ПараметрыМетода[0];
			Если ПараметрыМетода[1] Тогда
				Отказ = Истина;
			КонецЕсли;
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает при записи объекта.
// Процедура-обработчик вызывается после записи объекта в базу данных, но до окончания транзакции записи.
//
// Параметры:
//  Источник - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ	 - Булево - Признак отказа от записи документа.
//
Процедура ПриЗаписи(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыПриЗаписи().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Если ПараметрыМетода[1] Тогда
				Отказ = Истина;
			КонецЕсли;
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

// Возникает при проведении документа.
// Основное назначение процедуры-обработчика данного события - генерация движений по документу.
// Выполняется в транзакции записи.
//
// Параметры:
//  Источник		 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ			 - Булево - Признак проведения документа.
//  РежимПроведения	 - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыОбработкаПроведения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			ПараметрыМетода.Добавить(РежимПроведения);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Если ПараметрыМетода[1] Тогда
				Отказ = Истина;
			КонецЕсли;
			
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
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = пбп_ОбщегоНазначенияПовтИсп.ДокументыОбработкаПроверкиЗаполнения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			ПараметрыМетода.Добавить(ПроверяемыеРеквизиты);
			
			пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
			Если ПараметрыМетода[1] Тогда
				Отказ = Истина;
			КонецЕсли;
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