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

#Область СлужебныйПрограммныйИнтерфейс

#Область ПереадресацияМетодов

// См. пбп_СтандартныеПодсистемыПовтИсп.ОписаниеТипаВсеСсылки.
Функция ОписаниеТипаВсеСсылки() Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ОписаниеТипаВсеСсылки();
	
КонецФункции

// См. пбп_СтандартныеПодсистемыПовтИсп.ИменаПодсистем.
Функция ИменаПодсистем() Экспорт
	
	Модуль = ПолучитьМодуль();
	Возврат Модуль.ИменаПодсистем();
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьМодуль()
	Возврат пбп_ОбщегоНазначенияПовтИсп.ПереадресацияОбщегоМодуля(
		"СтандартныеПодсистемыПовтИсп",
		"пбп_СтандартныеПодсистемыПовтИсп");
КонецФункции

#КонецОбласти
