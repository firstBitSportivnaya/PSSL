﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8, включая доработку типовых конфигураций.
//
// Copyright 2017-2024 First BIT company
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
//
// URL:    https://github.com/firstBitSportivnaya/PSSL/
// e-mail: ivssmirnov@1bit.com
// Версия: 1.0.0.1
//
// Требования: платформа 1С версии 8.3.17 и выше

////////////////////////////////////////////////////////////////////////////////
// Справочники событие "Перед записью" (вызов сервера): обработка событий перед записью

#Область ПрограммныйИнтерфейс

// Возникает перед выполнением записи элемента справочника.
// Процедура-обработчик вызывается после начала транзакции записи, но до начала записи элемента справочника.
//
// Параметры:
//  Источник - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ	 - Булево - Признак отказа от записи элемента.
//
Процедура СправочникиПередЗаписью(Источник, Отказ) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = __ВспомогательныйМодульНеПереносить;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = __ОбщегоНазначенияПовтИсп.СправочникиПередЗаписью().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			
			ОбщегоНазначения.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции