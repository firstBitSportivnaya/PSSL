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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоНовый()
		И пбп_ОбщегоНазначенияПовтИсп.ПолучитьЗначениеКонстанты("пбп_ИспользоватьПользовательскиеФункции") Тогда
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = "ВЫБРАТЬ
		|	пбп_ИнтеграционныеПотоки.ПользовательскаяФункция КАК ПользовательскаяФункция,
		|	пбп_ИнтеграционныеПотоки.НастройкаИнтеграции КАК НастройкаИнтеграции
		|ИЗ
		|	Справочник.пбп_ИнтеграционныеПотоки КАК пбп_ИнтеграционныеПотоки
		|ГДЕ
		|	пбп_ИнтеграционныеПотоки.Ссылка = &Ссылка";
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаРезультатаЗапроса = РезультатЗапроса.Выбрать();
		
		ПользовательскаяФункцияДоИзменения = Справочники.пбп_ПользовательскиеФункции.ПустаяСсылка();
		НастройкаИнтеграцииДоИзменения = Справочники.пбп_НастройкиИнтеграции.ПустаяСсылка();
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			ПользовательскаяФункцияДоИзменения = ВыборкаРезультатаЗапроса.ПользовательскаяФункция;
			НастройкаИнтеграцииДоИзменения = ВыборкаРезультатаЗапроса.НастройкаИнтеграции;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПользовательскаяФункцияДоИзменения)
			И Не ЗначениеЗаполнено(ПользовательскаяФункция) Тогда
			УдалитьРегламентноеЗаданиеПоКлючу(Строка(Ссылка.УникальныйИдентификатор()));
		КонецЕсли;
		
		ФункцияИзменена = ЗначениеЗаполнено(ПользовательскаяФункцияДоИзменения) И ЗначениеЗаполнено(ПользовательскаяФункция)
			И ПользовательскаяФункцияДоИзменения <> ПользовательскаяФункция;
		НастройкаИзменена = ЗначениеЗаполнено(НастройкаИнтеграцииДоИзменения) И ЗначениеЗаполнено(НастройкаИнтеграции)
			И НастройкаИнтеграцииДоИзменения <> НастройкаИнтеграции;
		Если ФункцияИзменена Или НастройкаИзменена Тогда
			ОбновитьПараметрыРегламентногоЗадания();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // ОбработчикиСобытий

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьПараметрыРегламентногоЗадания()
	
	КлючЗадания = Строка(Ссылка.УникальныйИдентификатор());
	
	ОтборЗадания = Новый Структура;
	ОтборЗадания.Вставить("Ключ", КлючЗадания);
	МассивРегламентныхЗаданий = пбп_РегламентныеЗаданияСервер.НайтиЗадания(ОтборЗадания);
	
	Если МассивРегламентныхЗаданий.Количество() Тогда
		РегламентноеЗадание = МассивРегламентныхЗаданий[0];
		
		ПараметрыРегламентногоЗадания = Новый Массив;
		ПараметрыРегламентногоЗадания.Добавить(НастройкаИнтеграции);
		ПараметрыРегламентногоЗадания.Добавить(ПользовательскаяФункция);
		
		РегламентноеЗадание.Параметры = ПараметрыРегламентногоЗадания;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьРегламентноеЗаданиеПоКлючу(КлючЗадания)
	
	ОтборЗадания = Новый Структура;
	ОтборЗадания.Вставить("Ключ", КлючЗадания);
	МассивРегламентныхЗаданий = пбп_РегламентныеЗаданияСервер.НайтиЗадания(ОтборЗадания);
	
	Если МассивРегламентныхЗаданий.Количество() Тогда
		РегламентноеЗадание = МассивРегламентныхЗаданий[0];
		пбп_РегламентныеЗаданияСервер.УдалитьЗадание(РегламентноеЗадание.УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти // СлужебныеПроцедурыИФункцкии

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли