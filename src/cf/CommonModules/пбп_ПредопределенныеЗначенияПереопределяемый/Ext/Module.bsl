﻿
#Область ПрограммныйИнтерфейс

// Возвращает таблицу предопределенных элементов справочника
// ПланыВидовХарактеристикСсылка.пбп_ПредопределенныеЗначения.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица заполненная предопределенными элементами.
//
Функция ПредопределенныеЗначения() Экспорт
	
	Результат = ТаблицаПредопределенныхПредопределенныеЗначения();

	ОписаниеЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(10,0));
	
	// Добавление
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Интеграции";
	НоваяНастройка.ИдентификаторНастройки = "Интеграции";
	НоваяНастройка.ЭтоГруппа = Истина;
	НоваяНастройка.УровеньИерархии = 0;
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Интеграции локал";
	НоваяНастройка.ИдентификаторНастройки = "Интеграции_локал";
	НоваяНастройка.ЭтоГруппа = Истина;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	НоваяНастройка.УровеньИерархии = 1;
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тестовая";
	НоваяНастройка.ИдентификаторНастройки = "Тестовая";
	НоваяНастройка.ЭтоГруппа = Истина;
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Количество дней хранения истории интеграции";
	НоваяНастройка.ИдентификаторНастройки = "КолДнейХраненияИсторииИнтеграции";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = ОписаниеЧисло;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Количество дней хранения ошибок истории интеграции";
	НоваяНастройка.ИдентификаторНастройки = "КолДнейХраненияОшибокИсторииИнтеграции";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = ОписаниеЧисло;
	НоваяНастройка.ИдентификаторРодитель = "Интеграции";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тест_бул";
	НоваяНастройка.ИдентификаторНастройки = "Тест_бул";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Булево");
	НоваяНастройка.ИдентификаторРодитель = "Тестовая";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тест_список";
	НоваяНастройка.ИдентификаторНастройки = "Тест_список";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Истина;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Строка");
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицу предопределенных элементов справочника СправочникСсылка.пбп_ИнтегрируемыеСистемы.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица заполненная предопределенными элементами.
//
Функция ПредопределенныеЗначенияИнтегрируемыеСистемы() Экспорт
	
	Результат = ТаблицаПредопределенныхИнтегрируемыеСистемы();
	
	// Добавление
	НоваяСистема = Результат.Добавить();
	НоваяСистема.Наименование = "Система N";
	НоваяСистема.ИдентификаторНастройки = "СистемаN";
	
	НоваяСистема = Результат.Добавить();
	НоваяСистема.Наименование = "Rabbit Mq";
	НоваяСистема.ИдентификаторНастройки = "RabbitMq";
	
	НоваяСистема = Результат.Добавить();
	НоваяСистема.Наименование = "Kafka";
	НоваяСистема.ИдентификаторНастройки = "Kafka";
	
	НоваяСистема = Результат.Добавить();
	НоваяСистема.Наименование = "Active directory";
	НоваяСистема.ИдентификаторНастройки = "ActiveDirectory";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицу предопределенных элементов справочника СправочникСсылка.пбп_МетодыИнтеграции.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица заполненная предопределенными элементами.
//
Функция ПредопределенныеЗначенияИнтеграционныеПотоки() Экспорт
	
	Результат = ТаблицаПредопределенныхИнтеграционныеПотоки();
	
	// Добавление
	НовыйМетод = Результат.Добавить();
	НовыйМетод.Наименование = "Интеграционный поток системы N";
	НовыйМетод.ИдентификаторНастройки = "ИнтеграционныйПотокСистемыN";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицу предопределенных элементов справочника СправочникСсылка.пбп_НастройкиИнтеграции.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица заполненная предопределенными элементами.
//
Функция ПредопределенныеЗначенияНастройкиИнтеграции() Экспорт
	
	Результат = ТаблицаПредопределенныхНастройкиИнтеграции();
	
	// Добавление
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Интеграция с системой N";
	НоваяНастройка.ИдентификаторНастройки = "ИнтеграцияССистемойN";
	
	НаименованиеРеквизита = "ИдентификаторНастройки";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Rabbit Mq";
	НоваяНастройка.ИдентификаторНастройки = "RabbitMq";
	НоваяНастройка.ИнтегрируемаяСистема = Справочники.пбп_ИнтегрируемыеСистемы.НайтиПоРеквизиту(
		НаименованиеРеквизита, "RabbitMq");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.RabbitMq;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Simple Kafka";
	НоваяНастройка.ИдентификаторНастройки = "SimpleKafka";
	НоваяНастройка.ИнтегрируемаяСистема = Справочники.пбп_ИнтегрируемыеСистемы.НайтиПоРеквизиту(
		НаименованиеРеквизита, "Kafka");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.Kafka;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Active directory";
	НоваяНастройка.ИдентификаторНастройки = "ActiveDirectory";
	НоваяНастройка.СтрокаПодключения = "Provider=""ADsDSOObject""";
	НоваяНастройка.ИнтегрируемаяСистема = Справочники.пбп_ИнтегрируемыеСистемы.НайтиПоРеквизиту(
		НаименованиеРеквизита, "ActiveDirectory");
	НоваяНастройка.ТипИнтеграции = Справочники.пбп_ТипыИнтеграций.COM;
	НоваяНастройка.ТипАвторизации = Перечисления.пбп_ТипыАвторизации.Базовая;
	НоваяНастройка.ИмяОбъекта = "ADODB.Connection";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

// Возвращает таблицу предопределенных элементов справочника СправочникСсылка.пбп_ТипСоответствияОбъектовИБ.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица заполненная предопределенными элементами.
//
Функция ПредопределенныеЗначенияТипСоответствияОбъектовИБ() Экспорт
	
	Результат = ТаблицаПредопределенныхТипСоответствияОбъектовИБ();
	
	// Добавление
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тест";
	НоваяНастройка.ИдентификаторНастройки = "Тест";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

#Область СтруктурыКолонокТаблиц

Функция КолонкиПредопределенныеЗначения() Экспорт
	
	Колонки = ОбщиеКолонки();
	
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	
	// Добавление
	Колонки.Вставить("Пароль", ОписаниеБулево);
	Колонки.Вставить("СписокЗначений", ОписаниеБулево);
	Колонки.Вставить("ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"));
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

Функция КолонкиИнтегрируемыеСистемы() Экспорт
	
	Колонки = ОбщиеКолонки();
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

Функция КолонкиИнтеграционныеПотоки() Экспорт
	
	Колонки = ОбщиеКолонки();
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

Функция КолонкиНастройкиИнтеграции() Экспорт
	
	Колонки = ОбщиеКолонки();
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

Функция КолонкиТипСоответствияОбъектовИБ() Экспорт
	
	Колонки = ОбщиеКолонки();
	
	// Добавление
	
	// КонецДобавления
	
	Возврат Колонки;
	
КонецФункции

#КонецОбласти

Функция ИсключаемыеПоляДляРасчетаХешаЭлемент() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("ХешСумма");
	Поля.Вставить("УровеньИерархии");
	Поля.Вставить("ИдентификаторРодитель");
	
	Возврат Поля;
	
КонецФункции

Функция ИсключаемыеПоляДляРасчетаХешаГруппа() Экспорт
	
	Поля = Новый Структура;
	Поля.Вставить("ХешСумма");
	Поля.Вставить("УровеньИерархии");
	Поля.Вставить("ИдентификаторРодитель");
	Поля.Вставить("Пароль");
	Поля.Вставить("СписокЗначений");
	
	Возврат Поля;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

Функция ТаблицаПредопределенныхПредопределенныеЗначения()
	
	Результат = Новый ТаблицаЗначений;
	
	Колонки = КолонкиПредопределенныеЗначения();
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхИнтегрируемыеСистемы()
	
	Результат = Новый ТаблицаЗначений;
	
	Колонки = КолонкиИнтегрируемыеСистемы();
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхИнтеграционныеПотоки()
	
	Результат = Новый ТаблицаЗначений;
	
	Колонки = КолонкиИнтеграционныеПотоки();
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхНастройкиИнтеграции()
	
	Результат = Новый ТаблицаЗначений;
	
	Колонки = КолонкиНастройкиИнтеграции();
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Результат);
	
	Результат.Колонки.Добавить("ИнтегрируемаяСистема"	, Новый ОписаниеТипов("СправочникСсылка.пбп_ИнтегрируемыеСистемы"));
	Результат.Колонки.Добавить("ТипИнтеграции"			, Новый ОписаниеТипов("СправочникСсылка.пбп_ТипыИнтеграций"));
	Результат.Колонки.Добавить("СтрокаПодключения"		, пбп_ОбщегоНазначенияСервер.ОписаниеТипаСтрока(200));
	Результат.Колонки.Добавить("ТипАвторизации"			, Новый ОписаниеТипов("ПеречислениеСсылка.пбп_ТипыАвторизации"));
	Результат.Колонки.Добавить("ИмяОбъекта"				, пбп_ОбщегоНазначенияСервер.ОписаниеТипаСтрока(100));
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхТипСоответствияОбъектовИБ()
	
	Результат = Новый ТаблицаЗначений;
	
	Колонки = КолонкиТипСоответствияОбъектовИБ();
	
	СоздатьКолонкиТаблицыПредопределенныхЭлементов(Колонки, Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ОбщиеКолонки()
	
	Колонки = Новый Структура;
	
	ОписаниеСтрока = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(150));
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	
	Колонки.Вставить("ИдентификаторНастройки", ОписаниеСтрока);
	Колонки.Вставить("Наименование", ОписаниеСтрока);
	Колонки.Вставить("ЭтоГруппа", ОписаниеБулево);
	Колонки.Вставить("Родитель", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.пбп_ПредопределенныеЗначения"));
	
	Колонки.Вставить("Служеб_ОбновитьЭлемент", ОписаниеБулево);
	Колонки.Вставить("Служеб_УстановитьФлагРучноеИзменение", ОписаниеБулево);
	Колонки.Вставить("Служеб_ПредопределенныйЭлемент", Неопределено);
	
	Колонки.Вставить("УровеньИерархии", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(2,0)));
	Колонки.Вставить("ИдентификаторРодитель", ОписаниеСтрока);
	Колонки.Вставить("ХешСумма", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(32)));
	
	Возврат Колонки;
	
КонецФункции

Процедура СоздатьКолонкиТаблицыПредопределенныхЭлементов(СтруктураСКолонками, Таблица)
	
	Для Каждого КлючЗначение Из СтруктураСКолонками Цикл
		Если Таблица.Колонки.Найти(КлючЗначение.Ключ) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Таблица.Колонки.Добавить(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
