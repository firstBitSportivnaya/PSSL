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

// Возвращает значение ПВХ по имени.
//
// Параметры:
//  Имя - Строка - Имя переменной ПВХ.
// 
// Возвращаемое значение:
//  ПроизвольныйТип - Значение переменной ПВХ.
// 
Функция ПолучитьЗначение(Имя) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	УстановитьПривилегированныйРежим(Истина);
	
	Значение = Неопределено;
	
	Если ПланыВидовХарактеристик.__ПредопределенныеЗначения[Имя].СписокЗначений Тогда
		Значение = ОбщегоНазначения.ВыгрузитьКолонку(
			ПланыВидовХарактеристик.__ПредопределенныеЗначения[Имя].ЗначенияЭлементов, "Значение", Истина);
	ИначеЕсли ПланыВидовХарактеристик.__ПредопределенныеЗначения[Имя].Пароль Тогда
		Значение = ПолучитьПарольПоИмени(Имя);
	Иначе
		Значение = ПланыВидовХарактеристик.__ПредопределенныеЗначения[Имя].Значение;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Значение;
	
КонецФункции

// Возвращает соответствие предопределенных элементов ПВХ по имени.
//
// Параметры:
//  Имя - Строка - Имена переменных ПВХ, перечисленные через запятую.
//  ВРазрезеКлючей - Булево - Признак получения данных в виде соответствия, где Ключ - Имя переменной.
// 
// Возвращаемое значение:
//  - Соответствие - Соответствие имен и значений переменных ПВХ.
//  - Массив - Массив значений переменных ПВХ.
// 
Функция ПолучитьЗначения(Имена, ВРазрезеКлючей = Ложь) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = Неопределено;
	ОбщегоНазначенияКлиентСервер = Неопределено;
	СтроковыеФункцииКлиентСервер = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ВРазрезеКлючей Тогда
		Значения = Новый Соответствие;
	Иначе
		Значения = Новый Массив;
	КонецЕсли;
	
	МассивИмен = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Имена);
	МассивИмен = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивИмен);
	
	Если Не МассивИмен.Количество() Тогда
		Возврат Значения;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	ПредопределенныеЗначения.Ссылка КАК ПредопределенноеЗначение,
		|	ПредопределенныеЗначения.ИмяПредопределенныхДанных КАК Имя
		|ПОМЕСТИТЬ ПредопределенныеЗначения
		|ИЗ
		|	ПланВидовХарактеристик.__ПредопределенныеЗначения КАК ПредопределенныеЗначения
		|ГДЕ
		|	ПредопределенныеЗначения.ИмяПредопределенныхДанных В(&МассивИмен)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПредопределенныеЗначения.Имя КАК Имя,
		|	__ПредопределенныеЗначения.Значение КАК Значение,
		|	ПУСТАЯТАБЛИЦА.( КАК Значение) КАК ЗначенияЭлементов,
		|	__ПредопределенныеЗначения.Пароль КАК Пароль,
		|	ЛОЖЬ КАК СписокЗначений
		|ИЗ
		|	ПредопределенныеЗначения КАК ПредопределенныеЗначения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.__ПредопределенныеЗначения КАК __ПредопределенныеЗначения
		|		ПО ПредопределенныеЗначения.ПредопределенноеЗначение = __ПредопределенныеЗначения.Ссылка
		|			И (НЕ __ПредопределенныеЗначения.СписокЗначений)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПредопределенныеЗначения.Имя,
		|	НЕОПРЕДЕЛЕНО,
		|	__ПредопределенныеЗначения.ЗначенияЭлементов.(
		|		Значение
		|	),
		|	ЛОЖЬ,
		|	ИСТИНА
		|ИЗ
		|	ПредопределенныеЗначения КАК ПредопределенныеЗначения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланВидовХарактеристик.__ПредопределенныеЗначения КАК __ПредопределенныеЗначения
		|		ПО ПредопределенныеЗначения.ПредопределенноеЗначение = __ПредопределенныеЗначения.Ссылка
		|			И (__ПредопределенныеЗначения.СписокЗначений)";
	
	Запрос.УстановитьПараметр("МассивИмен", МассивИмен);
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Значение = Неопределено;
		
		Если Выборка.Пароль Тогда
			Значение = ПолучитьПарольПоИмени(Выборка.Имя);
		ИначеЕсли Выборка.СписокЗначений Тогда
			Значение = ОбщегоНазначения.ВыгрузитьКолонку(Выборка.ЗначенияЭлементов.Выгрузить(), "Значение", Истина);
		Иначе
			Значение = Выборка.Значение;
		КонецЕсли;
		
		Если ВРазрезеКлючей Тогда
			Значения.Вставить(Выборка.Имя, Значение);
		Иначе
			Если ТипЗнч(Значение) = Тип("Массив") Тогда
				ОбщегоНазначенияКлиентСервер.ДополнитьМассив(Значения, Значение);
			Иначе
				Значения.Добавить(Значение);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не ВРазрезеКлючей Тогда
		Значения = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Значения);
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат Значения;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьПарольПоИмени(Имя)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = Неопределено;
	ОбщегоНазначенияКлиентСервер = Неопределено;
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