﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
// включая доработку типовых конфигураций.
//
// Copyright First BIT company
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
// URL:    https://github.com/firstBitSportivnaya/PSSL/
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Режим", Режим);
	
	Параметры.Свойство("ИмяПриемника", ИмяПриемника);
	
	ЗначенияЗаполнения = Неопределено;
	Если Параметры.Свойство("АдресЗначений") Тогда
		ЗначенияЗаполнения = ПолучитьИзВременногоХранилища(Параметры.АдресЗначений);
	КонецЕсли;
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗначенияЗаполнения = Параметры.ЗначенияЗаполнения;
	КонецЕсли;
	
	ЗаполнитьДерево(ЗначенияЗаполнения);
	
	ОписаниеСправочники = Справочники.ТипВсеСсылки();
	ОписаниеДокументы = Документы.ТипВсеСсылки();
	
	Если Не Поля.ПолучитьЭлементы().Количество() Тогда
		пбп_ОбщегоНазначенияСлужебный.СообщитьПользователю(НСтр("ru='Нет полей для выбора.';en='No fields to select.'"),,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПоля

&НаКлиенте
Процедура ПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = Элементы.Поля.ТекущиеДанные;
	Если ВыбраннаяСтрока.Доступно Тогда
		ВыбратьПолеИЗакрыть(ВыбраннаяСтрока.Имя);
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

&НаКлиенте
Процедура РазвернутьСтроки(Команда)
	
	пбп_СтандартныеПодсистемыСлужебныйКлиент.РазвернутьУзлыДерева(ЭтотОбъект, "Поля");
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьСтроки(Команда)
	
	ВсеСтроки = Элементы.Поля;
	Для Каждого ДанныеСтроки Из Поля.ПолучитьЭлементы() Цикл 
		ВсеСтроки.Свернуть(ДанныеСтроки.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыбраннаяСтрока = Элементы.Поля.ТекущиеДанные;
	Если ВыбраннаяСтрока.Доступно Тогда
		ВыбратьПолеИЗакрыть(ВыбраннаяСтрока.Имя);
	КонецЕсли;
	
	пбп_ОбщегоНазначенияСлужебныйКлиент.СообщитьПользователю(НСтр("ru = 'Выбрано недоступное поле!'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПолеИЗакрыть(ИмяПоля)
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("Поле", ИмяПоля);
	ПараметрыВыбора.Вставить("ИмяПриемника", ИмяПриемника);
	ОповеститьОВыборе(ПараметрыВыбора);
	
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
		ЭлементДерева.Картинка = БиблиотекаКартинок.пбп_Реквизит;
	КонецЕсли;

КонецПроцедуры

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
			
			Результат = пбп_ОбщегоНазначенияСервер.ПолучитьИмяОбъектаПоОписаниюТипов(СтрокаДерева.Тип,ИмяКоллекции,НачалоИмениТипа);
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

// Процедура заполняет дерево формы "Поля"
//
// Параметры:
//  ЗначенияЗаполнения - Структура - переданные значения
//   * Ключ - Строка - Имя класса (переменные, параметры и т.д.)
//   * Значение - Массив из Строка - Имена выбираемых полей.
//
&НаСервере
Процедура ЗаполнитьДерево(ЗначенияЗаполнения = Неопределено)
	
	Если ЗначенияЗаполнения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеДерева = Поля.ПолучитьЭлементы();
	Для Каждого Пара Из ЗначенияЗаполнения Цикл
		ЭлементВерх = ДанныеДерева.Добавить();
		ЗаполнитьЭлементДерева(ЭлементВерх, Пара.Ключ,,,,, БиблиотекаКартинок.пбп_Реквизиты);
		
		Коллекция = ЭлементВерх.ПолучитьЭлементы();
		
		Для Каждого ТекущаяПеременная Из Пара.Значение Цикл
			ЗаполнитьЭлементДерева(Коллекция.Добавить(), ТекущаяПеременная,,, Истина, Истина);
		КонецЦикла;
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти
