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
// Виджеты (переопределяемый): настройки подсистемы виджетов при внедрении.

#Область ПрограммныйИнтерфейс

// Определяет методы конфигурации, которые разрешено выполнять действием виджета
// «ВыполнитьМетод». Метод, не включенный в список, не выполняется, а показатель или виджет
// с таким действием не проходит проверку заполнения.
// Разрешенный метод - экспортная серверная процедура общего модуля с одним параметром:
// структурой "Показатель, Пользователь" или "Виджет, Команда".
//
// Параметры:
//  Методы - Массив из Строка - полные имена методов вида "ИмяОбщегоМодуля.ИмяПроцедуры".
//
// Пример:
//  Методы.Добавить("УчетЗадач.ПересчитатьЗадачиПользователя");
//
Процедура ПриОпределенииРазрешенныхМетодов(Методы) Экспорт

	

КонецПроцедуры

#КонецОбласти
