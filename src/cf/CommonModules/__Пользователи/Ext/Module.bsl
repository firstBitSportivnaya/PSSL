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

#Область ПрограммныйИнтерфейс

#Область МетодыАналогиБСП

// Аналог метода БСП. Возвращает текущего пользователя.
//  Рекомендуется использовать в коде, который не поддерживает работу с внешними пользователями.
//
//  Если вход в сеанс выполнил внешний пользователь, тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - пользователь.
//
Функция ТекущийПользователь() Экспорт
	
	Возврат __ПользователиКлиентСервер.ТекущийПользователь(АвторизованныйПользователь());
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область МетодыАналогиБСП

// Аналог метода БСП. Только для внутреннего использования.
//
// Возвращаемое значение:
//  Неопределено
//
Функция АвторизованныйПользователь() Экспорт
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
