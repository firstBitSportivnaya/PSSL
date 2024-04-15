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

#Область ПрограммныйИнтерфейс

#Область МетодыАналогиБСП

// Аналог метода БСП. В локальном режиме работы возвращает регламентные задания, соответствующие отбору.
// В модели сервиса - таблицу значений, в которой содержится описание найденных заданий
// в справочнике ОчередьЗаданий.
//
// Параметры:
//  Отбор - Структура - со свойствами: 
//          1) Общие для любого режима работы:
//             * УникальныйИдентификатор - УникальныйИдентификатор - идентификатор регламентного задания в локальном
//                                         режиме работы или идентификатор ссылки задания очереди в модели сервиса.
//                                       - Строка - строка уникального идентификатора регламентного задания в локальном
//                                         режиме работы или идентификатор ссылки задания очереди в модели сервиса.
//                                       - СправочникСсылка.ОчередьЗаданий - идентификатор задания
//                                            очереди в модели сервиса.
//                                       - СтрокаТаблицыЗначений из см. НайтиЗадания
//             * Метаданные              - ОбъектМетаданныхРегламентноеЗадание - метаданные регламентного задания.
//                                       - Строка - имя метаданных регламентного задания.
//             * Использование           - Булево - если Истина, задание включено.
//             * Ключ                    - Строка - прикладной идентификатор задания.
//          2) Возможные ключи только локального режима:
//             * Наименование            - Строка - наименование регламентного задания.
//             * Предопределенное        - Булево - если Истина, регламентное задание определено в метаданных.
//          3) Возможные ключи только для модели сервиса:
//             * ИмяМетода               - Строка - имя метода (или псевдоним) обработчика очереди задании.
//             * ОбластьДанных           - Число - значение разделителя области данных задания.
//             * СостояниеЗадания        - ПеречислениеСсылка.СостоянияЗаданий - состояние задания очереди.
//             * Шаблон                  - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания, используется только
//                                            для разделенных заданий очереди.
//
// Возвращаемое значение:
//     Массив из РегламентноеЗадание - в локальном режиме работы массив регламентных заданий.
//     ТаблицаЗначений - в модели сервиса с колонками:
//        * Использование                - Булево - если Истина, задание включено.
//        * Ключ                         - Строка - прикладной идентификатор задания.
//        * Параметры                    - Массив - параметры, передаваемые в обработчик задания.
//        * Расписание                   - РасписаниеРегламентногоЗадания - расписание задания.
//        * УникальныйИдентификатор      - СправочникСсылка.ОчередьЗаданий - идентификатор задания
//                                            очереди в модели сервиса.
//        * ЗапланированныйМоментЗапуска - Дата - дата и время запланированного запуска задания
//                                         (в часовом поясе области данных).
//        * ИмяМетода                    - Строка - имя метода (или псевдоним) обработчика очереди задании.
//        * ОбластьДанных                - Число - значение разделителя области данных задания.
//        * СостояниеЗадания             - ПеречислениеСсылка.СостоянияЗаданий - состояние задания очереди.
//        * Шаблон                       - СправочникСсылка.ШаблоныЗаданийОчереди - шаблон задания,
//                                            используется только для разделенных заданий очереди.
//        * ЭксклюзивноеВыполнение       - Булево - при установленном флаге задание будет выполнено 
//                                                  даже при установленной блокировке начала сеансов в области
//                                                  данных. Так же если в области есть задания с таким флагом
//                                                  сначала будут выполнены они.
//        * ИнтервалПовтораПриАварийномЗавершении - Число - интервал в секундах, через который нужно перезапускать
//                                                          задание в случае его аварийного завершения.
//        * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//
Функция НайтиЗадания(Отбор) Экспорт
	
	СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	
	Возврат СписокЗаданий;
	
КонецФункции

