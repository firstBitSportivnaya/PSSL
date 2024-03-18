﻿
#Область ПрограммныйИнтерфейс

Функция ЗначениеСоответствияПоИдентиифкатору(Идентификатор) Экспорт
	
	Результат = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	__ТипСоответствияОбъектовИБ.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.__ТипСоответствияОбъектовИБ КАК __ТипСоответствияОбъектовИБ
		|ГДЕ
		|	__ТипСоответствияОбъектовИБ.ИдентификаторНастройки = &ИдентификаторНастройки";
	
	Запрос.УстановитьПараметр("ИдентификаторНастройки", Идентификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат = ВыборкаДетальныеЗаписи.Ссылка; 
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПредопределенныеЗначения() Экспорт
	
	ТЗПредопределенныхЗначений = __ТипСоответствияОбъектовИБПереопределяемый.ПредопределенныеЗначения();
	
	ТЗПредопределенныхЗначенийКСозданию = __ПредопределенныеЗначения.ПредопределенныеЗначенияКСозданию(ТЗПредопределенныхЗначений, "Справочник.__ТипСоответствияОбъектовИБ");
	
	Пока ТЗПредопределенныхЗначенийКСозданию.Следующий() Цикл
		
		__ПредопределенныеЗначения.СоздатьПредопределенноеЗначение(ТЗПредопределенныхЗначенийКСозданию, "Справочники.__ТипСоответствияОбъектовИБ");
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти