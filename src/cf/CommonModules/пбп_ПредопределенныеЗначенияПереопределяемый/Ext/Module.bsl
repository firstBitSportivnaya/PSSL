﻿
#Область ПрограммныйИнтерфейс

Функция ПредопределенныеЗначения() Экспорт
	
	Результат = ТаблицаПредопределенных();

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
	НоваяНастройка.Родитель = "Интеграции";
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
	НоваяНастройка.Родитель = "Интеграции";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Количество дней хранения ошибок истории интеграции";
	НоваяНастройка.ИдентификаторНастройки = "КолДнейХраненияОшибокИсторииИнтеграции";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = ОписаниеЧисло;
	НоваяНастройка.Родитель = "Интеграции";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тест_бул";
	НоваяНастройка.ИдентификаторНастройки = "Тест_бул";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Ложь;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Булево");
	НоваяНастройка.Родитель = "Тестовая";
	
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Тест_список";
	НоваяНастройка.ИдентификаторНастройки = "Тест_список";
	НоваяНастройка.Пароль = Ложь;
	НоваяНастройка.СписокЗначений = Истина;
	НоваяНастройка.ТипЗначения = Новый ОписаниеТипов("Строка");
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

Функция ПредопределенныеЗначенияИнтегрируемыеСистемы() Экспорт
	
	Результат = ТаблицаПредопределенныхИнтегрируемыеСистемы();
	
	// Добавление
	НоваяСистема = Результат.Добавить();
	НоваяСистема.Наименование = "Система N";
	НоваяСистема.ИдентификаторНастройки = "СистемаN";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

Функция ПредопределенныеЗначенияМетодыИнтеграции() Экспорт
	
	Результат = ТаблицаПредопределенныхМетодыИнтеграции();
	
	// Добавление
	НовыйМетод = Результат.Добавить();
	НовыйМетод.Наименование = "Метод интеграции системы N";
	НовыйМетод.ИдентификаторНастройки = "МетодИнтеграцииСистемыN";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

Функция ПредопределенныеЗначенияНастройкиИнтеграции() Экспорт
	
	Результат = ТаблицаПредопределенныхНастройкиИнтеграции();
	
	// Добавление
	НоваяНастройка = Результат.Добавить();
	НоваяНастройка.Наименование = "Интеграция с системой N";
	НоваяНастройка.ИдентификаторНастройки = "ИнтеграцияССистемойN";
	// КонецДобавления
	
	Возврат Результат;
	
КонецФункции

Процедура ОбщиеКолонкиТаблицыПредопределенныхЗначений(Таблица) Экспорт
	
	ОписаниеСтрока = Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(150));
	
	Таблица.Колонки.Добавить("ИдентификаторНастройки", ОписаниеСтрока);
	Таблица.Колонки.Добавить("Наименование", ОписаниеСтрока);
	Таблица.Колонки.Добавить("ЭтоГруппа", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("Родитель", ОписаниеСтрока);
	Таблица.Колонки.Добавить("УровеньИерархии", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(2,0)));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции 

Функция ТаблицаПредопределенных()
	
	Результат = Новый ТаблицаЗначений;
	
	ОписаниеБулево = Новый ОписаниеТипов("Булево");
	
	ОбщиеКолонкиТаблицыПредопределенныхЗначений(Результат);
	
	Результат.Колонки.Добавить("Пароль", ОписаниеБулево);
	Результат.Колонки.Добавить("СписокЗначений", ОписаниеБулево);
	Результат.Колонки.Добавить("ТипЗначения", Новый ОписаниеТипов("ОписаниеТипов"));
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхИнтегрируемыеСистемы()
	
	Результат = Новый ТаблицаЗначений;
	
	ОбщиеКолонкиТаблицыПредопределенныхЗначений(Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхМетодыИнтеграции()
	
	Результат = Новый ТаблицаЗначений;
	
	ОбщиеКолонкиТаблицыПредопределенныхЗначений(Результат);
	
	Возврат Результат;
	
КонецФункции

Функция ТаблицаПредопределенныхНастройкиИнтеграции()
	
	Результат = Новый ТаблицаЗначений;
	
	ОбщиеКолонкиТаблицыПредопределенныхЗначений(Результат);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти