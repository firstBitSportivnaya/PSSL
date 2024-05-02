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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает массив структур соответствий по отбору.
//
// Параметры:
//  ТипСоответствия - СправочникСсылка.__ТипСоответствияОбъектовИБ - Тип соответствия.
//  Объект1 - ПроизвольныйТип - Объект1.
//  Объект2 - ПроизвольныйТип - Объект2.
//  Объект3 - ПроизвольныйТип - Объект3.
// 
// Возвращаемое значение:
//  - Массив - соответствие объектов ИБ в виде структур.
// 
Функция ПолучитьСоответствиеОбъектовИБ(ИдентификаторНастройки, Объект1 = Неопределено, Объект2 = Неопределено, Объект3 = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	СоответствияОбъектовИБ.ТипСоответствия КАК ТипСоответствия,
	               |	СоответствияОбъектовИБ.Объект1 КАК Объект1,
	               |	СоответствияОбъектовИБ.Объект2 КАК Объект2,
	               |	СоответствияОбъектовИБ.Объект3 КАК Объект3
	               |ИЗ
	               |	Справочник.__ТипСоответствияОбъектовИБ КАК __ТипСоответствияОбъектовИБ
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.__СоответствияОбъектовИБ КАК СоответствияОбъектовИБ
	               |		ПО (__ТипСоответствияОбъектовИБ.ИдентификаторНастройки = &ИдентификаторНастройки)
	               |			И __ТипСоответствияОбъектовИБ.Ссылка = СоответствияОбъектовИБ.ТипСоответствия";
	
	Схема = Новый СхемаЗапроса();
	Схема.УстановитьТекстЗапроса(ТекстЗапроса);
	ОператорВыбрать = Схема.ПакетЗапросов[0].Операторы[0];
	
	Если ЗначениеЗаполнено(Объект1) Тогда
		
		ОператорВыбрать.Отбор.Добавить("СоответствияОбъектовИБ.Объект1 = &Объект1");
		Запрос.УстановитьПараметр("Объект1", Объект1);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект2) Тогда
		
		ОператорВыбрать.Отбор.Добавить("СоответствияОбъектовИБ.Объект2 = &Объект2");
		Запрос.УстановитьПараметр("Объект2", Объект2);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Объект3) Тогда
		
		ОператорВыбрать.Отбор.Добавить("СоответствияОбъектовИБ.Объект3 = &Объект3");
		Запрос.УстановитьПараметр("Объект3", Объект3);
		
	КонецЕсли;
	
	Запрос.Текст = Схема.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("ИдентификаторНастройки", ИдентификаторНастройки);
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	
	Массив = Новый Массив();
	СтруктураСтрокой = "ТипСоответствия, Объект1, Объект2, Объект3";
	
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Новый Структура(СтруктураСтрокой);
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Массив.Добавить(НоваяСтрока);
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

// Возвращает массив значений произвольного типа, объекта соответствия.
//
// Параметры:
//  ТипСоответствия	 - СправочникСсылка.__ТипСоответствияОбъектовИБ - Тип соответствия.
//  ИмяКлюча		 - Строка - поле регистра сведений __СоответствияОбъектовИБ, по которому устанавливается отбор. 
//  ЗначениеКлюча	 - ПроизвольныйТип - Значение ключа по которому установлен отбор.
//  ИмяОбъекта		 - Строка - получаемое поле регистра сведений __СоответствияОбъектовИБ. 
// 
// Возвращаемое значение:
//   - Массив - Значения объекта из регистра сведений __СоответствияОбъектовИБ, 
//				если соответствие одно в массив будет один элемент 
// 
Функция ПолучитьЗначенияОбъектаСоответствияПоКлючу(ИдентификаторНастройки, ИмяКлюча, ЗначениеКлюча, ИмяОбъекта) Экспорт
	
	МетаданныеРегистра = Метаданные.РегистрыСведений.__СоответствияОбъектовИБ;
	
	КлючСуществует = МетаданныеРегистра.Измерения.Найти(ИмяКлюча) <> Неопределено;
	Если Не КлючСуществует Тогда
		КлючСуществует = МетаданныеРегистра.Ресурсы.Найти(ИмяКлюча) <> Неопределено;
	КонецЕсли;
	
	ОбъектСуществует = МетаданныеРегистра.Измерения.Найти(ИмяОбъекта) <> Неопределено; 
	Если Не ОбъектСуществует Тогда
		ОбъектСуществует = МетаданныеРегистра.Ресурсы.Найти(ИмяОбъекта) <> Неопределено;
	КонецЕсли;
		
	Если Не КлючСуществует Или Не ОбъектСуществует Тогда
		Шаблон = НСтр("ru = 'В регистре сведений __СоответствияОбъектовИБ не существует " +
			?(КлючСуществует, "", "ключа %1") +
			?(ОбъектСуществует, "", ?(КлючСуществует, "", "; ") + "объект %2") + "'");
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			Шаблон,
			ИмяКлюча,
			ИмяОбъекта);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	СоответствияОбъектовИБ.%1 КАК Объект
		|ИЗ
		|	Справочник.__ТипСоответствияОбъектовИБ КАК __ТипСоответствияОбъектовИБ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.__СоответствияОбъектовИБ КАК СоответствияОбъектовИБ
		|		ПО (__ТипСоответствияОбъектовИБ.ИдентификаторНастройки = &ИдентификаторНастройки)
		|			И __ТипСоответствияОбъектовИБ.Ссылка = СоответствияОбъектовИБ.ТипСоответствия
		|ГДЕ
		|	СоответствияОбъектовИБ.%2 = &Ключ";
	
	Запрос.Текст = СтрШаблон(ТекстЗапроса, ИмяОбъекта, ИмяКлюча);
	
	Запрос.УстановитьПараметр("Ключ", ЗначениеКлюча);
	Запрос.УстановитьПараметр("ИдентификаторНастройки", ИдентификаторНастройки);
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаОбъектов = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ТаблицаОбъектов.ВыгрузитьКолонку("Объект");
	
КонецФункции

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли