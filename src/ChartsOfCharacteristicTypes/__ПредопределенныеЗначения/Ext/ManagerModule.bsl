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

// Возвращает значение ПВХ по идентификатору.
//
// Параметры:
//  Идентификатор - Строка - Идентификатор переменной ПВХ.
// 
// Возвращаемое значение:
//  ПроизвольныйТип - Значение переменной ПВХ.
// 
Функция ПолучитьЗначение(Идентификатор) Экспорт
	
	Значение = __ПредопределенныеЗначения.ЗначенияПредопределенныхЭлементов(Идентификатор);
	
	Возврат Значение;
	
КонецФункции

// Возвращает соответствие предопределенных элементов ПВХ по Идентификаторам.
//
// Параметры:
//  Идентификаторы - Строка - Идентификаторы переменных ПВХ, перечисленные через запятую.
//  ВРазрезеКлючей - Булево - Признак получения данных в виде соответствия, где Ключ - Имя переменной.
// 
// Возвращаемое значение:
//  - Соответствие - Соответствие имен и значений переменных ПВХ.
//  - Массив - Массив значений переменных ПВХ.
// 
Функция ПолучитьЗначения(Идентификаторы, ВРазрезеКлючей = Ложь) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиентСервер = Неопределено;
	СтроковыеФункцииКлиентСервер = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если ВРазрезеКлючей Тогда
		Значения = Новый Соответствие;
	Иначе
		Значения = Новый Массив;
	КонецЕсли;
	
	МассивИдентификаторов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Идентификаторы);
	МассивИдентификаторов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивИдентификаторов);
	
	Если Не ЗначениеЗаполнено(МассивИдентификаторов) Тогда
		Возврат Значения;
	КонецЕсли;
	
	Значения = __ПредопределенныеЗначения.ЗначенияПредопределенныхЭлементов(МассивИдентификаторов,, Истина, ВРазрезеКлючей);
	
	Если Не ВРазрезеКлючей Тогда
		Значения = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Значения);
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПарольПоИмени(Имя) // не используется, см. __ПредопределенныеЗначения.ПолучитьПарольПоИдентификатору() 
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = __ВспомогательныйМодульНеПереносить;
	ОбщегоНазначенияКлиентСервер = __ВспомогательныйМодульНеПереноситьКлиентСервер;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Значение = Неопределено;
	
	ДанныеХранилища = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(
			Строка(ПланыВидовХарактеристик.__ПредопределенныеЗначения[Имя].УникальныйИдентификатор()));
		
	Если ТипЗнч(ДанныеХранилища) = Тип("Структура") Тогда
		Значение = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ДанныеХранилища, "bit_password", "");
	Иначе
		Значение = "";
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции

#КонецЕсли