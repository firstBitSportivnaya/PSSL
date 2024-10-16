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

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Модуль предназначен для подключения обработчиков обновления информационной базы,
// подключения библиотеки к регистру "Версии подсистем".
//
// Для того чтобы выполнилось обновление, необходимо в модуле БСП "ПодсистемыКонфигурацииПереопределяемый"
// в процедуре "ПриДобавленииПодсистем" вставить строчку "ОбщийМодуль.ПриДобавленииПодсистем(МодулиПодсистем)".
// пример: "пбп_ОбновлениеИнформационнойБазыПБП.ПриДобавленииПодсистем(МодулиПодсистем)".
// Подробную информацию по подключению подсистем см. на сайте ИТС -> Библиотека стандартных подсистем.
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// См. ПодсистемыКонфигурацииПереопределяемый.ПриДобавленииПодсистем.
Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	
	МодулиПодсистем.Добавить("пбп_ОбновлениеИнформационнойБазыПБП");
	
КонецПроцедуры

// СтандартныеПодсистемы.ОбновлениеВерсииИБ

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ИдентификаторИнтернетПоддержки - Строка - уникальное имя программы в сервисах Интернет-поддержки.
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//   * РежимВыполненияОтложенныхОбработчиков - Строка - "Последовательно" - отложенные обработчики обновления выполняются
//                                    последовательно в интервале от номера версии информационной базы до номера
//                                    версии конфигурации включительно или "Параллельно" - отложенный обработчик после
//                                    обработки первой порции данных передает управление следующему обработчику, а после
//                                    выполнения последнего обработчика цикл повторяется заново.
//   * ЗаполнятьДанныеНовыхПодсистемПриПереходеСДругойПрограммы - Булево - если установить Истина, то при переходе с
//                                    другой программы будут автоматически выполнены обработчики начального заполнения
//                                    новых подсистем. При описании обработчика обновления можно при необходимости
//                                    отключить его выполнение, указав свойство НеВыполнятьПриПереходеСДругойПрограммы.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя = "ПроектнаяБиблиотекаПодсистем";
	Описание.Версия = "1.0.3.7";
	
	// Требуется библиотека стандартных подсистем.
	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационной базы.

Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "пбп_ОбновлениеИнформационнойБазыПБП.НачальноеЗаполнение";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	
КонецПроцедуры

Процедура ПередОбновлениемИнформационнойБазы() Экспорт

КонецПроцедуры

Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт

КонецПроцедуры

Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт

КонецПроцедуры

Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт

КонецПроцедуры

Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт

КонецПроцедуры

Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнениеПредопределенныхЭлементов() Экспорт
	
	Типы = Метаданные.ОпределяемыеТипы.пбп_ПредопределенныеВсеСсылкиПереопределяемый.Тип.Типы();
	
	Для Каждого Тип Из Типы Цикл
		ПолноеИмя = Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
		Менеджер = пбп_ОбщегоНазначенияСлужебный.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
		
		пбп_ПредопределенныеЗначения.ИнициализироватьПредопределенныеЗначения(Менеджер);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти