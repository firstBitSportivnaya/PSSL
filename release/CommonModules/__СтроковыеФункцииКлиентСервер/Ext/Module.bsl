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
// Работа со строками (клиент, сервер): Модуль содержит методы работы со строками.

#Область ПрограммныйИнтерфейс

// Разбирает строку с разделителями и упаковывает значения в массив.
// 
// Параметры:
//  ИсходнаяСтрока  - Строка
//  Разделитель     - Строка
//  ПоНарастающей   - Булево (По умолчанию = Ложь) .
//
// ВозвращаемоеЗначение:
//  Массив
//
Функция РазобратьСтрокуСРазделителями(ИсходнаяСтрока, Разделитель, ПоНарастающей = Ложь) Экспорт
	
	Результат = Новый Массив;
	
	Список = __ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСРазделителями(ИсходнаяСтрока, Разделитель);
	Если ПоНарастающей Тогда
		НарастающаяСтрока = "";
		Для Каждого СтрокаСписка Из Список Цикл
			
			НарастающаяСтрока = ?(ПустаяСтрока(НарастающаяСтрока),
				СтрокаСписка, СтрШаблон("%1.%2", НарастающаяСтрока, СтрокаСписка));
			Результат.Добавить(НарастающаяСтрока);
		КонецЦикла; 
	Иначе
		Результат = Список;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает текст с добавлением/удаление разделителя "|".
// 
// Параметры:
//  Текст    - Строка - Обрабатываемый текст.
//  Добавить - Булево - Признак добавления/удаления вертикальной черты.
// 
// Возвращаемое значение:
//  Строка - Результат обработки строки.
//
Функция УбратьДобавитьВертикальнуюЧерту(Текст, Добавить = Ложь) Экспорт
	
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(Текст);
	КоличествоСтрок = ТекстовыйДокумент.КоличествоСтрок();
	
	Если Добавить Тогда
		
		Для Сч = 1 По КоличествоСтрок Цикл
		
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			
			Если Сч = 1 Тогда
				ТекущаяСтрока = """" + ТекущаяСтрока;
			Иначе
				
				ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, """", """""");
				ТекущаяСтрока = СтрШаблон("|%1", ТекущаяСтрока);
				
				Если Сч = КоличествоСтрок Тогда
					ТекущаяСтрока = СтрШаблон("%1%2", ТекущаяСтрока, """");
				КонецЕсли;
			КонецЕсли;
			
			ТекстовыйДокумент.ЗаменитьСтроку(Сч, ТекущаяСтрока);
		КонецЦикла;
	Иначе
		
		Для Сч = 1 По КоличествоСтрок Цикл
		
			ТекущаяСтрока = ТекстовыйДокумент.ПолучитьСтроку(Сч);
			
			Если Сч = 1 Тогда
				ТекущаяСтрока = Сред(ТекущаяСтрока, 2);
			ИначеЕсли Сч = КоличествоСтрок Тогда
				ТекущаяСтрока = Сред(ТекущаяСтрока, 1, СтрДлина(ТекущаяСтрока) - 1);
			КонецЕсли;
			
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, """""", """");
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "|", "");
			
			ТекстовыйДокумент.ЗаменитьСтроку(Сч, ТекущаяСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Результат = ТекстовыйДокумент.ПолучитьТекст();
	Результат = Сред(Результат, 1, СтрДлина(Результат) - 1);
	
	Возврат Результат;
	
КонецФункции

// Подставляет параметры в строку. Максимально возможное число параметров - 9.
// Параметры в строке задаются как %<номер параметра>. Нумерация параметров начинается с единицы.
//
// Параметры:
//  ШаблонСтроки  - Строка - шаблон строки с параметрами (вхождениями вида "%<номер параметра>", 
//                           например "%1 пошел в %2");
//  Параметр1   - Строка - значение подставляемого параметра.
//  Параметр2   - Строка
//  Параметр3   - Строка
//  Параметр4   - Строка
//  Параметр5   - Строка
//  Параметр6   - Строка
//  Параметр7   - Строка
//  Параметр8   - Строка
//  Параметр9   - Строка
//
// Возвращаемое значение:
//  Строка   - текстовая строка с подставленными параметрами.
//
// Пример:
//  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 пошел в %2'"), "Вася", "Зоопарк") = "Вася пошел
//  в Зоопарк".
//
Функция ПодставитьПараметрыВСтроку(Знач ШаблонСтроки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено) Экспорт
	
	ЕстьПараметрыСПроцентом = СтрНайти(Параметр1, "%")
		Или СтрНайти(Параметр2, "%")
		Или СтрНайти(Параметр3, "%")
		Или СтрНайти(Параметр4, "%")
		Или СтрНайти(Параметр5, "%")
		Или СтрНайти(Параметр6, "%")
		Или СтрНайти(Параметр7, "%")
		Или СтрНайти(Параметр8, "%")
		Или СтрНайти(Параметр9, "%");
		
	Если ЕстьПараметрыСПроцентом Тогда
		Возврат ПодставитьПараметрыСПроцентом(ШаблонСтроки, Параметр1,
			Параметр2, Параметр3, Параметр4, Параметр5, Параметр6, Параметр7, Параметр8, Параметр9);
	КонецЕсли;
	
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%1", Параметр1);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%2", Параметр2);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%3", Параметр3);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%4", Параметр4);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%5", Параметр5);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%6", Параметр6);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%7", Параметр7);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%8", Параметр8);
	ШаблонСтроки = СтрЗаменить(ШаблонСтроки, "%9", Параметр9);
	Возврат ШаблонСтроки;
	
КонецФункции 

// Вставляет параметры в строку, учитывая, что в параметрах могут использоваться подстановочные слова %1, %2 и т.д.
Функция ПодставитьПараметрыСПроцентом(Знач СтрокаПодстановки,
	Знач Параметр1, Знач Параметр2 = Неопределено, Знач Параметр3 = Неопределено,
	Знач Параметр4 = Неопределено, Знач Параметр5 = Неопределено, Знач Параметр6 = Неопределено,
	Знач Параметр7 = Неопределено, Знач Параметр8 = Неопределено, Знач Параметр9 = Неопределено)
	
	Результат = "";
	Позиция = СтрНайти(СтрокаПодстановки, "%");
	Пока Позиция > 0 Цикл 
		Результат = Результат + Лев(СтрокаПодстановки, Позиция - 1);
		СимволПослеПроцента = Сред(СтрокаПодстановки, Позиция + 1, 1);
		ПодставляемыйПараметр = Неопределено;
		Если СимволПослеПроцента = "1" Тогда
			ПодставляемыйПараметр = Параметр1;
		ИначеЕсли СимволПослеПроцента = "2" Тогда
			ПодставляемыйПараметр = Параметр2;
		ИначеЕсли СимволПослеПроцента = "3" Тогда
			ПодставляемыйПараметр = Параметр3;
		ИначеЕсли СимволПослеПроцента = "4" Тогда
			ПодставляемыйПараметр = Параметр4;
		ИначеЕсли СимволПослеПроцента = "5" Тогда
			ПодставляемыйПараметр = Параметр5;
		ИначеЕсли СимволПослеПроцента = "6" Тогда
			ПодставляемыйПараметр = Параметр6;
		ИначеЕсли СимволПослеПроцента = "7" Тогда
			ПодставляемыйПараметр = Параметр7
		ИначеЕсли СимволПослеПроцента = "8" Тогда
			ПодставляемыйПараметр = Параметр8;
		ИначеЕсли СимволПослеПроцента = "9" Тогда
			ПодставляемыйПараметр = Параметр9;
		КонецЕсли;
		Если ПодставляемыйПараметр = Неопределено Тогда
			Результат = Результат + "%";
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 1);
		Иначе
			Результат = Результат + ПодставляемыйПараметр;
			СтрокаПодстановки = Сред(СтрокаПодстановки, Позиция + 2);
		КонецЕсли;
		Позиция = СтрНайти(СтрокаПодстановки, "%");
	КонецЦикла;
	Результат = Результат + СтрокаПодстановки;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
