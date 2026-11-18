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

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ВыполнитьМетод = Перечисления.пбп_ДействияВиджетов.ВыполнитьМетод;
	Для Каждого СтрокаКоманды Из Команды Цикл

		Если СтрокаКоманды.Действие <> ВыполнитьМетод
			Или пбп_ВиджетыРабочийСтол.МетодДействияРазрешен(СтрокаКоманды.ПараметрДействия) Тогда

			Продолжить;

		КонецЕсли;

		Поле = СтрШаблон("Команды[%1].ПараметрДействия", Формат(СтрокаКоманды.НомерСтроки - 1, "ЧН=0; ЧГ=0"));
		пбп_Переадресация.СообщитьПользователю(
			пбп_ВиджетыРабочийСтол.ТекстМетодНеРазрешен(СтрокаКоманды.ПараметрДействия), ЭтотОбъект, Поле, , Отказ);

	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
