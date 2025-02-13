///////////////////////////////////////////////////////////////////////////////////////////////////////
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
// URL: https://github.com/firstBitSportivnaya/PSSL/
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ОбработчикиРесурсов() Экспорт
	
	РесурсыИОбработчики = пбп_ПостроительСпецификацииOpenAPI.ПолучитьОбработчикиИРесурсыСпецификации();
	
	Обработчики = Новый Соответствие;
	
	Для Каждого Пара Из РесурсыИОбработчики Цикл
		Обработчики.Вставить(Пара.Ресурс, Пара.Обработчик);
	КонецЦикла;
	
	Возврат Обработчики;
	
Конецфункции

Функция ДопустимыеРесурсыСпецификации() Экспорт
	
	РесурсыИОбработчики = пбп_ПостроительСпецификацииOpenAPI.ПолучитьОбработчикиИРесурсыСпецификации();
	
	ДопустимыеРесурсы = Новый Соответствие;
	
	Для Каждого Пара Из РесурсыИОбработчики Цикл
		ДопустимыеРесурсы.Вставить(Пара.Ресурс, Истина);
	КонецЦикла;
	
	Возврат ДопустимыеРесурсы;
	
КонецФункции

#КонецОбласти // СлужебныйПрограммныйИнтерфейс