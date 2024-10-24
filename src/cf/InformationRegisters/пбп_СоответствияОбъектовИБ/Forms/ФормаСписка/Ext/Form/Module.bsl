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
	
	Если ТипЗнч(Параметры.Отбор) = Тип("Структура")
		И Параметры.Отбор.Свойство("Объект1") Тогда
		// форма открывается из Объекта 1
		
		Элементы.ТипСоответствия.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийФормы

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипСоответствияПриИзменении(Элемент)
	
	ТипСоответствияПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти //ОбработчикиСобытийЭлементовШапкиФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ТипСоответствияПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(ТипСоответствия) Тогда
		пбп_ОбщегоНазначенияСервер.ИзменитьЭлементОтбораСписка(Список, "ТипСоответствия", ТипСоответствия, Истина);
	Иначе
		пбп_ОбщегоНазначенияСервер.УдалитьЭлементОтбораСписка(Список, "ТипСоответствия");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти //СлужебныеПроцедурыИФункции
