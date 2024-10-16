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
// Общего назначения (служебный): для серверных функций общего назначения, переадресация на методы БСП или их аналоги

#Область ПрограммныйИнтерфейс

#Область ПереадресацияМетодов

// См. пбп_ОбщегоНазначенияСервер.ВыполнитьМетодКонфигурации.
Процедура ВыполнитьМетодКонфигурации(Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ВыполнитьМетодКонфигурации(ИмяМетода, Параметры);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ВычислитьВБезопасномРежиме.
//
Функция ВычислитьВБезопасномРежиме(Знач Выражение, Знач Параметры = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ВычислитьВБезопасномРежиме(Выражение, Параметры);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ЗаписатьДанныеВБезопасноеХранилище.
Процедура ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ = "Пароль") Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ПрочитатьДанныеИзБезопасногоХранилища.
Функция ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи = "Пароль", ОбщиеДанные = Неопределено) Экспорт

	Модуль = ПолучитьМодуль();
	Возврат Модуль.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи, ОбщиеДанные);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.СообщитьПользователю.
Процедура СообщитьПользователю(Знач ТекстСообщенияПользователю, Знач КлючДанных = Неопределено, Знач Поле = "",
	Знач ПутьКДанным = "", Отказ = Ложь) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.СообщитьПользователю(ТекстСообщенияПользователю, КлючДанных, Поле, ПутьКДанным, Отказ);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ХранилищеОбщихНастроекСохранить.
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки, ОписаниеНастроек,
		ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ХранилищеОбщихНастроекЗагрузить.
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
			ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию, 
		ОписаниеНастроек, ИмяПользователя);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ХранилищеОбщихНастроекУдалить.
Процедура ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ПриНачалеВыполненияРегламентногоЗадания.
Процедура ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание);
	
КонецПроцедуры

// См. пбп_ОбщегоНазначенияСервер.ЗначенияРеквизитовОбъекта.
Функция ЗначенияРеквизитовОбъекта(Ссылка, Знач Реквизиты, ВыбратьРазрешенные = Ложь, Знач КодЯзыка = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты, ВыбратьРазрешенные, КодЯзыка);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ЗначениеРеквизитаОбъекта.
Функция ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные = Ложь, Знач КодЯзыка = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЗначенияРеквизитовОбъекта(Ссылка, ИмяРеквизита, ВыбратьРазрешенные, КодЯзыка);
	
КонецФункции 

// См. пбп_ОбщегоНазначенияСервер.ОписаниеТипаСтрока.
Функция ОписаниеТипаСтрока(ДлинаСтроки) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ОписаниеТипаСтрока(ДлинаСтроки);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ОписаниеТипаЧисло.
Функция ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти = 0, Знач ЗнакЧисла = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ОписаниеТипаЧисло(Разрядность, РазрядностьДробнойЧасти, ЗнакЧисла);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ИнформационнаяБазаФайловая.
Функция ИнформационнаяБазаФайловая(Знач СтрокаСоединенияИнформационнойБазы = "") Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ИнформационнаяБазаФайловая(СтрокаСоединенияИнформационнойБазы);
	
КонецФункции

#Область ТекущееОкружение

// См. пбп_ОбщегоНазначенияСервер.ЭтоWindowsСервер.
Функция ЭтоWindowsСервер() Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЭтоWindowsСервер();
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ЭтоLinuxСервер.
Функция ЭтоLinuxСервер() Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЭтоLinuxСервер();
	
КонецФункции

#КонецОбласти // ТекущееОкружение

#Область СериализацияXML

// См. пбп_ОбщегоНазначенияСервер.ЗначениеВСтрокуXML.
Функция ЗначениеВСтрокуXML(Значение) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЗначениеВСтрокуXML(Значение);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.ЗначениеИзСтрокиXML.
Функция ЗначениеИзСтрокиXML(СтрокаXML) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ЗначениеИзСтрокиXML(СтрокаXML);
	
КонецФункции

#КонецОбласти

// См. пбп_ОбщегоНазначенияСервер.МенеджерОбъектаПоПолномуИмени.
Функция МенеджерОбъектаПоПолномуИмени(ПолноеИмя) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.МенеджерОбъектаПоПолномуИмени(ПолноеИмя);
	
КонецФункции

// См. пбп_ОбщегоНазначенияСервер.МенеджерОбъектаПоСсылке.
//
Функция МенеджерОбъектаПоСсылке(Ссылка) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.МенеджерОбъектаПоСсылке(Ссылка);
	
КонецФункции

#Область Данные

// См. пбп_ОбщегоНазначенияСервер.КонтрольнаяСуммаСтрокой.
Функция КонтрольнаяСуммаСтрокой(Знач Данные, Знач Алгоритм = Неопределено) Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.КонтрольнаяСуммаСтрокой(Данные, Алгоритм);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьМодуль()
	Возврат пбп_ОбщегоНазначенияПовтИсп.ПереадресацияОбщегоМодуля("ОбщегоНазначения", "пбп_ОбщегоНазначенияСервер");
КонецФункции

#КонецОбласти
