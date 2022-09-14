﻿////////////////////////////////////////////////////////////////////////////////
// Общего назначения (сервер): для серверных функций общего назначения
// с повторным использованием

#Область ПрограммныйИнтерфейс

#Область ПодпискиНаСобытияДокументов

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("ДокументОбъект.АвансовыйОтчет"), "АвансовыйОтчетПередЗаписью");
//
Функция ДокументыПередЗаписью() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("ДокументОбъект.АвансовыйОтчет"), "АвансовыйОтчетПриЗаписи");
//
Функция ДокументыПриЗаписи() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("ДокументОбъект.АвансовыйОтчет"), "АвансовыйОтчетОбработкаПроведения");
//
Функция ДокументыОбработкаПроведения() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("ДокументОбъект.АвансовыйОтчет"), "АвансовыйОтчетОбработкаЗаполнения");
//
Функция ДокументыОбработкаЗаполнения() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("ДокументОбъект.АвансовыйОтчет"), "АвансовыйОтчетПриКопировании");
//
Функция ДокументыПриКопировании() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти // ПодпискиНаСобытияДокументов

#Область ПодпискиНаСобытияСправочников

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("СправочникОбъект.Номенеклатура"), "НоменеклатураПередЗаписью");
//
Функция СправочникиПередЗаписью() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("СправочникОбъект.Номенеклатура"), "НоменеклатураПриЗаписи");
//
Функция СправочникиПриЗаписи() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("СправочникОбъект.Номенеклатура"), "НоменеклатураОбработкаЗаполнения");
//
Функция СправочникиОбработкаЗаполнения() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

// Определяет соответствие типа источника подписки и имени метода.
//
// Возвращаемое значение:
//   Соответствие - в качестве ключа передается тип объекта источника подписки,
// 					а в качестве значения имя исполняемого метода.
//
// Пример:
// Соответствие.Вставить(Тип("СправочникОбъект.Номенеклатура"), "НоменеклатураПриКопировании");
//
Функция СправочникиПриКопировании() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Возврат Соответствие;
	
КонецФункции

#КонецОбласти // ПодпискиНаСобытияСправочников

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

#КонецОбласти // СлужебныеПроцедурыИФункции