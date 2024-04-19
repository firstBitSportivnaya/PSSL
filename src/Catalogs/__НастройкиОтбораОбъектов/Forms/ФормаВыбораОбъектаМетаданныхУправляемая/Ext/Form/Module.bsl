﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекущийОбъект = Параметры.ТекущийОбъект;
	ТипТекущегоОбъекта = Параметры.ТипТекущегоОбъекта;
	
	ВидОперации = Параметры.ВидОперации;
	СписокКоллекций = Параметры.СписокКоллекций;
	ВыводитьТЧОбъектов = Параметры.ВыводитьТЧОбъектов;
	
	ЗакрыватьПриВыборе = Истина;
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
	Если ВидОперации = "ВыборОбъекта" Тогда
		ВывестиОбъекты();
	ИначеЕсли ВидОперации = "ВыборКартинки" Тогда
		ВывестиКартинки();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиОбъекты()
	
	СоответствиеТипаЗначенияКоллекциямОбъектов = СоответствиеТипаЗначенияКоллекциямОбъектов();
	
	Для Каждого Коллекция Из СписокКоллекций Цикл
		ЕстьТЧ = Коллекция.Значение = "Справочники" Или Коллекция.Значение = "Документы";
		ТипЗначения = СоответствиеТипаЗначенияКоллекциямОбъектов.Получить(Коллекция.Значение);
		СтруктураКоллекции = Новый Структура("Коллекция, ЕстьТЧ, ТипЗначения", Коллекция.Значение, ЕстьТЧ, ТипЗначения);
		
		ДобавитьСтрокиДереваПоВидуОбъектов(СтруктураКоллекции);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиКартинки()
	СтрокиДерева = Дерево.ПолучитьЭлементы();
	
	Если СписокКоллекций.НайтиПоЗначению("Картинки") <> Неопределено Тогда
		// Выводим Картинки
		СтрокаКартинка = СтрокиДерева.Добавить();
		СтрокаКартинка.Поле = "Картинки";
		СтрокаКартинка.ТипЗначения = "Картинка";
		СтрокаКартинка.Служебное = Истина;
		
		СтрокиДерева = СтрокаКартинка.ПолучитьЭлементы();
		
		Для Каждого Картинка Из Метаданные.ОбщиеКартинки Цикл
			НоваяСтрока = СтрокиДерева.Добавить();
			НоваяСтрока.Поле = ?(ЗначениеЗаполнено(Картинка.Синоним), Картинка.Синоним, Картинка.Имя);
			НоваяСтрока.ИдентификаторПоля = Картинка.Имя;
			НоваяСтрока.ТипЗначения = "Картинка";
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОбработкаВыбораСтроки(ВыбраннаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораСтроки(ТекущаяСтрока)
	ТекущаяСтрока = Элементы.Дерево.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущаяСтрока.Служебное Тогда
		ОповеститьОВыборе(ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокиДереваПоВидуОбъектов(Знач СтруктураКоллекции)
	
	СтрокиДерева = Дерево.ПолучитьЭлементы();
	
	МетаданныеВида = Метаданные[СтруктураКоллекции.Коллекция];
	СтрокаВида = СтрокиДерева.Добавить();
	СтрокаВида.Поле = СтруктураКоллекции.Коллекция;
	СтрокаВида.ТипЗначения = СтруктураКоллекции.ТипЗначения;
	СтрокаВида.Служебное = Истина;
	
	ПодчиненныеСтроки = СтрокаВида.ПолучитьЭлементы();
	
	Для Каждого Объект Из МетаданныеВида Цикл
		НоваяСтрока = ПодчиненныеСтроки.Добавить();
		НоваяСтрока.Поле = Объект.Синоним;
		НоваяСтрока.ИдентификаторПоля = Объект.Имя;
		НоваяСтрока.ТипЗначения = СтруктураКоллекции.ТипЗначения;
		
		Если СтруктураКоллекции.ЕстьТЧ И ВыводитьТЧОбъектов Тогда
			ПодчиненныеСтроки2 = НоваяСтрока.ПолучитьЭлементы();
			
			Для Каждого ТЧ Из Объект.ТабличныеЧасти Цикл
				НоваяСтрокаТЧ = ПодчиненныеСтроки2.Добавить();
				НоваяСтрокаТЧ.Поле = ТЧ.Синоним;
				НоваяСтрокаТЧ.ИдентификаторПоля = Объект.Имя + "." + ТЧ.Имя;
				НоваяСтрокаТЧ.ТипЗначения = СтруктураКоллекции.ТипЗначения;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоответствиеТипаЗначенияКоллекциямОбъектов()
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить("Справочники", "Справочник");
	Соответствие.Вставить("Документы", "Документ");
	Соответствие.Вставить("Отчеты", "Отчеты");
	Соответствие.Вставить("ПланыВидовХарактеристик", "ПланВидовХарактеристик");
	Соответствие.Вставить("ПланыСчетов", "ПланСчетов");
	Соответствие.Вставить("ПланыВидовРасчета", "ПланВидовРасчета");
	Соответствие.Вставить("РегистрыСведений", "РегистрСведений");
	Соответствие.Вставить("РегистрыНакопления", "РегистрНакопления");
	Соответствие.Вставить("РегистрыБухгалтерии", "РегистрБухгалтерии");
	Соответствие.Вставить("РегистрыРасчета", "РегистрРасчета");
	Соответствие.Вставить("БизнесПроцессы", "БизнесПроцесс");
	Соответствие.Вставить("Задачи", "Задача");
	
	Возврат Соответствие;
	
КонецФункции