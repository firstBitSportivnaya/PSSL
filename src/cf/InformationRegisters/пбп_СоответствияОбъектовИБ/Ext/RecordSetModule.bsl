// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
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

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТипыСоответствий = ЭтотОбъект.ВыгрузитьКолонку("ТипСоответствия");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	пбп_ТипСоответствияОбъектовИБ.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.пбп_ТипСоответствияОбъектовИБ КАК пбп_ТипСоответствияОбъектовИБ
		|ГДЕ
		|	пбп_ТипСоответствияОбъектовИБ.Кэшируется
		|	И пбп_ТипСоответствияОбъектовИБ.Ссылка В(&ТипыСоответствий)";
	
	Запрос.УстановитьПараметр("ТипыСоответствий", ТипыСоответствий);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли