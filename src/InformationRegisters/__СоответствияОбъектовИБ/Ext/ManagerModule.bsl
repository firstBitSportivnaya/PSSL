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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает таблицу соответствий по отбору.
//
// Параметры:
//  ТипСоответствия - Перечисление.__ТипСоответствияОбъектовИБ - Тип соответствия.
//  Объект1 - ПроизвольныйТип - Объект1.
//  Объект2 - ПроизвольныйТип - Объект2.
//  Объект3 - ПроизвольныйТип - Объект3.
// 
// Возвращаемое значение:
//  - ТаблицаЗначений - Таблица соответствий по отбору.
// 
Функция ПолучитьСоответствиеОбъектовИБ(ТипСоответствия, Объект1 = Неопределено, Объект2 = Неопределено, Объект3 = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
		|	СоответствияОбъектовИБ.ТипСоответствия КАК ТипСоответствия,
		|	СоответствияОбъектовИБ.Объект1 КАК Объект1,
		|	СоответствияОбъектовИБ.Объект2 КАК Объект2,
		|	СоответствияОбъектовИБ.Объект3 КАК Объект3
		|ИЗ
		|	РегистрСведений.__СоответствияОбъектовИБ КАК СоответствияОбъектовИБ
		|ГДЕ
		|	СоответствияОбъектовИБ.ТипСоответствия = &ТипСоответствия";
	
	Если ЗначениеЗаполнено(Объект1) Тогда
		
		ТекстЗапроса = СтрШаблон("%1%2И СоответствияОбъектовИБ.Объект1 = &Объект1", ТекстЗапроса, Символы.ПС);
		Запрос.УстановитьПараметр("Объект1", Объект1);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект2) Тогда
		
		ТекстЗапроса = СтрШаблон("%1%2И СоответствияОбъектовИБ.Объект2 = &Объект2", ТекстЗапроса, Символы.ПС);
		Запрос.УстановитьПараметр("Объект2", Объект2);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект3) Тогда
		
		ТекстЗапроса = СтрШаблон("%1%2И СоответствияОбъектовИБ.Объект3 = &Объект3", ТекстЗапроса, Символы.ПС);
		Запрос.УстановитьПараметр("Объект3", Объект3);
		
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("ТипСоответствия", ТипСоответствия);
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Выгрузить();
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли