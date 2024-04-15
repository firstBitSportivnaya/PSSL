﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
// включая доработку типовых конфигураций.
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

////////////////////////////////////////////////////////////////////////////////
// Общего назначения (служебный): для серверных функций общего назначения, аналогов методов БСП

#Область ПрограммныйИнтерфейс

// Выполнить экспортную процедуру по имени.
//
// Параметры:
//  ИмяМетода  - Строка - имя экспортной процедуры в формате
//                       <имя объекта>.<имя процедуры>, где <имя объекта> - это
//                       общий модуль или модуль менеджера объекта.
//  Параметры  - Массив - параметры передаются в процедуру <ИмяЭкспортнойПроцедуры>
//                        в порядке расположения элементов массива.
// 
// Пример:
//  Параметры = Новый Массив();
//  Параметры.Добавить("1");
//  ОбщегоНазначения.ВыполнитьМетодКонфигурации("МойОбщийМодуль.МояПроцедура", Параметры);
//
Процедура ВыполнитьМетодКонфигурации(Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	ПроверитьИмяПроцедурыКонфигурации(ИмяМетода);
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + XMLСтрока(Индекс) + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

#Область УсловныеВызовы

// Аналог метода БСП. Возвращает ссылку на общий модуль или модуль менеджера по имени.
//
// Параметры:
//  Имя - Строка - имя общего модуля.
//
// Возвращаемое значение:
//   ОбщийМодуль
//   МодульМенеджераОбъекта
//
// Пример:
//	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОбновлениеКонфигурации") Тогда
//		МодульОбновлениеКонфигурации = ОбщегоНазначения.ОбщийМодуль("ОбновлениеКонфигурации");
//		МодульОбновлениеКонфигурации.<Имя метода>();
//	КонецЕсли;
//
//	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолнотекстовыйПоиск") Тогда
//		МодульПолнотекстовыйПоискСервер = ОбщегоНазначения.ОбщийМодуль("ПолнотекстовыйПоискСервер");
//		МодульПолнотекстовыйПоискСервер.<Имя метода>();
//	КонецЕсли;
//
Функция ОбщийМодуль(Имя) Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти(Имя) <> Неопределено Тогда
		УстановитьБезопасныйРежим(Истина);
		Модуль = Вычислить(Имя);
	ИначеЕсли СтрЧислоВхождений(Имя, ".") = 1 Тогда
		Возврат СерверныйМодульМенеджера(Имя);
	Иначе
		Модуль = Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не существует.'"),
			Имя);
	КонецЕсли;
	
	Возврат Модуль;
	
КонецФункции

#КонецОбласти

#Область ПереадресацияМетодов

// См. __ОбщегоНазначенияСервер.ЗаписатьДанныеВБезопасноеХранилище.
Процедура ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ = "Пароль") Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ);
	
КонецПроцедуры

// См. __ОбщегоНазначенияСервер.ПрочитатьДанныеИзБезопасногоХранилища.
Функция ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи = "Пароль", ОбщиеДанные = Неопределено) Экспорт

	Модуль = ПолучитьМодуль();
	Возврат Модуль.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи, ОбщиеДанные);
	
КонецФункции

// См. __ОбщегоНазначенияСервер.СообщитьПользователю.
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач КлючДанных = Неопределено, Знач Поле = "",
	Знач ПутьКДанным = "", Отказ = Ложь) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.СообщитьПользователю(ТекстСообщенияПользователю, КлючДанных, Поле, ПутьКДанным, Отказ);
	
КонецПроцедуры

// См. __ОбщегоНазначенияСервер.ХранилищеОбщихНастроекСохранить.
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек,
		ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// См. __ОбщегоНазначенияСервер.ХранилищеОбщихНастроекЗагрузить.
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
			ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию, 
		ОписаниеНастроек, ИмяПользователя);
	
КонецФункции

// См. __ОбщегоНазначенияСервер.ПриНачалеВыполненияРегламентногоЗадания.
Процедура ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание);
	
КонецПроцедуры

// См. __ОбщегоНазначенияСервер.ЗначенияРеквизитовОбъекта.
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь, Знач КодЯзыка = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные, КодЯзыка);
	
КонецФункции

// См. __ОбщегоНазначенияСервер.ОписаниеТипаСтрока.
Функция ОписаниеТипаСтрока(ДлинаСтроки) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ОписаниеТипаСтрока(ДлинаСтроки);
	
КонецФункции

// См. __ОбщегоНазначенияСервер.ОписаниеТипаЧисло.
Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, Знач ЗнакЧисла = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область БезопасноеВыполнениеВнешнегоКода

// Аналог метода БСП. Проверяет, что переданное имя ИмяПроцедуры является именем экспортной процедуры конфигурации.
// Может использоваться для проверки, что переданная строка не содержит произвольного алгоритма
// на встроенном языке 1С:Предприятия перед использованием его в операторах Выполнить и Вычислить
// при их использовании для динамического вызова методов код конфигурации.
//
// В случае если переданная строка не является именем процедуры конфигурации, генерируется исключение.
//
// Предназначена для вызова из см. процедуру ВыполнитьМетодКонфигурации.
//
// Параметры:
//   ИмяПроцедуры - Строка - проверяемое имя экспортной процедуры.
//
Процедура ПроверитьИмяПроцедурыКонфигурации(Знач ИмяПроцедуры)
	
	ЧастиИмени = СтрРазделить(ИмяПроцедуры, ".");
	Если ЧастиИмени.Количество() <> 2 И ЧастиИмени.Количество() <> 3 Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра %1 (передано значение: ""%2"") в %3.'"), 
			"ИмяПроцедуры", ИмяПроцедуры, "ОбщегоНазначения.ВыполнитьМетодКонфигурации");
	КонецЕсли;
	
	ИмяОбъекта = ЧастиИмени[0];
	Если ЧастиИмени.Количество() = 2 И Метаданные.ОбщиеМодули.Найти("__"+ИмяОбъекта+"Служебный") = Неопределено Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра %1 (передано значение: ""%2"") в %3:
				|Не существует общий модуль ""%4"".'"),
			"ИмяПроцедуры", ИмяПроцедуры, "ОбщегоНазначения.ВыполнитьМетодКонфигурации", ИмяОбъекта);
	КонецЕсли;
	
	Если ЧастиИмени.Количество() = 3 Тогда
		ПолноеИмяОбъекта = ЧастиИмени[0] + "." + ЧастиИмени[1];
		Попытка
			Менеджер = МенеджерОбъектаПоИмени(ПолноеИмяОбъекта);
		Исключение
			Менеджер = Неопределено;
		КонецПопытки;
		Если Менеджер = Неопределено Тогда
			ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Неправильный формат параметра %1 (передано значение: ""%2"") в %3:
				           |Не существует менеджер объекта ""%4"".'"),
				"ИмяПроцедуры", ИмяПроцедуры, "ОбщегоНазначения.ВыполнитьМетодКонфигурации", ПолноеИмяОбъекта);
		КонецЕсли;
	КонецЕсли;
	
	ИмяМетодаОбъекта = ЧастиИмени[ЧастиИмени.ВГраница()];
	ВременнаяСтруктура = Новый Структура;
	Попытка
		// Проверка того, что ИмяПроцедуры является допустимым идентификатором.
		// Например: МояПроцедура.
		ВременнаяСтруктура.Вставить(ИмяМетодаОбъекта);
	Исключение
		КодОсновногоЯзыка = Метаданные.ОсновнойЯзык.КодЯзыка;
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Безопасное выполнение метода'", КодОсновногоЯзыка),
			УровеньЖурналаРегистрации.Ошибка, , , ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неправильный формат параметра %1 (передано значение: ""%2"") в %3:
			           |Имя метода ""%4"" не соответствует требованиям образования имен процедур и функций.'"),
			"ИмяПроцедуры", ИмяПроцедуры, "ОбщегоНазначения.ВыполнитьМетодКонфигурации", ИмяМетодаОбъекта);
	КонецПопытки;
	
КонецПроцедуры

// Аналог метода БСП. Возвращает менеджер объекта по имени.
// Ограничение: не обрабатываются точки маршрутов бизнес-процессов.
//
// Параметры:
//  Имя - Строка - имя например, "Справочник", "Справочники", "Справочник.Организации".
//
// Возвращаемое значение:
//  СправочникиМенеджер
//  СправочникМенеджер
//  ДокументыМенеджер
//  ДокументМенеджер
//  ...
//
Функция МенеджерОбъектаПоИмени(Имя)
	Перем КлассОМ, ИмяОМ, Менеджер;
	
	ЧастиИмени = СтрРазделить(Имя, ".");
	
	Если ЧастиИмени.Количество() > 0 Тогда
		КлассОМ = ВРег(ЧастиИмени[0]);
	КонецЕсли;
	
	Если ЧастиИмени.Количество() > 1 Тогда
		ИмяОМ = ЧастиИмени[1];
	КонецЕсли;
	
	Если      КлассОМ = "ПЛАНОБМЕНА"
	 Или      КлассОМ = "ПЛАНЫОБМЕНА" Тогда
		Менеджер = ПланыОбмена;
		
	ИначеЕсли КлассОМ = "СПРАВОЧНИК"
	      Или КлассОМ = "СПРАВОЧНИКИ" Тогда
		Менеджер = Справочники;
		
	ИначеЕсли КлассОМ = "ДОКУМЕНТ"
	      Или КлассОМ = "ДОКУМЕНТЫ" Тогда
		Менеджер = Документы;
		
	ИначеЕсли КлассОМ = "ЖУРНАЛДОКУМЕНТОВ"
	      Или КлассОМ = "ЖУРНАЛЫДОКУМЕНТОВ" Тогда
		Менеджер = ЖурналыДокументов;
		
	ИначеЕсли КлассОМ = "ПЕРЕЧИСЛЕНИЕ"
	      Или КлассОМ = "ПЕРЕЧИСЛЕНИЯ" Тогда
		Менеджер = Перечисления;
		
	ИначеЕсли КлассОМ = "ОБЩИЙМОДУЛЬ"
	      Или КлассОМ = "ОБЩИЕМОДУЛИ" Тогда
		
		Возврат ОбщийМодуль(ИмяОМ);
		
	ИначеЕсли КлассОМ = "ОТЧЕТ"
	      Или КлассОМ = "ОТЧЕТЫ" Тогда
		Менеджер = Отчеты;
		
	ИначеЕсли КлассОМ = "ОБРАБОТКА"
	      Или КлассОМ = "ОБРАБОТКИ" Тогда
		Менеджер = Обработки;
		
	ИначеЕсли КлассОМ = "ПЛАНВИДОВХАРАКТЕРИСТИК"
	      Или КлассОМ = "ПЛАНЫВИДОВХАРАКТЕРИСТИК" Тогда
		Менеджер = ПланыВидовХарактеристик;
		
	ИначеЕсли КлассОМ = "ПЛАНСЧЕТОВ"
	      Или КлассОМ = "ПЛАНЫСЧЕТОВ" Тогда
		Менеджер = ПланыСчетов;
		
	ИначеЕсли КлассОМ = "ПЛАНВИДОВРАСЧЕТА"
	      Или КлассОМ = "ПЛАНЫВИДОВРАСЧЕТА" Тогда
		Менеджер = ПланыВидовРасчета;
		
	ИначеЕсли КлассОМ = "РЕГИСТРСВЕДЕНИЙ"
	      Или КлассОМ = "РЕГИСТРЫСВЕДЕНИЙ" Тогда
		Менеджер = РегистрыСведений;
		
	ИначеЕсли КлассОМ = "РЕГИСТРНАКОПЛЕНИЯ"
	      Или КлассОМ = "РЕГИСТРЫНАКОПЛЕНИЯ" Тогда
		Менеджер = РегистрыНакопления;
		
	ИначеЕсли КлассОМ = "РЕГИСТРБУХГАЛТЕРИИ"
	      Или КлассОМ = "РЕГИСТРЫБУХГАЛТЕРИИ" Тогда
		Менеджер = РегистрыБухгалтерии;
		
	ИначеЕсли КлассОМ = "РЕГИСТРРАСЧЕТА"
	      Или КлассОМ = "РЕГИСТРЫРАСЧЕТА" Тогда
		
		Если ЧастиИмени.Количество() < 3 Тогда
			// Регистр расчета
			Менеджер = РегистрыРасчета;
		Иначе
			КлассПодчиненногоОМ = ВРег(ЧастиИмени[2]);
			Если ЧастиИмени.Количество() > 3 Тогда
				ИмяПодчиненногоОМ = ЧастиИмени[3];
			КонецЕсли;
			Если КлассПодчиненногоОМ = "ПЕРЕРАСЧЕТ"
			 Или КлассПодчиненногоОМ = "ПЕРЕРАСЧЕТЫ" Тогда
				// Перерасчет
				Попытка
					Менеджер = РегистрыРасчета[ИмяОМ].Перерасчеты;
					ИмяОМ = ИмяПодчиненногоОМ;
				Исключение
					Менеджер = Неопределено;
				КонецПопытки;
			КонецЕсли;
		КонецЕсли;
		
	ИначеЕсли КлассОМ = "БИЗНЕСПРОЦЕСС"
	      Или КлассОМ = "БИЗНЕСПРОЦЕССЫ" Тогда
		Менеджер = БизнесПроцессы;
		
	ИначеЕсли КлассОМ = "ЗАДАЧА"
	      Или КлассОМ = "ЗАДАЧИ" Тогда
		Менеджер = Задачи;
		
	ИначеЕсли КлассОМ = "КОНСТАНТА"
	      Или КлассОМ = "КОНСТАНТЫ" Тогда
		Менеджер = Константы;
		
	ИначеЕсли КлассОМ = "ПОСЛЕДОВАТЕЛЬНОСТЬ"
	      Или КлассОМ = "ПОСЛЕДОВАТЕЛЬНОСТИ" Тогда
		Менеджер = Последовательности;
	КонецЕсли;
	
	Если Менеджер <> Неопределено Тогда
		Если ЗначениеЗаполнено(ИмяОМ) Тогда
			Попытка
				Возврат Менеджер[ИмяОМ];
			Исключение
				Менеджер = Неопределено;
			КонецПопытки;
		Иначе
			Возврат Менеджер;
		КонецЕсли;
	КонецЕсли;
	
	ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось получить менеджер для объекта ""%1""'"), Имя);
	
КонецФункции

#КонецОбласти

#Область УсловныеВызовы

// Аналог метода БСП. Возвращает серверный модуль менеджера по имени объекта.
Функция СерверныйМодульМенеджера(Имя)
	ОбъектНайден = Ложь;
	
	ЧастиИмени = СтрРазделить(Имя, ".");
	Если ЧастиИмени.Количество() = 2 Тогда
		
		ИмяВида = ВРег(ЧастиИмени[0]);
		ИмяОбъекта = ЧастиИмени[1];
		
		Если ИмяВида = ВРег("Константы") Тогда
			Если Метаданные.Константы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("РегистрыСведений") Тогда
			Если Метаданные.РегистрыСведений.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("РегистрыНакопления") Тогда
			Если Метаданные.РегистрыНакопления.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("РегистрыБухгалтерии") Тогда
			Если Метаданные.РегистрыБухгалтерии.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("РегистрыРасчета") Тогда
			Если Метаданные.РегистрыРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("Справочники") Тогда
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("Документы") Тогда
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("Отчеты") Тогда
			Если Метаданные.Отчеты.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("Обработки") Тогда
			Если Метаданные.Обработки.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("БизнесПроцессы") Тогда
			Если Метаданные.БизнесПроцессы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("ЖурналыДокументов") Тогда
			Если Метаданные.ЖурналыДокументов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("Задачи") Тогда
			Если Метаданные.Задачи.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("ПланыСчетов") Тогда
			Если Метаданные.ПланыСчетов.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("ПланыОбмена") Тогда
			Если Метаданные.ПланыОбмена.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("ПланыВидовХарактеристик") Тогда
			Если Метаданные.ПланыВидовХарактеристик.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		ИначеЕсли ИмяВида = ВРег("ПланыВидовРасчета") Тогда
			Если Метаданные.ПланыВидовРасчета.Найти(ИмяОбъекта) <> Неопределено Тогда
				ОбъектНайден = Истина;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ОбъектНайден Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Объект метаданных ""%1"" не существует.'"), Имя);
	КонецЕсли;
	
	// АПК:488-выкл ВычислитьВБезопасномРежиме не используется, чтобы избежать вызова ОбщийМодуль рекурсивно.
	УстановитьБезопасныйРежим(Истина);
	Модуль = Вычислить(Имя);
	// АПК:488-вкл
	
	Возврат Модуль;
КонецФункции

#КонецОбласти

Функция ПолучитьМодуль()
	Возврат __ОбщегоНазначенияПовтИсп.ПолучитьОбщийМодуль("ОбщегоНазначения", "__ОбщегоНазначенияСервер");
КонецФункции

#КонецОбласти
