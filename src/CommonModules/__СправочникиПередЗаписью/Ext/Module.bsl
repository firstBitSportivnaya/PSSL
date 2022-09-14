﻿////////////////////////////////////////////////////////////////////////////////
// Справочники событие "Перед записью" (вызов сервера): обработка событий перед записью

#Область ПрограммныйИнтерфейс

// Возникает перед выполнением записи элемента справочника.
// Процедура-обработчик вызывается после начала транзакции записи, но до начала записи элемента справочника.
//
// Параметры:
//  Источник - СправочникОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ	 - Булево - Признак отказа от записи элемента.
//
Процедура СправочникиПередЗаписью(Источник, Отказ) Экспорт
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = __ОбщегоНазначенияПовтИсп.СправочникиПередЗаписью().Получить(ТипЗнч(Источник));
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			Выполнить(СтрШаблон("%1(Источник, Отказ)", ИмяМетода));
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции