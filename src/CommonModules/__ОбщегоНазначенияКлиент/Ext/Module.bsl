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

////////////////////////////////////////////////////////////////////////////////
// Общего назначения (клиент): для клиентских функций общего назначения

#Область ПрограммныйИнтерфейс

#Область МетодыАналогиБСП

// Аналог метода БСП. Возвращает ссылку на общий модуль или модуль менеджера по имени.
//
// См. ОбщегоНазначения.ОбщийМодуль
//
// Параметры:
//  Имя - Строка - имя общего модуля.
//
// Возвращаемое значение:
//  ОбщийМодуль
//  СправочникМенеджер,
//  ДокументМенеджер,
//  ОбработкаМенеджер,
//  РегистрСведенийМенеджер.
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
Функция ОбщийМодуль(ИмяМодуляБСП, ИмяМодуляВстроенного = "") Экспорт
	
	// Если ИмяМодуляВстроенного не передано, проверка не выполняется
	Имя = ИмяМодуляВстроенного;
	Если __ОбщегоНазначенияВызовСервера.СуществуетБиблиотекаСтандартныхПодсистем() Тогда
		Имя = ИмяМодуляБСП;
	ИначеЕсли ПустаяСтрока(Имя) Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль БСП ""%1"" не существует и не указан встроенный.'"), 
			Имя);
	КонецЕсли;
	Модуль = Вычислить(Имя);
	
#Если Не ВебКлиент Тогда
	
	// В веб-клиенте не проверяется
	// т.к. при обращении к модулям с вызовом сервера типа такого модуля в веб-клиенте не существует.
	
	Если ТипЗнч(Модуль) <> Тип("ОбщийМодуль") Тогда
		ВызватьИсключение __СтроковыеФункцииСлужебныйКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Общий модуль ""%1"" не существует.'"), 
			Имя);
	КонецЕсли;
	
#КонецЕсли
	
	Возврат Модуль;
	
КонецФункции

// Аналог метода БСП. Формирует и выводит сообщение, которое может быть связано с элементом управления формы.
//
// См. ОбщегоНазначения.СообщитьПользователю
//
// Параметры:
//  ТекстСообщенияПользователю - Строка - текст сообщения.
//  КлючДанных - ЛюбаяСсылка - объект или ключ записи информационной базы, к которому это сообщение относится.
//  Поле - Строка - наименование реквизита формы.
//  ПутьКДанным - Строка - путь к данным (путь к реквизиту формы).
//  Отказ - Булево - выходной параметр, всегда устанавливается в значение Истина.
//
// Пример:
//
//  1. Для вывода сообщения у поля управляемой формы, связанного с реквизитом объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ПолеВРеквизитеФормыОбъект",
//   "Объект");
//
//  Альтернативный вариант использования в форме объекта:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "Объект.ПолеВРеквизитеФормыОбъект");
//
//  2. Для вывода сообщения рядом с полем управляемой формы, связанным с реквизитом формы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ,
//   "ИмяРеквизитаФормы");
//
//  3. Для вывода сообщения связанного с объектом информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), ОбъектИнформационнойБазы, "Ответственный",,Отказ);
//
//  4. Для вывода сообщения по ссылке на объект информационной базы:
//  ОбщегоНазначенияКлиент.СообщитьПользователю(
//   НСтр("ru = 'Сообщение об ошибке.'"), Ссылка, , , Отказ);
//
//  Случаи некорректного использования:
//   1. Передача одновременно параметров КлючДанных и ПутьКДанным.
//   2. Передача в параметре КлючДанных значения типа отличного от допустимого.
//   3. Установка ссылки без установки поля (и/или пути к данным).
//
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю,	Знач КлючДанных = Неопределено,
	Знач Поле = "", Знач ПутьКДанным = "", Отказ = Ложь) Экспорт
	
	Сообщение = __ОбщегоНазначенияСлужебныйКлиентСервер.СообщениеПользователю(ТекстСообщенияПользователю,
		КлючДанных, Поле, ПутьКДанным, Отказ);
	
	Сообщение.Сообщить();
	
КонецПроцедуры

// Аналог метода БСП. Возвращает ссылку предопределенного элемента по его полному имени.
// Предопределенные элементы могут содержаться только в следующих объектах:
//   - справочники;
//   - планы видов характеристик;
//   - планы счетов;
//   - планы видов расчета.
// После изменения состава предопределенных следует выполнить метод
// ОбновитьПовторноИспользуемыеЗначения(), который сбросит кэш ПовтИсп в текущем сеансе.
//
// См. ОбщегоНазначения.ПредопределенныйЭлемент
//
// Параметры:
//   ПолноеИмяПредопределенного - Строка - полный путь к предопределенному элементу, включая его имя.
//     Формат аналогичен функции глобального контекста ПредопределенноеЗначение().
//     Например:
//       "Справочник.ВидыКонтактнойИнформации.EmailПользователя"
//       "ПланСчетов.Хозрасчетный.Материалы"
//       "ПланВидовРасчета.Начисления.ОплатаПоОкладу".
//
// Возвращаемое значение: 	
//   ЛюбаяСсылка - ссылка на предопределенный элемент.
//   Неопределено - если предопределенный элемент есть в метаданных, но не создан в ИБ.
//
Функция ПредопределенныйЭлемент(ПолноеИмяПредопределенного) Экспорт
	
	Возврат ПредопределенноеЗначение(ПолноеИмяПредопределенного);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти