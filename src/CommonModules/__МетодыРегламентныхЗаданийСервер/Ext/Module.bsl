﻿
#Область ПрограммныйИнтерфейс

//Длительность хранения ошибок интеграции на месяц дольше, чем успешных записей
Процедура ОчисткаИсторииИнтеграции() Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначения = Неопределено;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.__ОчисткаИсторииИнтеграции);
	Справочники.__ИсторияИнтеграции.ОчиститьИсториюИнтеграции();
	
КонецПроцедуры

#КонецОбласти
