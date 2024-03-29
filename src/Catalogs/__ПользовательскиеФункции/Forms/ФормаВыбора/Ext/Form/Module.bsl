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
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ПоказатьОписаниеФункции", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует описание функции или группы функций.
// 
// Параметры:
// 	Ссылка - СправочникСсылка.__ПользовательскиеФункции.
// 
&НаСервере
Процедура ПоказатьОписаниеФункцииСервер(Ссылка)
	
	Если Ссылка.ЭтоГруппа Тогда
		
		ТекстОписания = СтрШаблон(НСтр("ru='#В группе: %1';en='#In Group: %1'"), Символы.ПС);
		
		Выборка = Справочники.__ПользовательскиеФункции.Выбрать(Ссылка);
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.ЭтоГруппа Тогда
				Продолжить;
			КонецЕсли;
			
			ОписаниеСКомментариями = СтрЗаменить(СокрЛП(Выборка.Описание), Символы.ПС, СтрШаблон("%1// ", Символы.ПС));
			Если СокрЛП(Выборка.Описание) = "" Тогда
				ОписаниеФункции = НСтр("ru='// <нет описания>';en='// <No description>'");
			Иначе	
				ОписаниеФункции = СтрШаблон("// %1", ОписаниеСКомментариями);
			КонецЕсли;
			
			__ОбщегоНазначенияСервер.ДобавитьСтрокуКТексту(ТекстОписания, ОписаниеФункции);
			СтруктураЗаголовка = Справочники.__ПользовательскиеФункции.ПолучитьНазваниеПодпрограммыСПараметрами(Выборка.Ссылка);
			__ОбщегоНазначенияСервер.ДобавитьСтрокуКТексту(ТекстОписания, СтруктураЗаголовка.ЗаголовокФункции + Символы.ПС);
		КонецЦикла;
		
		ПолеОписания = ТекстОписания;
	Иначе
		СтруктураЗаголовка = Справочники.__ПользовательскиеФункции.ПолучитьНазваниеПодпрограммыСПараметрами(Ссылка);
		
		Элементы.ДекорацияНазваниеСПараметрами.Заголовок = СтруктураЗаголовка.НазваниеСПараметрами;
		ПолеОписания = СтрШаблон("%1%2%3", СтруктураЗаголовка.ОписаниеПараметров, Символы.ПС, СокрЛП(Ссылка.КодПодпрограммы));
	КонецЕсли;
	
	Элементы.Описание.Видимость = Не Ссылка.ЭтоГруппа;
	Элементы.ГруппаШапкаФункции.Видимость = Не Ссылка.ЭтоГруппа;
	Элементы.ГруппаПодвалФункции.Видимость = Не Ссылка.ЭтоГруппа;
	
КонецПроцедуры

// Обработчик ожидания активизации строки.
// 
&НаКлиенте
Процедура ПоказатьОписаниеФункции()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьОписаниеФункцииСервер(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

