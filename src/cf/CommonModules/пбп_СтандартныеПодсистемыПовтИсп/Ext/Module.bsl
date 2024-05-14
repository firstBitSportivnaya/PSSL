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

Функция ОписаниеТипаВсеСсылки() Экспорт
	
	Возврат Новый ОписаниеТипов(Новый ОписаниеТипов(Новый ОписаниеТипов(Новый ОписаниеТипов(Новый ОписаниеТипов(
		Новый ОписаниеТипов(Новый ОписаниеТипов(Новый ОписаниеТипов(Новый ОписаниеТипов(
			Справочники.ТипВсеСсылки(),
			Документы.ТипВсеСсылки().Типы()),
			ПланыОбмена.ТипВсеСсылки().Типы()),
			Перечисления.ТипВсеСсылки().Типы()),
			ПланыВидовХарактеристик.ТипВсеСсылки().Типы()),
			ПланыСчетов.ТипВсеСсылки().Типы()),
			ПланыВидовРасчета.ТипВсеСсылки().Типы()),
			БизнесПроцессы.ТипВсеСсылки().Типы()),
			БизнесПроцессы.ТипВсеСсылкиТочекМаршрутаБизнесПроцессов().Типы()),
			Задачи.ТипВсеСсылки().Типы());
	
КонецФункции

#КонецОбласти