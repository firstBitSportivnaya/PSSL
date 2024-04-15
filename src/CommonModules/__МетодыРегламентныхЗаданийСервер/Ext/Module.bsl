﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8, включая доработку типовых конфигураций.
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

//Длительность хранения ошибок интеграции на месяц дольше, чем успешных записей
Процедура ОчисткаИсторииИнтеграции() Экспорт
	
	__ОбщегоНазначенияСлужебный.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.__ОчисткаИсторииИнтеграции);
	Справочники.__ИсторияИнтеграции.ОчиститьИсториюИнтеграции();
	
КонецПроцедуры

#КонецОбласти
