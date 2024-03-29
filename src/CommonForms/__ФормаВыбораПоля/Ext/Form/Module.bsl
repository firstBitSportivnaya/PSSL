﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8, включая доработку типовых конфигураций.
//
// Copyright 2017-2024 First BIT company
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//
// URL:    https://github.com/firstBitSportivnaya/PSSL/
// e-mail: ivssmirnov@1bit.com
// Версия: 1.0.0.1
//
// Требования: платформа 1С версии 8.3.17 и выше

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Параметры.Свойство("Режим", Режим);
	
	Если Параметры.Свойство("Переменные") Тогда
		Для Каждого Имя Из Параметры.Переменные Цикл
			Переменные.Добавить(Имя);
		КонецЦикла;
	КонецЕсли; 
	
	ОписаниеСправочники = Справочники.ТипВсеСсылки();
	ОписаниеДокументы = Документы.ТипВсеСсылки();
	
	ОбновитьДерево();
	
	Если Не Поля.ПолучитьЭлементы().Количество() Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru='Нет полей для выбора.';en='No fields to select.'"),,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоля

&НаКлиенте
Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Результат = СформироватьРезСтруктуру(Элементы.Поля.ТекущаяСтрока);
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоляПередРазворачиванием(Элемент, Строка, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РазвернутьПодчиненные(Строка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекущаяСтрока = Элементы.Поля.ТекущаяСтрока;
	Результат = СформироватьРезСтруктуру(ТекущаяСтрока);
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ОбновитьДерево();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДерево()
	
	ДанныеДерева = Поля.ПолучитьЭлементы();
	ДанныеДерева.Очистить();
	
	Если Переменные.Количество() Тогда
		
		ЭлементВерх = ДанныеДерева.Добавить();
		ЗаполнитьЭлементДерева(ЭлементВерх, "Переменные",,,,, БиблиотекаКартинок.__Реквизиты);
		
		Коллекция = ЭлементВерх.ПолучитьЭлементы();
		
		Для Каждого ТекущаяПеременная Из Переменные Цикл
			ЗаполнитьЭлементДерева(Коллекция.Добавить(), ТекущаяПеременная.Значение,,, Истина, Истина);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементДерева(ЭлементДерева
								  , Имя
								  , Синоним = ""
								  , Описание = Неопределено
								  , Доступность = Ложь
								  , ДобавлятьПодчиненные = Ложь 
								  , Картинка = Неопределено)
	
	ЭлементДерева.Имя = Имя;
	ЭлементДерева.Синоним = ?(ПустаяСтрока(Синоним), Имя, Синоним);
	ЭлементДерева.Тип = ?(Описание = Неопределено, Новый ОписаниеТипов("Строка"), Описание);
	
	ЭлементДерева.Доступно = Доступность;
	
	Если ДобавлятьПодчиненные Тогда
		
		МассивТипов = ЭлементДерева.Тип.Типы();
		Для Каждого Тип Из МассивТипов Цикл
		
			Если ОписаниеСправочники.СодержитТип(Тип) Или ОписаниеДокументы.СодержитТип(Тип) Тогда
				
				Коллекция = ЭлементДерева.ПолучитьЭлементы();
				ЗаполнитьЭлементДерева(Коллекция.Добавить(), "СлужебнаяДляРазворота");
				
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Картинка = Неопределено Тогда
		ЭлементДерева.Картинка = Картинка;
	Иначе
		ЭлементДерева.Картинка = БиблиотекаКартинок.__Реквизит;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция СобратьИмена(СтрокаСтарт)

	Результат = "";
	Если СтрокаСтарт <> Неопределено Тогда
		
		Результат = СтрокаСтарт.Имя;
		
		СтрокаРодитель = СтрокаСтарт.ПолучитьРодителя();
		Если СтрокаРодитель <> Неопределено Тогда
			Результат = СобратьИмена(СтрокаРодитель) + "." + Результат;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

&НаСервере
Функция СформироватьРезСтруктуру(ИдСтроки)
	
	Результат = Неопределено;
	
	Если ТипЗнч(ИдСтроки) = Тип("Число") Тогда
		
		ТекущаяСтрока = Поля.НайтиПоИдентификатору(ИдСтроки);
		
		Если Не ТекущаяСтрока = Неопределено И ТекущаяСтрока.Доступно Тогда
			Результат = Новый Структура("Имя");
			Результат.Имя = СобратьИмена(ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура РазвернутьПодчиненные(ИдСтроки)

	СтрокаДерева = Поля.НайтиПоИдентификатору(ИдСтроки);
	Если СтрокаДерева = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьОписаниеРеквизитов(СтрокаДерева, "Справочники", ОписаниеСправочники, "СправочникСсылка");
	ДобавитьОписаниеРеквизитов(СтрокаДерева, "Документы", ОписаниеДокументы, "ДокументСсылка");

КонецПроцедуры

&НаСервере
Процедура ДобавитьОписаниеРеквизитов(СтрокаДерева,ИмяКоллекции,ОписаниеКоллекции,НачалоИмениТипа)
	
	Если Не ТипЗнч(СтрокаДерева) = Тип("ДанныеФормыЭлементДерева") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Тип Из СтрокаДерева.Тип.Типы() Цикл
		
		Если ОписаниеКоллекции.СодержитТип(Тип) Тогда
			
			Результат = __ОбщегоНазначенияСервер.ПолучитьИмяОбъектаПоОписаниюТипов(СтрокаДерева.Тип,ИмяКоллекции,НачалоИмениТипа);
			Если Результат <> Неопределено Тогда
				
				Коллекция = СтрокаДерева.ПолучитьЭлементы();
				
				Если Не Коллекция.Количество() = 1 Тогда
					Продолжить;
				КонецЕсли;
				
				ПерваяСтрока = Коллекция[0];
				
				Если ПерваяСтрока.Имя = "СлужебнаяДляРазворота" Тогда
					Коллекция.Очистить();
				Иначе
					Продолжить;
				КонецЕсли;
				
				Если ИмяКоллекции = "Справочники" Тогда
					
					ЭлементПодч = Коллекция.Добавить();
					ЗаполнитьЭлементДерева(ЭлементПодч, "Код");
					
					ЭлементПодч = Коллекция.Добавить();
					ЗаполнитьЭлементДерева(ЭлементПодч, "Наименование");
					
				ИначеЕсли ИмяКоллекции = "Документы" Тогда	
					
					ЭлементПодч = Коллекция.Добавить();
					ЗаполнитьЭлементДерева(ЭлементПодч, "Дата");
					
					ЭлементПодч = Коллекция.Добавить();
					ЗаполнитьЭлементДерева(ЭлементПодч, "Номер");
					
					ЭлементПодч = Коллекция.Добавить();
					ЗаполнитьЭлементДерева(ЭлементПодч, "Проведен");
					
				КонецЕсли;
				
				Для Каждого ТекущийОбъект Из Метаданные[ИмяКоллекции][Результат.Имя].Реквизиты Цикл
					
					ЗаполнитьЭлементДерева(Коллекция.Добавить(),
						ТекущийОбъект.Имя, ТекущийОбъект.Синоним, ТекущийОбъект.Тип, Истина, Истина);
				КонецЦикла;
				
				Прервать;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
