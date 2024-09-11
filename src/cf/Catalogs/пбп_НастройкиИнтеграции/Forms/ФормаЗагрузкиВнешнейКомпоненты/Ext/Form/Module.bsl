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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("НастройкаИнтеграции") Тогда
		НастройкаИнтеграции = Параметры.НастройкаИнтеграции;
		
		Элементы.ГруппаОсновная.Заголовок = СтрШаблон(Элементы.ГруппаОсновная.Заголовок, НастройкаИнтеграции.Наименование);
		
		Если Параметры.АдресВнешнейКомпоненты = "" Тогда
			ИсточникПравил = "ТиповаяИзКонфигурации";
		Иначе
			ИсточникПравил = "ЗагруженныеИзФайла";
			
			ИмяФайлаКомпоненты = Параметры.ИмяФайла;
			ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(Параметры.АдресВнешнейКомпоненты);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытийФормы

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьВнешнююКомпонентуИзФайла(Команда)
	
	ЗаголовокДиалога = НСтр("ru = 'Укажите файл внешней компоненты'");
	
	РежимОткрытияДиалога = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытия = Новый ДиалогВыбораФайла(РежимОткрытияДиалога);
	ДиалогОткрытия.Каталог					= "";
	ДиалогОткрытия.Фильтр					= "Динамически подключаемая библиотека (*.dll)|*.dll| ZIP-архив (*.zip)|*.zip";
	ДиалогОткрытия.Расширение				= "dll, zip";
	ДиалогОткрытия.Заголовок				= ЗаголовокДиалога;
	ДиалогОткрытия.ПредварительныйПросмотр	= Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ОбработчикВыбораФайлаЗавершениеПослеВыбораВДиалоге", ЭтотОбъект);
	
	ДиалогОткрытия.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьВнешнююКомпонентуВФайл(Команда)
	
	Если ПустаяСтрока(ИмяФайлаКомпоненты) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаголовокДиалога = НСтр("ru = 'Укажите файл внешней компоненты'");
	
	МассивРазделителей = пбп_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		ИмяФайлаКомпоненты, ".", Истина, Истина);
	ИмяКомпоненты = МассивРазделителей[0];
	КоличествоРазделимых = 2;
	Если МассивРазделителей.Количество() = КоличествоРазделимых Тогда
		Расширение = МассивРазделителей[1];
	КонецЕсли;
	
	РежимОткрытияДиалога = РежимДиалогаВыбораФайла.Сохранение;
	ДиалогСохранения = Новый ДиалогВыбораФайла(РежимОткрытияДиалога);
	ДиалогСохранения.ПолноеИмяФайла				= ИмяКомпоненты;
	ДиалогСохранения.Расширение					= Расширение;
	ДиалогСохранения.Заголовок					= ЗаголовокДиалога;
	ДиалогСохранения.ПредварительныйПросмотр	= Ложь;
	ДиалогСохранения.Каталог					= "";
	
	Оповещение = Новый ОписаниеОповещения("ОбработчикВыбораКаталогаСохранениеЗавершениеПослеВыбораВДиалоге", ЭтотОбъект);
	
	ДиалогСохранения.Показать(Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	ИзмененВручную = ИсточникПравил = "ЗагруженныеИзФайла"
		И ЗначениеЗаполнено(ИмяФайлаКомпоненты);
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("ИзмененВручную", ИзмененВручную);
	ПараметрыЗакрытия.Вставить("ДвоичныеДанные", ДвоичныеДанныеФайла);
	
	ИмяФайла = "";
	Если Не ПустаяСтрока(ИмяФайлаКомпоненты) Тогда
		Если пбп_ОбщегоНазначенияКлиент.ЭтоWindowsКлиент() Тогда
			МассивРазделителей = пбп_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
				ИмяФайлаКомпоненты, "\", Истина, Истина);
		Иначе
			МассивРазделителей = пбп_СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
				ИмяФайлаКомпоненты, "/", Истина, Истина);
		КонецЕсли;
		
		Если МассивРазделителей.Количество() Тогда
			ИмяФайла = МассивРазделителей[МассивРазделителей.Количество() - 1];
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыЗакрытия.Вставить("ИмяФайла", ИмяФайла);
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезИзменений(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти // ОбработчикиКомандФормы

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработчикВыбораФайлаЗавершениеПослеВыбораВДиалоге(Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайлаКомпоненты = Результат[0];
	
	ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ИмяФайлаКомпоненты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораКаталогаСохранениеЗавершениеПослеВыбораВДиалоге(
	Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = Результат[0];
	
	ДвоичныеДанныеФайла.Записать(ПутьКФайлу);
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункции