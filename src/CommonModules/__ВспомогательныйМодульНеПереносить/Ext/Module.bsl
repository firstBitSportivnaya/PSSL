﻿Функция НайтиЗадания(Отбор) Экспорт
	
	СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	
	Возврат СписокЗаданий;
	
КонецФункции

Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Знач Разделитель = ",", Знач ПропускатьПустыеСтроки = Неопределено, 
	СокращатьНепечатаемыеСимволы = Ложь) Экспорт
	
	Если СтрДлина(Разделитель) = 1 
		И ПропускатьПустыеСтроки = Неопределено 
		И СокращатьНепечатаемыеСимволы Тогда 
		
		Результат = СтрРазделить(Значение, Разделитель, Ложь);
		Для Индекс = 0 По Результат.ВГраница() Цикл
			Результат[Индекс] = СокрЛП(Результат[Индекс])
		КонецЦикла;
		Возврат Результат;
		
	КонецЕсли;
	
	Результат = Новый Массив;
	
	// Для обеспечения обратной совместимости.
	Если ПропускатьПустыеСтроки = Неопределено Тогда
		ПропускатьПустыеСтроки = ?(Разделитель = " ", Истина, Ложь);
		Если ПустаяСтрока(Значение) Тогда 
			Если Разделитель = " " Тогда
				Результат.Добавить("");
			КонецЕсли;
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;
	//
	
	Позиция = СтрНайти(Значение, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Значение, Позиция - 1);
		Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Подстрока) Тогда
			Если СокращатьНепечатаемыеСимволы Тогда
				Результат.Добавить(СокрЛП(Подстрока));
			Иначе
				Результат.Добавить(Подстрока);
			КонецЕсли;
		КонецЕсли;
		Значение = Сред(Значение, Позиция + СтрДлина(Разделитель));
		Позиция = СтрНайти(Значение, Разделитель);
	КонецЦикла;
	
	Если Не ПропускатьПустыеСтроки Или Не ПустаяСтрока(Значение) Тогда
		Если СокращатьНепечатаемыеСимволы Тогда
			Результат.Добавить(СокрЛП(Значение));
		Иначе
			Результат.Добавить(Значение);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ВыполнитьМетодКонфигурации(Знач ИмяМетода, Знач Параметры = Неопределено) Экспорт
	
	ПараметрыСтрока = "";
	Если Параметры <> Неопределено И Параметры.Количество() > 0 Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + "Параметры[" + XMLСтрока(Индекс) + "],";
		КонецЦикла;
		ПараметрыСтрока = Сред(ПараметрыСтрока, 1, СтрДлина(ПараметрыСтрока) - 1);
	КонецЕсли;
	
	Выполнить ИмяМетода + "(" + ПараметрыСтрока + ")";
	
КонецПроцедуры

Функция СократитьСтрокуКонтрольнойСуммой(Строка, МаксимальнаяДлина) Экспорт
	
	МинимальнаяДлина = 32;
	Результат = Строка;
	Если СтрДлина(Строка) > МаксимальнаяДлина Тогда
		Результат = Лев(Строка, МаксимальнаяДлина - МинимальнаяДлина);
		ХешированиеДанных = Новый ХешированиеДанных(ХешФункция.MD5);
		ХешированиеДанных.Добавить(Сред(Строка, МаксимальнаяДлина - МинимальнаяДлина + 1));
		Результат = Результат + СтрЗаменить(ХешированиеДанных.ХешСумма, " ", "");
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

#Область ХранилищеНастроек

Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
			ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Возврат ХранилищеЗагрузить(ХранилищеОбщихНастроек,
		КлючОбъекта,
		КлючНастроек,
		ЗначениеПоУмолчанию,
		ОписаниеНастроек,
		ИмяПользователя);
	
КонецФункции

Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ХранилищеСохранить(ХранилищеОбщихНастроек,
		КлючОбъекта,
		КлючНастроек,
		Настройки,
		ОписаниеНастроек,
		ИмяПользователя,
		ОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

Процедура ХранилищеСохранить(МенеджерХранилища, КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек, ИмяПользователя, ОбновитьПовторноИспользуемыеЗначения)
	
	Если Не ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерХранилища.Сохранить(КлючОбъекта, КлючНастроек(КлючНастроек), Настройки,
		ОписаниеНастроек, ИмяПользователя);
	
	Если ОбновитьПовторноИспользуемыеЗначения Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
	
КонецПроцедуры

Функция ХранилищеЗагрузить(МенеджерХранилища, КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию,
			ОписаниеНастроек, ИмяПользователя)
	
	Результат = Неопределено;
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		Результат = МенеджерХранилища.Загрузить(КлючОбъекта, КлючНастроек(КлючНастроек),
			ОписаниеНастроек, ИмяПользователя);
	КонецЕсли;
		
	Если Результат = Неопределено Тогда
		Результат = ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КлючНастроек(Знач Строка)
	Возврат СократитьСтрокуКонтрольнойСуммой(Строка, 128);
КонецФункции

#КонецОбласти

Процедура ЗаписатьДанныеВБезопасноеХранилище(Владелец, Данные, Ключ = "Пароль") Экспорт
	Возврат;
КонецПроцедуры

Функция ПрочитатьДанныеИзБезопасногоХранилища(Владелец, Ключи = "Пароль", ОбщиеДанные = Неопределено) Экспорт
	
	// ++ Обход ошибки отстутствия модуля БСП, не переносить
	ОбщегоНазначенияКлиентСервер = __ВспомогательныйМодульНеПереноситьКлиентСервер;
	// -- Обход ошибки отстутствия модуля БСП, не переносить
	
	Владельцы = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Владелец);
	ДанныеВладельца = ПрочитатьДанныеВладельцевИзБезопасногоХранилища(Владельцы, Ключи, ОбщиеДанные);
	
	Результат = ДанныеВладельца[Владелец];
	
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьДанныеВладельцевИзБезопасногоХранилища(Владельцы, Ключи = "Пароль", ОбщиеДанные = Неопределено) Экспорт
	
	Результат = ДанныеИзБезопасногоХранилища(Владельцы, Ключи, ОбщиеДанные);
	
	Возврат Результат;
	
КонецФункции

Функция ДанныеИзБезопасногоХранилища(Владельцы, Ключи, ОбщиеДанные)
	
	Результат = Новый Соответствие();
	
	Возврат Результат;
КонецФункции

Процедура УдалитьЗадание(Знач Идентификатор) Экспорт
	
	Возврат;
	
КонецПроцедуры
