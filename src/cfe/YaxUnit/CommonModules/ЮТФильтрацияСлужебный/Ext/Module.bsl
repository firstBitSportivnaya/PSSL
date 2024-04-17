﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

Функция ЭтоПодходящееРасширение(ИмяРасширения) Экспорт
	
	Контекст = ЮТКонтекстСлужебный.КонтекстЧитателя();
	
	НормализованноеИмяРасширения = УдалитьНедопустимыеСимволыИзСтрокиКакКлючаСтруктуры(ИмяРасширения);
	
	Возврат НЕ Контекст.Фильтр.ЕстьФильтрРасширений ИЛИ Контекст.Фильтр.Расширения.Свойство(НормализованноеИмяРасширения);
	
КонецФункции

Функция ЭтоПодходящийМодуль(ОписаниеМодуля) Экспорт
	
	Контекст = ЮТКонтекстСлужебный.КонтекстЧитателя();
	
	Возврат ЗначениеЗаполнено(ОписаниеМодуля.Расширение)
		И (НЕ Контекст.Фильтр.ЕстьФильтрМодулей ИЛИ Контекст.Фильтр.Модули.Свойство(ОписаниеМодуля.Имя))
		И ЭтоПодходящееРасширение(ОписаниеМодуля.Расширение);
	
КонецФункции

// Отфильтровать тестовые наборы.
//
// Параметры:
//  ТестовыеНаборы - Массив из см. ЮТФабрикаСлужебный.ОписаниеТестовогоНабора - Тестовые наборы
//  ОписаниеМодуля - Структура - Описание модуля, которому принадлежат наборы, см. ЮТФабрикаСлужебный.ОписаниеМодуля
//
// Возвращаемое значение:
//  Массив из см. ЮТФабрикаСлужебный.ОписаниеТестовогоНабора - Отфильтрованные наборы
Функция ОтфильтроватьТестовыеНаборы(ТестовыеНаборы, ОписаниеМодуля) Экспорт
	
	Контекст = ЮТКонтекстСлужебный.КонтекстЧитателя();
	
	Если НЕ Контекст.Фильтр.ЕстьФильтрТестов И НЕ Контекст.Фильтр.ЕстьФильтрКонтекстов Тогда
		Возврат ТестовыеНаборы;
	КонецЕсли;
	
	Результат = Новый Массив();
	
	Если Контекст.Фильтр.ЕстьФильтрТестов Тогда
		ДоступныеТестовыеМетоды = Новый Соответствие();
		
		Для Каждого ОписаниеИмениТеста Из Контекст.Фильтр.Тесты Цикл
			
			Если СтрСравнить(ОписаниеИмениТеста.ИмяМодуля, ОписаниеМодуля.Имя) = 0 Тогда
				ОписаниеИмениТеста.ИмяМетода = ВРег(ОписаниеИмениТеста.ИмяМетода);
				
				СохраненноеОписаниеИмени = ДоступныеТестовыеМетоды[ОписаниеИмениТеста.ИмяМетода];
				
				Если СохраненноеОписаниеИмени = Неопределено И ОписаниеИмениТеста.Контекст = Неопределено Тогда
					ДоступныеТестовыеМетоды.Вставить(ВРег(ОписаниеИмениТеста.ИмяМетода), ОписаниеИмениТеста);
				ИначеЕсли СохраненноеОписаниеИмени = Неопределено Тогда
					ОписаниеИмениТеста.Контекст = ЮТКоллекции.ЗначениеВМассиве(ОписаниеИмениТеста.Контекст);
					ДоступныеТестовыеМетоды.Вставить(ВРег(ОписаниеИмениТеста.ИмяМетода), ОписаниеИмениТеста);
				ИначеЕсли ОписаниеИмениТеста.Контекст = Неопределено Тогда
					СохраненноеОписаниеИмени.Контекст = Неопределено; // Без фильтрации контекста теста, возьмом из самого теста контексты
				ИначеЕсли СохраненноеОписаниеИмени.Контекст <> Неопределено Тогда
					СохраненноеОписаниеИмени.Контекст.Добавить(ОписаниеИмениТеста.Контекст);
				Иначе
					// Если было имя теста без контекста, то будет вызов во всех контекстах
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Для Каждого Набор Из ТестовыеНаборы Цикл
		
		ОтфильтрованныйНабор = ЮТФабрикаСлужебный.ОписаниеТестовогоНабора(Набор.Имя);
		ЗаполнитьЗначенияСвойств(ОтфильтрованныйНабор, Набор, , "Тесты");
		
		Для Каждого Тест Из Набор.Тесты Цикл
			
			КонтекстыТеста = Неопределено;
			
			Если ДоступныеТестовыеМетоды <> Неопределено Тогда
				ОписаниеИмениТеста = ДоступныеТестовыеМетоды[ВРег(Тест.Имя)];
				
				Если ОписаниеИмениТеста = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				КонтекстыТеста = ОписаниеИмениТеста.Контекст;
				
			КонецЕсли;
			
			Если КонтекстыТеста = Неопределено Тогда
				КонтекстыТеста = Тест.КонтекстВызова;
			КонецЕсли;
			
			Если Контекст.Фильтр.ЕстьФильтрКонтекстов Тогда
				КонтекстыТеста = ЮТКоллекции.ПересечениеМассивов(КонтекстыТеста, Контекст.Фильтр.Контексты);
			КонецЕсли;
			
			Если КонтекстыТеста.Количество() = 0 Тогда
				// Возможно стоит такие выводить в лог с ошибкой "по переданным параметрам контекст теста не определен"
				Продолжить;
			КонецЕсли;
			
			ОтфильтрованныйТест = ЮТФабрикаСлужебный.ОписаниеТеста(Тест.Имя, "", "");
			ЗаполнитьЗначенияСвойств(ОтфильтрованныйТест, Тест, , "КонтекстВызова");
			ОтфильтрованныйТест.КонтекстВызова = КонтекстыТеста;
			
			ОтфильтрованныйНабор.Тесты.Добавить(ОтфильтрованныйТест);
			
		КонецЦикла;
		
		Если ОтфильтрованныйНабор.Тесты.Количество() Тогда
			Результат.Добавить(ОтфильтрованныйНабор);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Фильтр
//  Конструктур фильтра поиска тестовых методов
//
// Возвращаемое значение:
//  Структура - Фильтр:
// * Расширения - Структура - Имена расширений
// * Модули - Структура - Имена модулей
// * Наборы - Массив из Строка - Имена тестовых наборов
// * Теги - Массив из Строка
// * Контексты - Массив из Строка - Контексты вызова тестовых методов
// * Тесты - Массив из см. ОписаниеИмениТеста - Список путей к тестовым методам
// * Пути - Массив из Строка
Функция Фильтр() Экспорт
	
	//@skip-check structure-consructor-too-many-keys
	Фильтр = Новый Структура("Расширения, Модули, Наборы, Теги, Контексты, Пути, Тесты");
	
	Фильтр.Расширения = Новый Структура();
	Фильтр.Модули = Новый Структура();
	Фильтр.Теги = Новый Массив();
	Фильтр.Контексты = Новый Массив();
	Фильтр.Наборы = Новый Массив();
	Фильтр.Пути = Новый Массив();
	Фильтр.Тесты = Новый Массив();
	
	//@skip-check constructor-function-return-section
	Возврат Фильтр;
	
КонецФункции

Процедура УстановитьКонтекст(ПараметрыЗапускаТестов) Экспорт
	
	Расширения = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "extensions", Новый Массив);
	Модули = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "modules", Новый Массив);
	Контексты = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "contexts");
	Тесты = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "tests", Новый Массив);
	
	Теги = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "tags", Новый Массив);
	// TODO: Подумать в каком формате задать наборы - ИмяМодуля.Набор, Набор или другой вариант
	Наборы = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "suites", Новый Массив);
	// TODO: Обработка путей в формате: Модуль.ИмяТеста, ИмяТеста - метод, параметры, контекст
	// ОМ_ЮТУтверждения.Что[0: 1].Сервер, ОМ_ЮТУтверждения.Что[1: Структура].Сервер
	Пути = ЮТКоллекции.ЗначениеСтруктуры(ПараметрыЗапускаТестов.filter, "paths", Новый Массив);
	
	Фильтр = Фильтр();
	
	Фильтр.Расширения = МассивВСтруктуру(Расширения);
	Фильтр.Модули = МассивВСтруктуру(Модули);
	
	Если Контексты = Неопределено Тогда
		Фильтр.Контексты = ЮТФабрикаСлужебный.КонтекстыПриложения();
	Иначе
		Фильтр.Контексты = Контексты;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Теги) Тогда
		Фильтр.Теги = Теги;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Наборы) Тогда
		Фильтр.Наборы = Наборы;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Пути) Тогда
		Фильтр.Пути = Пути;
	КонецЕсли;
	
	МодулиТестов = Новый Структура();
	
	Если ЗначениеЗаполнено(Тесты) Тогда
		Для Каждого ПолноеИмяТеста Из Тесты Цикл
			Описание = ОписаниеИмениТеста(ПолноеИмяТеста);
			Фильтр.Тесты.Добавить(Описание);
			МодулиТестов.Вставить(Описание.ИмяМодуля, Истина);
		КонецЦикла;
	КонецЕсли;
	
	Если МодулиТестов.Количество() И Фильтр.Модули.Количество() = 0 Тогда
		
		Фильтр.Модули = МодулиТестов;
		
	ИначеЕсли МодулиТестов.Количество() Тогда
		
		Модули = Новый Структура();
		
		Для Каждого Элемент Из Фильтр.Модули Цикл
			Если МодулиТестов.Свойство(Элемент.Ключ) Тогда
				Модули.Вставить(Элемент.Ключ, Истина);
			КонецЕсли;
		КонецЦикла;
		
		Фильтр.Модули = Модули;
		
	КонецЕсли;
	
	Фильтр.Вставить("ЕстьФильтрРасширений", Фильтр.Расширения.Количество() > 0);
	Фильтр.Вставить("ЕстьФильтрМодулей", МодулиТестов.Количество() ИЛИ Фильтр.Модули.Количество());
	Фильтр.Вставить("ЕстьФильтрТестов", Фильтр.Тесты.Количество());
	Фильтр.Вставить("ЕстьФильтрКонтекстов", ЗначениеЗаполнено(Фильтр.Контексты));
	
	ЮТКонтекстСлужебный.УстановитьКонтекстЧитателя(Новый Структура("Фильтр", Фильтр));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция МассивВСтруктуру(Значения)
	
	Результат = Новый Структура();
	
	Если НЕ ЗначениеЗаполнено(Значения) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Значение Из Значения Цикл
		
		НормализованноеЗначение = УдалитьНедопустимыеСимволыИзСтрокиКакКлючаСтруктуры(Значение);
		Результат.Вставить(НормализованноеЗначение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция УдалитьНедопустимыеСимволыИзСтрокиКакКлючаСтруктуры(СтрокаКакКлюч)
	// TODO Переработать. Не модифицировать значение
	Возврат СтрЗаменить(СтрокаКакКлюч, ".", "");
КонецФункции

Функция ОписаниеИмениТеста(Путь)
	
	Части = СтрРазделить(Путь, ".");
	
	Если Части.Количество() <= 1 ИЛИ Части.Количество() > 3 Тогда
		ВызватьИсключение СтрШаблон("Не корректный формат пути к тесту `%1`, должен быть в формате `ИмяМодуля.ИмяМетода{.Контекст}`", Путь);
	КонецЕсли;
	
	Описание = Новый Структура("ИмяМодуля, ИмяМетода, Контекст");
	
	Для Инд = 0 По Части.ВГраница() Цикл
		Части[Инд] = СокрЛП(Части[Инд]);
	КонецЦикла;
	
	Описание.ИмяМодуля = Части[0];
	Описание.ИмяМетода = Части[1];
	Если Части.Количество() > 2 Тогда
		Описание.Контекст = Части[2];
	КонецЕсли;
	
	Возврат Описание;
	
КонецФункции

#КонецОбласти
