//MIT License

//Copyright (c) 2024 Anton Tsitavets

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

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
Функция ЗагрузитьИзXLS(СоответствиеКолонок, НазваниеЛиста = "", НомерПервойСтроки = 1) Экспорт
	
	ИД = __ЗагрузкаФайлаЧерезТабличныйДокументВызовСервера.ПоместитьЗаглушку(СоответствиеКолонок);
	
	ДиалогВыбораФайла							= Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.Фильтр					= "Документ Excel (*.xls, *.xlsx)|*.xls;*.xlsx|";
	ДиалогВыбораФайла.Заголовок					= "Выберите файл";
	ДиалогВыбораФайла.ПредварительныйПросмотр	= Ложь;
	ДиалогВыбораФайла.МножественныйВыбор		= Ложь;
	ДиалогВыбораФайла.ИндексФильтра				= 0;
	
	Параметры = Новый Структура("Макет, АдресХр, НазваниеЛиста, НомерПервойСтроки", СоответствиеКолонок, ИД, НазваниеЛиста, НомерПервойСтроки);

	Если ДиалогВыбораФайла.Выбрать() Тогда
		ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ДиалогВыбораФайла.ПолноеИмяФайла), ИД);
		ЗагрузитьФайлЗавершение(ИД, ДиалогВыбораФайла.ПолноеИмяФайла, Параметры);
	КонецЕсли;
	
	Возврат ИД;
	
КонецФункции

// Процедура - Загрузить файл завершение
//
// Параметры:
//  Адрес					 - Строка - Адрес файла во временном хранилище
//  ВыбранноеИмяФайла		 - Строка - Начальное полное имя файла
//  ДополнительныеПараметры	 - Структура - Параметры необходимые для корректной загрузки файла
//
Процедура ЗагрузитьФайлЗавершение(Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	ИмяФайла = Прав(ВыбранноеИмяФайла, СтрДлина(ВыбранноеИмяФайла) - СтрНайти(ВыбранноеИмяФайла, "\", НаправлениеПоиска.СКонца));
	
	Если Не Адрес = "" Тогда
		__ЗагрузкаФайлаЧерезТабличныйДокументВызовСервера.ФормированиеТаблицы(Адрес, ИмяФайла, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти