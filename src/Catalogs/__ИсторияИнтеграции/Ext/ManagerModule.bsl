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

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Процедура очищает записи в справочнике старше чем установленное в предопределенном значении количество дней
Процедура ОчиститьИсториюИнтеграции() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсторияИнтеграции.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.__ИсторияИнтеграции КАК ИсторияИнтеграции
		|ГДЕ
		|	(ИсторияИнтеграции.Ошибка
		|				И ИсторияИнтеграции.ДатаИнтеграции < ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, -&ДнейХраненияОшибок)
		|			ИЛИ НЕ ИсторияИнтеграции.Ошибка
		|				И ИсторияИнтеграции.ДатаИнтеграции < ДОБАВИТЬКДАТЕ(&ТекущаяДата, ДЕНЬ, -&ДнейХранения))";
	
	Запрос.УстановитьПараметр("ТекущаяДата", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("ДнейХранения", __ОбщегоНазначенияСервер.ПолучитьПредопределенноеЗначение("КолДнейХраненияИсторииИнтеграции"));
	Запрос.УстановитьПараметр("ДнейХраненияОшибок", __ОбщегоНазначенияСервер.ПолучитьПредопределенноеЗначение("КолДнейХраненияОшибокИсторииИнтеграции"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Попытка
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			
			ЗаписьИсторииОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗаписьИсторииОбъект.Удалить();
			
		КонецЦикла;
		
	Исключение
		
		ИмяСобытия = НСтр("ru = 'Очистка истории интеграции'");
		ЗаголовокОшибки = СтрШаблон("Не удалось удалить запись истории интеграции %1", ВыборкаДетальныеЗаписи.Ссылка);
		
		ТекстОшибки = __ОбщегоНазначенияСервер.ПолучениеПолногоТекстаОшибкиПриИсключении(ЗаголовокОшибки,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), ПолучитьСообщенияПользователю(Истина));
		__ЖурналРегистрацииСлужебный.ДобавитьСообщениеДляЖурналаРегистрации(
			ИмяСобытия,
			УровеньЖурналаРегистрации.Ошибка,
			,
			ВыборкаДетальныеЗаписи.Ссылка,
			ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти // ПрограммныйИнтерфейс

#КонецЕсли