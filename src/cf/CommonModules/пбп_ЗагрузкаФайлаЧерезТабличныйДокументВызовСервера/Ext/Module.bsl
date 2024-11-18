// MIT License

// Copyright (c) 2024 Anton Tsitavets

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#Область ПрограммныйИнтерфейс

// Процедура - Формирование таблицы
//
// Параметры:
//  АдресВХранилище	 - Строка - Адрес файла во временном хранилище
//  Расширение		 - Строка - Расширение файла (xls, xlsx)
//  ПараметрыЧтения	 - Структура - структура параметров загрузки Excel-файла
//  см. пбп_ЗагрузкаФайлаЧерезТабличныйДокументСервер.ПолучитьПараметрыЧтенияФайла
//
Процедура ФормированиеТаблицы(АдресВХранилище, Расширение, ПараметрыЧтения) Экспорт
	
	ТаблицаСвойств = ПолучитьИзВременногоХранилища(ПараметрыЧтения.АдресМакета);
	
	ТаблицаДанных = пбп_ЗагрузкаФайлаЧерезТабличныйДокументСервер
		.КонвертироватьДанныеТабличногоДокументаВТаблицуЗначений(
		АдресВХранилище, Расширение, ТаблицаСвойств, ПараметрыЧтения);
	
	ПоместитьВоВременноеХранилище(ТаблицаДанных, ПараметрыЧтения.АдресПомещения);
	
КонецПроцедуры

// Функция - Поместить заглушку
//
// Параметры:
//  Макет - Строка - Адрес временного хранилища, где находится таблица значений со списком колонок загружаемого файла
// 
// Возвращаемое значение:
//  - Строка - Адрес файла во временном хранилище
//
Функция ПоместитьЗаглушку(Макет) Экспорт
	
	Заглушка = Новый ТаблицаЗначений;
	
	МакетТаблица = ПолучитьИзВременногоХранилища(Макет);
	
	Для Каждого КолонкаТаблицы Из МакетТаблица Цикл
		Заглушка.Колонки.Добавить(КолонкаТаблицы.ИмяКолонки, Новый ОписаниеТипов(КолонкаТаблицы.ТипЗначения));
	КонецЦикла;
	
	ИД = ПоместитьВоВременноеХранилище(Заглушка, Новый УникальныйИдентификатор);
	
	Возврат ИД;
	
КонецФункции

// Инициализирует таблицу со свойствами колонок загружаемого файла
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица готовая для заполнения данных колонок
//
Функция ИнициализироватьТаблицуСоСвойствамиКолонок() Экспорт
	
	Возврат пбп_ЗагрузкаФайлаЧерезТабличныйДокументСервер.ИнициализироватьТаблицуСоСвойствамиКолонок();
	
КонецФункции

// Получить параметры чтения файла
// 
// Возвращаемое значение:
//  Структура - см. пбп_ЗагрузкаФайлаЧерезТабличныйДокументСервер.ПолучитьПараметрыЧтенияФайла
//
Функция ПолучитьПараметрыЧтенияФайла() Экспорт
	
	Возврат пбп_ЗагрузкаФайлаЧерезТабличныйДокументСервер.ПолучитьПараметрыЧтенияФайла();
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс