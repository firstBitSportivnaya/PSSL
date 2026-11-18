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
// Виджеты (вызов сервера): действия виджетов, выполняемые на сервере.

#Область СлужебныйПрограммныйИнтерфейс

// Выполняет метод конфигурации, заданный в действии показателя или команды виджета.
// Имя метода читается из информационной базы по источнику, а не передается с клиента.
//
// Параметры:
//  Источник - СправочникСсылка.пбп_ПоказателиВиджетов, СправочникСсылка.пбп_Виджеты - показатель или виджет команды.
//  НомерКоманды - Число - номер строки команды виджета, 0 для показателя.
//
Процедура ВыполнитьМетод(Источник, НомерКоманды = 0) Экспорт
	
	пбп_ВиджетыРабочийСтол.ВыполнитьМетодДействия(Источник, НомерКоманды);
	
КонецПроцедуры

#КонецОбласти
