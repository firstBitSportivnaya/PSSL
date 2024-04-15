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

// Функция - Загрузить из XLS
//
// Параметры:
//  СоответствиеКолонок	 - Структура - Описание колонок загружаемого файла
//  НазваниеЛиста		 - Строка - Имя загружаемого листа (по-умолчанию не заполнено)
//  НомерПервойСтроки	 - Число - Номер строки с которой начинается загрузка данных (по-умолчанию 1)
// 
// Возвращаемое значение:
//  - Строка - Адрес файла во временном хранилище
//
Асинх Функция ЗагрузитьИзXLS(СоответствиеКолонок, НазваниеЛиста = "", НомерПервойСтроки = 1) Экспорт
	
	АдресПомещения = __ЗагрузкаФайлаЧерезТабличныйДокументВызовСервера.ПоместитьЗаглушку(СоответствиеКолонок);
	
	Параметры = Новый Структура("Макет, АдресПомещения, НазваниеЛиста, НомерПервойСтроки", СоответствиеКолонок, АдресПомещения, НазваниеЛиста, НомерПервойСтроки);
	
	ПараметрыДиалога = Новый ПараметрыДиалогаПомещенияФайлов;
	ПараметрыДиалога.Фильтр = "Документ Excel (*.xls, *.xlsx)|*.xls;*.xlsx|";
	ПараметрыДиалога.МножественныйВыбор = Ложь;
	ПараметрыДиалога.ИндексФильтра = 0;
	ПараметрыДиалога.Заголовок = "Выберите файл для загрузки";
	
	ОписаниеФайла = Ждать ПоместитьФайлНаСерверАсинх( , , , ПараметрыДиалога);
	
	Если ТипЗнч(ОписаниеФайла) = Тип("ОписаниеПомещенногоФайла") И Не ОписаниеФайла.ПомещениеФайлаОтменено Тогда
		__ЗагрузкаФайлаЧерезТабличныйДокументВызовСервера.ФормированиеТаблицы(ОписаниеФайла.Адрес, ОписаниеФайла.СсылкаНаФайл.Расширение, Параметры);
	Иначе
		__ОбщегоНазначенияСлужебныйКлиент.СообщитьПользователю(НСтр("ru = 'Помещение файла отменено'"));
		АдресПомещения = Неопределено;
	КонецЕсли;
	
	Возврат АдресПомещения;
	
КонецФункции

#КонецОбласти