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

#Область ОписаниеПеременных

&НаКлиенте
Перем ДокументВнешнийОбъектИсходящий, ДокументВнешнийОбъектВходящий;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтоЗагрузка = Объект.Статус = Перечисления.__СтатусыИнтеграции.Загружено
		ИЛИ Объект.Статус = Перечисления.__СтатусыИнтеграции.ОшибкаЗагрузки;
	Элементы.ГруппаОбъектыОбмена.Заголовок = ?(ЭтоЗагрузка, "Загруженные объекты", "Выгруженные объекты");
	
	Если НЕ Объект.Ошибка Тогда
		Элементы.ГруппаТекстОшибки.Видимость = Ложь;
		Элементы.Ошибка.Видимость = Ложь;
	КонецЕсли;
	
	Если Объект.ФорматЗапросаИнтеграции <> Перечисления.__ФорматыЗапросовИнтеграции.ПроизвольныйФормат Тогда
		Элементы.ГруппаФорматированиеТекстаЗапроса.Видимость = Истина;
		Элементы.ВидОтображенияЗапроса.Видимость = Объект.ФорматЗапросаИнтеграции = Перечисления.__ФорматыЗапросовИнтеграции.JSON;
		Элементы.ЗапросИсходящий.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ЗапросВходящий.Вид = ВидПоляФормы.ПолеHTMLДокумента;
		Элементы.ЗапросИсходящий.УстановитьДействие("ДокументСформирован", "ЗапросИсходящийДокументСформирован_Подключаемый");
		Элементы.ЗапросВходящий.УстановитьДействие("ДокументСформирован", "ЗапросВходящийДокументСформирован_Подключаемый");
	Иначе
		Элементы.ГруппаФорматированиеТекстаЗапроса.Видимость = Ложь;
		Если ЗначениеЗаполнено(Объект.ЗапросВходящий) Тогда
			ЗапросВходящийОтформатированный = ОтформатироватьСообщениеИнтеграции(Объект.ЗапросВходящий);
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ЗапросИсходящий) Тогда
			ЗапросИсходящийОтформатированный = ОтформатироватьСообщениеИнтеграции(Объект.ЗапросИсходящий);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого Строка Из Объект.ОбъектыИнтеграции Цикл
		Строка.ЗагруженныйОбъектТипЗначения = ТипЗнч(Строка.ОбъектИнтеграции);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиент = __ВспомогательныйМодульНеПереноситьКлиент;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если ЗначениеЗаполнено(Объект.ФорматЗапросаИнтеграции) И Объект.ФорматЗапросаИнтеграции <> ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.__ФорматыЗапросовИнтеграции.ПроизвольныйФормат") Тогда
		ИнициализироватьБазовыйФайлРедактора(ПолучитьФорматИнтеграции(Объект.ФорматЗапросаИнтеграции));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОтображенияЗапросаПриИзменении(Элемент)
	
	Если ВидОтображенияЗапроса Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("tree");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросИсходящийДокументСформирован_Подключаемый(Элемент)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиент = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Объект.ФорматЗапросаИнтеграции = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.__ФорматыЗапросовИнтеграции.JSON") Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code", "Исходящий");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектXML("Исходящий");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапросВходящийДокументСформирован_Подключаемый(Элемент)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиент = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Объект.ФорматЗапросаИнтеграции = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.__ФорматыЗапросовИнтеграции.JSON") Тогда
		ИнициализироватьИЗаполнитьТекстомОбъектJSON("code", "Входящий");
	Иначе
		ИнициализироватьИЗаполнитьТекстомОбъектXML("Входящий");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазвернутьВсе(Команда)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиент = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Объект.ФорматЗапросаИнтеграции = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.__ФорматыЗапросовИнтеграции.XML") Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", true);
		Элементы.ЗапросВходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", true);
	Иначе
		Если ВидОтображенияЗапроса Тогда
			ДокументВнешнийОбъектИсходящий.expandAll();
			ДокументВнешнийОбъектВходящий.expandAll();
		Иначе
			ДокументВнешнийОбъектИсходящий.format();
			ДокументВнешнийОбъектВходящий.format();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьВсе(Команда)
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиент = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Если Объект.ФорматЗапросаИнтеграции = ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Перечисление.__ФорматыЗапросовИнтеграции.XML") Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", false);
		Элементы.ЗапросВходящий.Документ.defaultView.Xonomy.plusminus("xonomy1", false);
	Иначе
		Если ВидОтображенияЗапроса Тогда
			ДокументВнешнийОбъектИсходящий.collapseAll();
			ДокументВнешнийОбъектВходящий.collapseAll();
		Иначе
			ДокументВнешнийОбъектИсходящий.compact();
			ДокументВнешнийОбъектВходящий.compact();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КопироватьВБуферОбмена(Команда)
	
	#Если НЕ ВебКлиент Тогда
		СистемнаяИнформация = Новый СистемнаяИнформация();
		Если НЕ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86 Или ТипПлатформы.Linux_x86_64 Тогда
			ОбъектКопирования = Новый COMОбъект("htmlfile");
			Если Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаЗапросВходящий" Тогда
				ПолеКопирования = Объект.ЗапросВходящий;
			ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя = "ГруппаЗапросИсходящий" Тогда
				ПолеКопирования = Объект.ЗапросИсходящий;
			Иначе
				Возврат;
			КонецЕсли;
			ОбъектКопирования.ParentWindow.ClipboardData.SetData("Text", ПолеКопирования);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ОтформатироватьСообщениеИнтеграции(ТекстСообщенияИнтеграции)
	
	Если Объект.ФорматЗапросаИнтеграции = Перечисления.__ФорматыЗапросовИнтеграции.XML И СтрНайти(ТекстСообщенияИнтеграции, "xml") <> 0 Тогда
		Запрос = __ИнтеграцииСервер.ОтформатироватьXMLЧерезDOM(ТекстСообщенияИнтеграции, Истина);
	Иначе
		Запрос = ТекстСообщенияИнтеграции;
	КонецЕсли;
	
	Возврат Запрос;
	
КонецФункции

&НаКлиенте
Процедура ИнициализироватьБазовыйФайлРедактора(ФорматИнтеграции)
	
	#Если ВебКлиент Тогда
		ВызватьИсключение НСтр("ru = 'Редактор " + ФорматИнтеграции + " не предназначен для веб-клиента'");
	#Иначе
		Если ФорматИнтеграции = "JSON" Тогда
			ЗапросИсходящийОтформатированный	= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции);
			ЗапросВходящийОтформатированный		= ЗапросИсходящийОтформатированный;
		Иначе
			ЗапросИсходящийОтформатированный	= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, "Out");
			ЗапросВходящийОтформатированный		= ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, "In");
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьБазовыйФайлРедактора(ФорматИнтеграции, Дополнение = "")
	
	#Если НЕ ВебКлиент Тогда
		КаталогКомпоненты = КаталогВременныхФайлов() + ФорматИнтеграции + "Editor" + Дополнение;
		КаталогНаДиске = Новый Файл(КаталогКомпоненты);
		ДвоичныеДанные = ДвоичныеДанныеМакета(ФорматИнтеграции);
		
		Чтение = Новый ЧтениеДанных(ДвоичныеДанные);
		Файл = Новый ЧтениеZipФайла(Чтение.ИсходныйПоток());
		Файл.ИзвлечьВсе(КаталогКомпоненты);
		
		БазовыйФайлРедактора = КаталогКомпоненты + ПолучитьРазделительПути() + "index.html";
			
		Возврат БазовыйФайлРедактора;
	#КонецЕсли
	
КонецФункции

&НаКлиенте
Процедура ИнициализироватьИЗаполнитьТекстомОбъектJSON(ВидОтображения, ТипЗапроса = "")
	
	Если ТипЗапроса = "Исходящий" Тогда
		Если ДокументВнешнийОбъектИсходящий <> Неопределено Тогда
			ДокументВнешнийОбъектИсходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектИсходящий = Элементы.ЗапросИсходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектИсходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектИсходящий.setText(Объект.ЗапросИсходящий);
	
	ИначеЕсли ТипЗапроса = "Входящий" Тогда
		Если ДокументВнешнийОбъектВходящий <> Неопределено Тогда
			ДокументВнешнийОбъектВходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектВходящий = Элементы.ЗапросВходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектВходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектВходящий.setText(Объект.ЗапросВходящий);
	Иначе
		Если ДокументВнешнийОбъектИсходящий <> Неопределено Тогда
			ДокументВнешнийОбъектИсходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектИсходящий = Элементы.ЗапросИсходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектИсходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектИсходящий.setText(Объект.ЗапросИсходящий);
		
		Если ДокументВнешнийОбъектВходящий <> Неопределено Тогда
			ДокументВнешнийОбъектВходящий.destroy();
		КонецЕсли;
		
		ДокументВнешнийОбъектВходящий = Элементы.ЗапросВходящий.Документ.defaultView.Init(ВидОтображения);
		ДокументВнешнийОбъектВходящий.setName("Корень"); // Установка имени верхнего уровня для дерева
		ДокументВнешнийОбъектВходящий.setText(Объект.ЗапросВходящий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициализироватьИЗаполнитьТекстомОбъектXML(ТипЗапроса)
	
	Если ТипЗапроса = "Исходящий" Тогда
		Элементы.ЗапросИсходящий.Документ.defaultView.start(ОтформатироватьСообщениеИнтеграции(Объект.ЗапросИсходящий), "nerd");
	Иначе
		Элементы.ЗапросВходящий.Документ.defaultView.start(ОтформатироватьСообщениеИнтеграции(Объект.ЗапросВходящий), "nerd");
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДвоичныеДанныеМакета(ФорматИнтеграции)
	
	Возврат ПолучитьОбщийМакет("__" + ФорматИнтеграции + "Editor");
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьФорматИнтеграции(ФорматЗапросаИнтеграции)
	
	ИндексЗначенияПеречисления = Перечисления.__ФорматыЗапросовИнтеграции.Индекс(ФорматЗапросаИнтеграции);
	ФорматИнтеграции = Метаданные.Перечисления.__ФорматыЗапросовИнтеграции.ЗначенияПеречисления[ИндексЗначенияПеречисления].Имя;
	
	Возврат ФорматИнтеграции;
	
КонецФункции

#КонецОбласти // СлужебныеПроцедурыИФункции
