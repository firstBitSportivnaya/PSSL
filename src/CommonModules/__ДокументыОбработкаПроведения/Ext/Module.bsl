﻿////////////////////////////////////////////////////////////////////////////////
// Документы событие "Обработка проведения" (вызов сервера): обработка событий при проведении

#Область ПрограммныйИнтерфейс

// Возникает при проведении документа.
// Основное назначение процедуры-обработчика данного события - генерация движений по документу. Выполняется в транзакции записи.
//
// Параметры:
//  Источник		 - ДокументОбъект - Объект, обрабатываемый подпиской на события.
//  Отказ			 - Булево - Признак проведения документа.
//  РежимПроведения	 - РежимПроведенияДокумента - Текущий режим проведения.
//
Процедура ДокументыОбработкаПроведения(Источник, Отказ, РежимПроведения) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = __ВспомогательныйМодульНеПереносить;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Отказ Или Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИмяМетода = __ОбщегоНазначенияПовтИсп.ДокументыОбработкаПроведения().Получить(ТипЗнч(Источник));
	
	Если ЗначениеЗаполнено(ИмяМетода) Тогда
		Попытка
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(Источник);
			ПараметрыМетода.Добавить(Отказ);
			ПараметрыМетода.Добавить(РежимПроведения);
			
			ОбщегоНазначения.ВыполнитьМетодКонфигурации(ИмяМетода, ПараметрыМетода);
			
		Исключение
			ВызватьИсключение СтрШаблон("%1%2Имя метода: %3", ОписаниеОшибки(), Символы.ПС, ИмяМетода);
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти