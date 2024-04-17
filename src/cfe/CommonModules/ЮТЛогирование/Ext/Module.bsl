﻿//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2024 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область ПрограммныйИнтерфейс

// Выводит отладочное сообщение
//
// Параметры:
//  Сообщение - Строка - Сообщение
Процедура Отладка(Сообщение) Экспорт
	
	ЮТЛогированиеСлужебный.Записать("DBG", Сообщение, 0);
	
КонецПроцедуры

// Выводит информационное сообщение
//
// Параметры:
//  Сообщение - Строка - Сообщение
Процедура Информация(Сообщение) Экспорт
	
	ЮТЛогированиеСлужебный.Записать("INF", Сообщение, 10);
	
КонецПроцедуры

// Выводит предупреждение
//
// Параметры:
//  Сообщение - Строка - Сообщение
Процедура Предостережение(Сообщение) Экспорт
	
	ЮТЛогированиеСлужебный.Записать("WRN", Сообщение, 20);
	
КонецПроцедуры

// Выводит сообщение об ошибке
//
// Параметры:
//  Сообщение - Строка - Сообщение
Процедура Ошибка(Сообщение) Экспорт
	
	ЮТЛогированиеСлужебный.Записать("ERR", Сообщение, 99);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция УровниЛога() Экспорт
	
	Возврат Новый ФиксированнаяСтруктура("Отладка, Информация, Предупреждение, Ошибка", "debug", "info", "warning", "error");
	
КонецФункции

#КонецОбласти
