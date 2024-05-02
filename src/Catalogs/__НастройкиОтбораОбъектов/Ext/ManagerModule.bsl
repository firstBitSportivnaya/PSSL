﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура заполняет компоновщик настроек для выбранного объекта метаданных
//
// Параметры:
//   КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных
//   ОбъектМетаданных - Строка - Строковое представление объекта метаданных (пример - Документ.ПоступлениеТоваровУслуг)
//
Процедура ИнициализироватьКомпоновщик(КомпоновщикНастроек, Знач ОбъектМетаданных) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ * ИЗ " + ОбъектМетаданных;
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";

	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстЗапроса;

	АдресКомпоновки = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
КонецПроцедуры

// Процедура используется для копирования элементов отбора из пользовательского компоновщика
//
// Параметры:
//   НовыйОтбор - ОтборКомпоновкиДанных
//   СтарыйОтбор - ОтборКомпоновкиДанных
//
Процедура СкопироватьЭлементыОтбора(НовыйОтбор, СтарыйОтбор) Экспорт
	
	Для Каждого Элемент Из СтарыйОтбор.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			НовыйЭлемент = НовыйОтбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент);
			СкопироватьЭлементыОтбора(НовыйЭлемент, Элемент);
		Иначе
			НовыйЭлемент = НовыйОтбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// По заданной настройке отбора функция возвращает таблицу значений с ссылками, соответствующими условиям отбора
//
// Параметры:
//   Настройка - СправочникСсылка.__НастройкиОтбораОбъектов
//
// Возвращаемое значение:
//   ТаблицаЗначений:
//     * Ссылка - СправочникСсылка, ДокументСсылка, ПланВидовХарактеристикСсылка, ПланСчетовСсылка, ПланВидовРасчетовСсылка
//
Функция ПолучитьДанныеПоНастройкеОтбора(Настройка) Экспорт
	
	ОбъектМетаданных = __ОбщегоНазначенияСлужебный.ЗначениеРеквизитаОбъекта(Настройка, "ОбъектМетаданных");
	Отбор = __ОбщегоНазначенияСлужебный.ЗначениеРеквизитаОбъекта(Настройка, "Отбор");
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	ТекстЗапроса = "ВЫБРАТЬ * ИЗ " + ОбъектМетаданных;
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";

	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	НаборДанных.Запрос = ТекстЗапроса;

	АдресКомпоновки = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресКомпоновки));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	ДетальныеЗаписи = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ДетальныеЗаписи.Имя = "Детальные";
	ДетальныеЗаписи.Использование = Истина;
	ВыбранноеПоле = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Ссылка");

	Отбор = __ОбщегоНазначенияСлужебный.ЗначениеИзСтрокиXML(Отбор);
	СкопироватьЭлементыОтбора(КомпоновщикНастроек.Настройки.Отбор, Отбор);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Попытка
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Исключение
		СообщениеОбОшибке = ОписаниеОшибки();
		__ОбщегоНазначенияСервер.СообщитьПользователю(СообщениеОбОшибке);
	КонецПопытки;

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Ссылка");
	
	ПроцессорВывода.УстановитьОбъект(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли