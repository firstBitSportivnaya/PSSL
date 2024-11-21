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

////////////////////////////////////////////////////////////////////////////////
// серверные оповещения служебный: аналог модуля БСП

#Область ПрограммныйИнтерфейс

#Область ПереадресацияМетодов

// См. пбп_СерверныеОповещения.ОтправитьСерверноеОповещение.
Процедура ОтправитьСерверноеОповещение(ИмяОповещения, Результат, Адресаты, ОтправитьСразу = Ложь) Экспорт
	
	Модуль = ПолучитьМодуль();
	Модуль.ОтправитьСерверноеОповещение(ИмяОповещения, Результат, Адресаты, ОтправитьСразу);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьМодуль()
	Возврат пбп_ОбщегоНазначенияПовтИсп.ПереадресацияОбщегоМодуля("СерверныеОповещения", "пбп_СерверныеОповещения");
КонецФункции

#КонецОбласти