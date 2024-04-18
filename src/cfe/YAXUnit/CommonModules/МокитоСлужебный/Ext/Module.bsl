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

Функция Включен() Экспорт
	
	ДанныеКонтекста = ЮТКонтекстСлужебный.ДанныеКонтекста();
	Настройки = Неопределено;
	Возврат ДанныеКонтекста <> Неопределено И ДанныеКонтекста.Свойство(КлючНастроек(), Настройки) И Настройки <> Неопределено;
	
КонецФункции

Процедура УстановитьРежим(Режим) Экспорт
	
	Контекст = Настройки();
	Контекст.Режим = Режим;
	ОчиститьСлужебныеПараметры();
	
КонецПроцедуры

// Настройки.
// 
// Возвращаемое значение:
//  см. НовыеНастройки
Функция Настройки() Экспорт
	
	Настройки = ЮТКонтекстСлужебный.ЗначениеКонтекста(КлючНастроек());
	
	Если Настройки = Неопределено Тогда
		ВызватьИсключение "Что-то пошло не так, настройки Мокито не инициализированы";
	КонецЕсли;
	
	//@skip-check constructor-function-return-section
	Возврат Настройки;
	
КонецФункции

#Область СтруктурыДанных

Функция РежимыРаботы() Экспорт
	
	Режимы = Новый Структура();
	Режимы.Вставить("Обучение", "Обучение");
	Режимы.Вставить("Тестирование", "Тестирование");
	Режимы.Вставить("Проверка", "Проверка");
	
	Возврат Новый ФиксированнаяСтруктура(Режимы);
	
КонецФункции

Функция ТипыДействийРеакций() Экспорт
	
	ТипыРеакций = Новый Структура();
	ТипыРеакций.Вставить("ВернутьРезультат", "ВернутьРезультат");
	ТипыРеакций.Вставить("ВыброситьИсключение", "ВыброситьИсключение");
	ТипыРеакций.Вставить("Пропустить", "Пропустить");
	ТипыРеакций.Вставить("ВызватьОсновнойМетод", "ВызватьОсновнойМетод");
	
	Возврат Новый ФиксированнаяСтруктура(ТипыРеакций);
	
КонецФункции

#КонецОбласти

Функция АнализВызова(Объект, ИмяМетода, ПараметрыМетода, ПрерватьВыполнение) Экспорт
	
	ПрерватьВыполнение = Ложь;
	
	Если НЕ Включен() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Настройки = Настройки();
	
	Если НЕ ЗначениеЗаполнено(Настройки.Перехват) Или Настройки.ТипыПерехватываемыхОбъектов[ТипЗнч(Объект)] = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПерехвата = ДанныеПерехвата(Объект, Настройки);
	
	Если ПараметрыПерехвата = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РежимыРаботы = РежимыРаботы();
	
	СтруктураВызоваМетода = СтруктураВызоваМетода(Объект, ИмяМетода, ПараметрыМетода);
	
	Если Настройки.Режим = РежимыРаботы.Обучение ИЛИ Настройки.Режим = РежимыРаботы.Проверка Тогда
		
		ПрерватьВыполнение = Истина;
		Возврат СтруктураВызоваМетода;
		
	ИначеЕсли Настройки.Режим = РежимыРаботы.Тестирование Тогда
		
		ЗарегистрироватьВызовМетода(Настройки, ПараметрыПерехвата, СтруктураВызоваМетода);
		Возврат ПерехватитьВызовМетода(ПараметрыПерехвата, СтруктураВызоваМетода, ПрерватьВыполнение);
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Структура вызова метода.
// 
// Параметры:
//  Объект 	- Произвольный - Объект, которому принадлежит метод
//   		- Структура - см. СтруктураВызоваМетода
//  ИмяМетода - Строка - Имя вызванного метода
//  ПараметрыМетода - Массив из Произвольный - Набор параметров, с которыми был вызван метод
// 
// Возвращаемое значение:
//  Структура - Информация о вызове метода:
//   * Объект - Произвольный - Объект, которому принадлежит метод
//   * ИмяМетода - Строка - Имя вызванного метода
//   * Параметры - Массив из Произвольный - Набор параметров, с которыми был вызван метод
//   * Контекст - Строка - Контекст вызова метода
Функция СтруктураВызоваМетода(Объект, ИмяМетода, ПараметрыМетода) Экспорт
	
	Если ЭтоСтруктураВызоваМетода(Объект) Тогда
		Возврат Объект;
	КонецЕсли;
	
	СтруктураВызоваМетода = Новый Структура("Объект, ИмяМетода, Параметры", Объект, ИмяМетода, ПараметрыМетода);
	СтруктураВызоваМетода.Вставить("Контекст");
	
	//@skip-check constructor-function-return-section
	Возврат СтруктураВызоваМетода;
	
КонецФункции

Функция ЭтоСтруктураВызоваМетода(Объект) Экспорт
	
	Возврат ТипЗнч(Объект) = Тип("Структура");
	
КонецФункции

#Область Предикаты

Функция ТипыУсловийПараметров() Экспорт
	
	Типы = Новый Структура;
	Типы.Вставить("Любой", "Любой");
	Типы.Вставить("Значение", "Значение");
	Типы.Вставить("Тип", "Тип");
	Типы.Вставить("ОписаниеТипа", "ОписаниеТипа");
	Типы.Вставить("Предикат", "Предикат");
	
	Возврат Новый ФиксированнаяСтруктура(Типы);
	
КонецФункции

// Описание маски параметра.
// 
// Параметры:
//  ТипУсловия - Строка - см. ТипыУсловийПараметров
//  Приоритет - Число - Приоритет маски
// 
// Возвращаемое значение:
//  Структура - Описание маски параметра:
// * Режим - Строка - см. ТипыУсловийПараметров
// * Приоритет - Число - Приоритет маски, используется если значение подпадает под несколько масок, чем выше приоритет, тем лучше
Функция ОписаниеМаскиПараметра(ТипУсловия, Приоритет) Экспорт
	
	МаскаПараметра = Новый Структура;
	ЮТОбщий.УказатьТипСтруктуры(МаскаПараметра, "МаскаПараметра");
	
	МаскаПараметра.Вставить("Режим", ТипУсловия);
	МаскаПараметра.Вставить("Приоритет", Приоритет);
	
	Возврат МаскаПараметра;
	
КонецФункции

Функция ЭтоМаскаПарамера(Параметр) Экспорт
	
	Возврат ТипЗнч(Параметр) = Тип("Структура") И ЮТОбщий.ТипСтруктуры(Параметр) = "МаскаПараметра";
	
КонецФункции

Функция ПроверитьПараметр(Параметр, Условие) Экспорт
	
	ТипыУсловий = ТипыУсловийПараметров();
	Совпадает = Ложь;
	
	Если Условие.Режим = ТипыУсловий.Любой Тогда
		
		Совпадает = Истина;
		
	ИначеЕсли Условие.Режим = ТипыУсловий.Значение Тогда
		
		Совпадает = ЮТСравнениеСлужебныйКлиентСервер.ЗначенияРавны(Условие.Значение, Параметр);
		
	ИначеЕсли Условие.Режим = ТипыУсловий.Тип Тогда
		
		Совпадает = Условие.Тип = ТипЗнч(Параметр);
		
	ИначеЕсли Условие.Режим = ТипыУсловий.ОписаниеТипа Тогда
		
		Совпадает = Условие.Тип.СодержитТип(ТипЗнч(Параметр));
		
	ИначеЕсли Условие.Режим = ТипыУсловий.Предикат Тогда
		
		Результат = ЮТПредикатыСлужебныйКлиентСервер.ПроверитьПредикаты(Параметр, Условие.Предикат);
		Совпадает = Результат.Успешно;
		
	КонецЕсли;
	
	Возврат Совпадает;
		
КонецФункции

#КонецОбласти

#Область Перехват

Функция ПараметрыПерехвата() Экспорт
	
	Возврат Настройки().Перехват;
	
КонецФункции

Функция НастройкиПерехватаОбъекта(Объект) Экспорт
	
	ПараметрыПерехвата = ПараметрыПерехвата();
	Возврат ПараметрыПерехвата[Объект];
	
КонецФункции

// Данные перехвата.
// 
// Параметры:
//  Объект - Произвольный
//  Настройки - см. НовыеНастройки
// 
// Возвращаемое значение:
//  см. ОписаниеПараметровПерехватаОбъекта
Функция ДанныеПерехвата(Объект, Настройки = Неопределено) Экспорт
	
	Если Настройки = Неопределено Тогда
		ПараметрыПерехвата = ПараметрыПерехвата();
	Иначе
		ПараметрыПерехвата = Настройки.Перехват;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ПараметрыПерехвата) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Объект) = Тип("Структура") Тогда
		Ключ = Объект.Объект;
	Иначе
		Ключ = Объект;
	КонецЕсли;
	
	ПараметрыПерехватаОбъекта = ПараметрыПерехвата[Ключ];
	ТипЗначения = ТипЗнч(Ключ);
	
	Если ПараметрыПерехватаОбъекта = Неопределено Тогда
		
		Если ЮТТипыДанныхСлужебный.ЭтоТипОбъектаОбработкиОтчета(ТипЗначения) Или ЮТТипыДанныхСлужебный.ЭтоТипНабораЗаписей(ТипЗначения) Тогда
			
			Менеджер = ЮТОбщий.Менеджер(ТипЗначения);
			ПараметрыПерехватаОбъекта = ПараметрыПерехвата[Менеджер];
			
		ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоТипОбъекта(ТипЗначения) Тогда
			
			ПараметрыПерехватаОбъекта = ПараметрыПерехвата[Ключ.Ссылка];
			
			Если ПараметрыПерехватаОбъекта = Неопределено Тогда
				
				Менеджер = ЮТОбщий.Менеджер(ТипЗначения);
				ПараметрыПерехватаОбъекта = ПараметрыПерехвата[Менеджер];
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//@skip-check constructor-function-return-section
	Возврат ПараметрыПерехватаОбъекта;
	
КонецФункции

Процедура ДобавитьНастройкуПерехватаВызововОбъекта(Знач Объект, СброситьСтарыеНастройки = Истина) Экспорт
	
	Настройки = Настройки();
	
	Если СброситьСтарыеНастройки ИЛИ Настройки.Перехват[Объект] = Неопределено Тогда
		Настройки.Перехват.Вставить(Объект, ОписаниеПараметровПерехватаОбъекта(Объект));
	КонецЕсли;
	
	ТипОбъекта = ТипЗнч(Объект);
	
	Настройки.ТипыПерехватываемыхОбъектов.Вставить(ТипОбъекта, Истина);
	
	Если ЮТТипыДанныхСлужебный.ЭтоСсылочныйТип(ТипОбъекта) Тогда
		ТипОбъекта = ЮТТипыДанныхСлужебный.ТипОбъектаСсылки(ТипОбъекта);
		Настройки.ТипыПерехватываемыхОбъектов.Вставить(ТипОбъекта, Истина);
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоТипМенеджера(ТипОбъекта) Тогда
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
		Описание = ЮТМетаданные.ОписаниеОбъектаМетаданных(ТипОбъекта);
		
		Если Описание <> Неопределено Тогда
			
			Если Описание.ОписаниеТипа.Ссылочный Или Описание.ОписаниеТипа.ОбработкаОтчет Тогда
				ТипОбъекта = Тип(СтрШаблон("%1Объект.%2", Описание.ОписаниеТипа.Имя, Описание.Имя));
			ИначеЕсли Описание.ОписаниеТипа.Регистр Тогда
				ТипОбъекта = Тип(СтрШаблон("%1НаборЗаписей.%2", Описание.ОписаниеТипа.Имя, Описание.Имя));
			КонецЕсли;
			
			Настройки.ТипыПерехватываемыхОбъектов.Вставить(ТипОбъекта, Истина);
			
		КонецЕсли;
#КонецЕсли
	КонецЕсли;

КонецПроцедуры

// Описание параметров перехвата объекта.
// 
// Параметры:
//  Объект - Произвольный - Объект
// 
// Возвращаемое значение:
//  Структура - Описание параметров перехвата объекта:
// * Объект - Произвольный
// * Методы - Структура 
Функция ОписаниеПараметровПерехватаОбъекта(Объект) Экспорт
	
	Возврат Новый Структура("Объект, Методы", Объект, Новый Структура);
	
КонецФункции

#КонецОбласти

#Область Статистика

Функция СтатистикаВызовов(Знач Объект, ИмяМетода) Экспорт
	
	Вызовы = Настройки().Статистика.Вызовы;
	
	СтатистикаВызововМетода = Новый Массив();
	Статистика = Вызовы[Объект];
	ТипОбъекта = ТипЗнч(Объект);
	
	Если Статистика <> Неопределено И Статистика.Свойство(ИмяМетода) Тогда
		СтатистикаВызововМетода = Статистика[ИмяМетода];
	ИначеЕсли Статистика = Неопределено И ЮТТипыДанныхСлужебный.ЭтоСсылочныйТип(ТипОбъекта) Тогда
		СтатистикаВызововМетода = СтатистикаВызововПоСсылке(Вызовы, Объект, ИмяМетода);
	ИначеЕсли ЮТТипыДанныхСлужебный.ЭтоТипМенеджера(ТипОбъекта) Тогда
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
		СтатистикаВызововМетода = СтатистикаВызововПоМенеджеру(Вызовы, Объект, ИмяМетода);
#КонецЕсли
	КонецЕсли;
	
	Возврат СтатистикаВызововМетода;
	
КонецФункции

Процедура ОчиститьСтатистику() Экспорт
	
	Настройки = Настройки();
	Настройки.Статистика.Вызовы.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередКаждымТестом(ОписаниеСобытия) Экспорт
	
	ИнициализироватьНастройки();
	
КонецПроцедуры

Процедура ПослеКаждогоТеста(ОписаниеСобытия) Экспорт
	
	ОчиститьНастройки();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаВызовов

Функция ПерехватитьВызовМетода(ПараметрыПерехвата, СтруктураВызоваМетода, ПрерватьВыполнение)
	
	Если НЕ ПараметрыПерехвата.Методы.Свойство(СтруктураВызоваМетода.ИмяМетода) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПараметрыПерехватаМетода = ПараметрыПерехвата.Методы[СтруктураВызоваМетода.ИмяМетода];
	
	Реакция = НайтиРеакцию(ПараметрыПерехватаМетода, СтруктураВызоваМетода);
	
	Если Реакция = Неопределено ИЛИ Реакция.Действие = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПрерватьВыполнение = Истина;
	
	ТипыДействий = ТипыДействийРеакций();
	
	Если Реакция.Действие.ТипДействия = ТипыДействий.ВернутьРезультат Тогда
		
		Реакция.Действие.Обработано = Истина;
		Возврат Реакция.Действие.Результат;
		
	ИначеЕсли Реакция.Действие.ТипДействия = ТипыДействий.ВыброситьИсключение Тогда
		
		Реакция.Действие.Обработано = Истина;
		ВызватьИсключение Реакция.Действие.Ошибка;
		
	ИначеЕсли Реакция.Действие.ТипДействия = ТипыДействий.Пропустить Тогда
		
		Реакция.Действие.Обработано = Истина;
		Возврат Неопределено;
		
	ИначеЕсли Реакция.Действие.ТипДействия = ТипыДействий.ВызватьОсновнойМетод Тогда
		
		Реакция.Действие.Обработано = Истина;
		ПрерватьВыполнение = Ложь;
		
	Иначе
		
		ВызватьИсключение "Неизвестный тип действия реакции";
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

Функция НайтиРеакцию(ПараметрыПерехватаМетода, СтруктураВызоваМетода)
	
	ПараметрыВызова = СтруктураВызоваМетода.Параметры;
	
	ПриоритетыРеакций = Новый Массив();
	ЛучшийПриоритет = 0;
	
	Для Каждого Реакция Из ПараметрыПерехватаМетода.Реакции Цикл
		
		ПриоритетРеакции = ПроверитьРеакцию(Реакция, ПараметрыВызова);
		
		Если ПриоритетРеакции < 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ПриоритетыРеакций.Добавить(Новый Структура("Приоритет, Реакция", ПриоритетРеакции, Реакция));
		
		Если ЛучшийПриоритет < ПриоритетРеакции Тогда
			ЛучшийПриоритет = ПриоритетРеакции;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЛучшийПриоритет <= 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Реакция = Неопределено;
	
	Для Каждого ПриоритетРеакции Из ПриоритетыРеакций Цикл
		
		Если ПриоритетРеакции.Приоритет = ЛучшийПриоритет Тогда
			Реакция = ПриоритетРеакции.Реакция;
		Иначе
			Продолжить;
		КонецЕсли;
		
		Если Реакция.Действие <> Неопределено И НЕ Реакция.Действие.Обработано Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Реакция;
	
КонецФункции

Функция ПроверитьРеакцию(Реакция, ПараметрыМетода)
	
	Приоритет = 1;
	
	Если Реакция.УсловиеРеакции = Неопределено Тогда
		Возврат Приоритет;
	КонецЕсли;
	
	Для Инд = 0 По Реакция.УсловиеРеакции.ВГраница() Цикл
		
		Если НЕ ПроверитьПараметр(ПараметрыМетода[Инд], Реакция.УсловиеРеакции[Инд]) Тогда
			
			Возврат -1;
			
		КонецЕсли;
		
		Приоритет = Приоритет + Реакция.УсловиеРеакции[Инд].Приоритет;
		
	КонецЦикла;
		
	Возврат Приоритет;
	
КонецФункции

#Область Настройки

Процедура ИнициализироватьНастройки() Экспорт
	
	ЮТКонтекстСлужебный.УстановитьЗначениеКонтекста(КлючНастроек(), НовыеНастройки(), Истина);
	
КонецПроцедуры

// Новые настройки.
// 
// Возвращаемое значение:
//  Структура - Настройки:
//  * Метод - Строка
//  * Реакция - Строка
//  * Перехват - Соответствие Из Произвольный
//  * ТипыПерехватываемыхОбъектов - Соответствие Из Тип
//  * Режим - Строка - см. РежимыРаботы
//  * Статистика - Структура - Статистика вызовов:
//  	* Вызовы - Соответствие из Структура
//  * ПараметрыОбучения - Структура
//  * ПараметрыПроверки - Структура
Функция НовыеНастройки()
	
	Настройки = Новый Структура;
	Настройки.Вставить("Метод");
	Настройки.Вставить("Реакция");
	Настройки.Вставить("Перехват", Новый Соответствие);
	Настройки.Вставить("ТипыПерехватываемыхОбъектов", Новый Соответствие);
	Настройки.Вставить("Режим", "НеУстановлен");
	Настройки.Вставить("Статистика", Новый Структура("Вызовы", Новый Соответствие));
	
	Настройки.Вставить("ПараметрыОбучения", Неопределено);
	Настройки.Вставить("ПараметрыПроверки", Неопределено);
	
	//@skip-check constructor-function-return-section
	Возврат Настройки;
	
КонецФункции

Процедура ОчиститьНастройки() Экспорт
	
	ЮТКонтекстСлужебный.УстановитьЗначениеКонтекста(КлючНастроек(), Неопределено);
	
КонецПроцедуры

Процедура СброситьПараметры() Экспорт
	
	ИнициализироватьНастройки();
	
КонецПроцедуры

Функция КлючНастроек()
	
	Возврат "Mockito";
	
КонецФункции

Процедура ОчиститьСлужебныеПараметры()
	
	Настройки = Настройки();
	
	Настройки.ПараметрыОбучения = Неопределено;
	Настройки.ПараметрыПроверки = Неопределено;
	
КонецПроцедуры

#КонецОбласти

Функция УсловиеИзПараметров(Параметры) Экспорт
	
	Если Параметры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Условия = Новый Массив;
	
	ТипыУсловий = ТипыУсловийПараметров();
	
	Для Каждого Параметр Из Параметры Цикл
		
		Если ЭтоМаскаПарамера(Параметр) Тогда
			
			Условия.Добавить(Параметр);
			
		ИначеЕсли ЮТПредикатыСлужебныйКлиентСервер.ЭтоПредикат(Параметр) Тогда
			
			Маска = ОписаниеМаскиПараметра(ТипыУсловий.Предикат, 90);
			Маска.Вставить("Предикат", ЮТПредикатыСлужебныйКлиентСервер.НаборПредикатов(Параметр));
			Условия.Добавить(Маска);
			
		Иначе
			
			Маска = ОписаниеМаскиПараметра(ТипыУсловий.Значение, 100);
			Маска.Вставить("Значение", Параметр);
			Условия.Добавить(Маска);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Условия;
	
КонецФункции

#Область Статистика

// Зарегистрировать вызов метода.
// 
// Параметры:
//  Настройки - см. ИнициализироватьНастройки
//  ПараметрыПерехвата - см. ДанныеПерехвата
//  СтруктураВызоваМетода - см. СтруктураВызоваМетода
Процедура ЗарегистрироватьВызовМетода(Настройки, ПараметрыПерехвата, СтруктураВызоваМетода)
	
	Объект = СтруктураВызоваМетода.Объект;
	ИмяМетода = СтруктураВызоваМетода.ИмяМетода;
	Статистика = Настройки.Статистика.Вызовы[Объект];
	
	Если Статистика = Неопределено Тогда
		
		Статистика = Новый Структура;
		Настройки.Статистика.Вызовы.Вставить(Объект, Статистика);
		
	КонецЕсли;
	
	Если НЕ Статистика.Свойство(ИмяМетода) Тогда
		
		Статистика.Вставить(ИмяМетода, Новый Массив);
		
	КонецЕсли;
	
	Статистика[ИмяМетода].Добавить(СтруктураВызоваМетода);
	
КонецПроцедуры

Функция СтатистикаВызововПоСсылке(Вызовы, Ссылка, ИмяМетода)
	
	СтатистикаВызововМетода = Новый Массив();
	ТипОбъекта = ЮТТипыДанныхСлужебный.ТипОбъектаСсылки(ТипЗнч(Ссылка));
	
	Для Каждого Элемент Из Вызовы Цикл
		ПодходящийЭлемент = ТипЗнч(Элемент.Ключ) = ТипОбъекта
							И Элемент.Ключ.Ссылка = Ссылка
							И Элемент.Значение.Свойство(ИмяМетода);
		Если ПодходящийЭлемент Тогда
			ЮТКоллекции.ДополнитьМассив(СтатистикаВызововМетода, Элемент.Значение[ИмяМетода]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтатистикаВызововМетода;
	
КонецФункции

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ТолстыйКлиентУправляемоеПриложение Тогда
Функция СтатистикаВызововПоМенеджеру(Вызовы, Менеджер, ИмяМетода)
	
	СтатистикаВызововМетода = Новый Массив();
	Описание = ЮТМетаданные.ОписаниеОбъектаМетаданных(Менеджер);
	
	Если Описание = Неопределено Тогда
		Возврат СтатистикаВызововМетода;
	КонецЕсли;
	
	Если Описание.ОписаниеТипа.Ссылочный Или Описание.ОписаниеТипа.ОбработкаОтчет Тогда
		ТипОбъекта = Тип(СтрШаблон("%1Объект.%2", Описание.ОписаниеТипа.Имя, Описание.Имя));
	ИначеЕсли Описание.ОписаниеТипа.Регистр Тогда
		ТипОбъекта = Тип(СтрШаблон("%1НаборЗаписей.%2", Описание.ОписаниеТипа.Имя, Описание.Имя));
	КонецЕсли;
	
	Для Каждого Элемент Из Вызовы Цикл
		ПодходящийЭлемент = ТипЗнч(Элемент.Ключ) = ТипОбъекта
							И Элемент.Значение.Свойство(ИмяМетода);
		Если ПодходящийЭлемент Тогда
			ЮТКоллекции.ДополнитьМассив(СтатистикаВызововМетода, Элемент.Значение[ИмяМетода]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтатистикаВызововМетода;
	
КонецФункции
#КонецЕсли

#КонецОбласти

#КонецОбласти