// Аналог метода БСП. Удаляет задание из очереди или регламентное.
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                                     непредопределенного регламентного задания.
//                - Строка - имя метаданных предопределенного регламентного задания в любом режиме работы
//                           или строка уникального идентификатора регламентного задания в локальном режиме работы
//                           или строка уникального идентификатора ссылки задания очереди в модели сервиса.
//                - УникальныйИдентификатор - идентификатор регламентного задания в локальном режиме работы.
//                           или идентификатор ссылки задания очереди в модели сервиса.
//                - РегламентноеЗадание - регламентное задание, уникальный идентификатор которого используется 
//                  для определения удаляемого экземпляра регламентного задания в локальном режиме работы.
//                - СправочникСсылка.ОчередьЗаданий - идентификатор задания очереди в модели сервиса.
//                - СтрокаТаблицыЗначений из см. НайтиЗадания
//
Процедура УдалитьЗадание(Знач Идентификатор) Экспорт
	
	Идентификатор = УточненныйИдентификаторЗадания(Идентификатор);
	
	УдалитьРегламентноеЗадание(Идентификатор);
	
КонецПроцедуры

// Аналог метода БСП. Добавляет новое задание в очередь или регламентное.
// 
// Параметры: 
//  Параметры - Структура - параметры добавляемого задания, возможные свойства:
//   * Использование - Булево - Истина, если регламентное задание должно выполняться автоматически согласно расписанию. 
//   * Метаданные    - ОбъектМетаданныхРегламентноеЗадание - обязательно для указания. Объект метаданных, на основе 
//                              которого будет создано регламентное задание.
//   * Параметры     - Массив - параметры регламентного задания. Количество и состав параметров должны соответствовать 
//                              параметрам метода регламентного задания.
//   * Ключ          - Строка - прикладной идентификатор регламентного задания.
//   * ИнтервалПовтораПриАварийномЗавершении - Число - интервал в секундах, через который нужно перезапускать задание 
//                              в случае его аварийного завершения.
//   * Расписание    - РасписаниеРегламентногоЗадания - расписание задания.
//   * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//
// Возвращаемое значение:
//  РегламентноеЗадание - в локальном режиме работы.
//  СтрокаТаблицыЗначений из см. НайтиЗадания
// 
Функция ДобавитьЗадание(Параметры) Экспорт
	
	Задание = ДобавитьРегламентноеЗадание(Параметры);
	
	Возврат Задание;
	
КонецФункции

// Аналог метода БСП. Добавляет новое регламентное задание (без учета очереди заданий модели сервиса).
// 
// Параметры: 
//  Параметры - Структура - параметры добавляемого задания, возможные свойства:
//   * Использование - Булево - Истина, если регламентное задание должно выполняться автоматически согласно расписанию. 
//   * Метаданные    - ОбъектМетаданныхРегламентноеЗадание - обязательно для указания. Объект метаданных, на основе 
//                              которого будет создано регламентное задание.
//   * Параметры     - Массив - параметры регламентного задания. Количество и состав параметров должны соответствовать 
//                              параметрам метода регламентного задания.
//   * Ключ          - Строка - прикладной идентификатор регламентного задания.
//   * ИнтервалПовтораПриАварийномЗавершении - Число - интервал в секундах, через который нужно перезапускать задание 
//                              в случае его аварийного завершения.
//   * Расписание    - РасписаниеРегламентногоЗадания - расписание задания.
//   * КоличествоПовторовПриАварийномЗавершении - Число - количество повторов при аварийном завершении задания.
//
// Возвращаемое значение:
//  РегламентноеЗадание
//
Функция ДобавитьРегламентноеЗадание(Параметры) Экспорт
	
	МетаданныеЗадания = Параметры.Метаданные;
	Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеЗадания);
	
	Если Параметры.Свойство("Наименование") Тогда
		Задание.Наименование = Параметры.Наименование;
	Иначе
		Задание.Наименование = МетаданныеЗадания.Наименование;
	КонецЕсли;
	
	Если Параметры.Свойство("Использование") Тогда
		Задание.Использование = Параметры.Использование;
	Иначе
		Задание.Использование = МетаданныеЗадания.Использование;
	КонецЕсли;
	
	Если Параметры.Свойство("Ключ") Тогда
		Задание.Ключ = Параметры.Ключ;
	Иначе
		Задание.Ключ = МетаданныеЗадания.Ключ;
	КонецЕсли;
	
	Если Параметры.Свойство("ИмяПользователя") Тогда
		Задание.ИмяПользователя = Параметры.ИмяПользователя;
	КонецЕсли;
	
	Если Параметры.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
		Задание.ИнтервалПовтораПриАварийномЗавершении = Параметры.ИнтервалПовтораПриАварийномЗавершении;
	Иначе
		Задание.ИнтервалПовтораПриАварийномЗавершении = МетаданныеЗадания.ИнтервалПовтораПриАварийномЗавершении;
	КонецЕсли;
	
	Если Параметры.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
		Задание.КоличествоПовторовПриАварийномЗавершении = Параметры.КоличествоПовторовПриАварийномЗавершении;
	Иначе
		Задание.КоличествоПовторовПриАварийномЗавершении = МетаданныеЗадания.КоличествоПовторовПриАварийномЗавершении;
	КонецЕсли;
	
	Если Параметры.Свойство("Параметры") Тогда
		Задание.Параметры = Параметры.Параметры;
	КонецЕсли;
	
	Если Параметры.Свойство("Расписание") Тогда
		Задание.Расписание = Параметры.Расписание;
	КонецЕсли;
	
	Задание.Записать();
	
	Возврат Задание;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область МетодыАналогиБСП

// Аналог метода БСП.
//
Функция УточненныйИдентификаторЗадания(Знач Идентификатор)
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		ОбъектМетаданных = Метаданные.РегламентныеЗадания.Найти(Идентификатор);
		Если ОбъектМетаданных = Неопределено Тогда
			Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
		Иначе
			Идентификатор = ОбъектМетаданных;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Идентификатор;
	
КонецФункции

// Аналог метода БСП. Удаляет непредопределенное регламентное задание (без учета очереди заданий модели сервиса).
//
// Параметры:
//  Идентификатор - ОбъектМетаданных - объект метаданных регламентного задания для поиска
//                                     непредопределенного регламентного задания.
//                - Строка - имя метаданных предопределенного регламентного задания
//                           или строка уникального идентификатора регламентного задания.
//                - УникальныйИдентификатор - идентификатор регламентного задания.
//                - РегламентноеЗадание - регламентное задание, уникальный идентификатор которого используется 
//                  для определения удаляемого экземпляра регламентного задания.
//
Процедура УдалитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	
	Идентификатор = УточненныйИдентификаторЗадания(Идентификатор);
	
	СписокЗаданий = Новый Массив; // Массив из РегламентноеЗадание.
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		Отбор = Новый Структура("Метаданные, Предопределенное", Идентификатор, Ложь);
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если РегламентноеЗадание <> Неопределено Тогда
			СписокЗаданий.Добавить(РегламентноеЗадание);
		КонецЕсли;
	КонецЕсли;
	
	Для Каждого РегламентноеЗадание Из СписокЗаданий Цикл
		ИдентификаторЗадания = УникальныйИдентификаторЗадания(РегламентноеЗадание);
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Строка(ИдентификаторЗадания));
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
			Если Задание <> Неопределено Тогда
				Задание.Удалить();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

// Аналог метода БСП.
//
Функция УникальныйИдентификаторЗадания(Знач Идентификатор, ВРазделенномРежимеИдентификаторЗаданияОчереди = Ложь)
	
	Если ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
		Возврат Идентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Возврат Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Возврат Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
		Возврат РегламентныеЗадания.НайтиПредопределенное(Идентификатор).УникальныйИдентификатор;
	ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
		Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
			Возврат РегламентноеЗадание.УникальныйИдентификатор;
		КонецЦикла; 
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти