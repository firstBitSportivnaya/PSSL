﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПрефиксБаза = "база_";
	ПрефиксКод = "код_";
	
	Параметры.Свойство("ИмяФормыВладельца", ИмяФормыВладельца);
	
	Если Параметры.Свойство("АдресТаблицы", АдресТаблицы)
		И ЗначениеЗаполнено(АдресТаблицы) Тогда
		ОбработатьКонфликтныеЭлементы(АдресТаблицы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбработатьЭлементы Тогда
		ОбработатьПредопределенныеЭлементы();
		Оповестить("ОбновитьСписокПредопределенных");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбработатьЭлементы(Команда)
	
	ОбработатьЭлементы = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	ЗаполнитьОтметки(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	ЗаполнитьОтметки(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьКонфликтныеЭлементы(АдресТаблицы)
	
	ИсходнаяТаблица = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Поля = СоздатьПоляТаблицыКонфликтов(ИсходнаяТаблица);
	ЗаполнитьТаблицуКонфликтов(ИсходнаяТаблица, Поля);
	
КонецПроцедуры

&НаСервере
Функция СоздатьПоляТаблицыКонфликтов(Таблица)
	
	Поля = Новый СписокЗначений;
	
	ИсключаемыеПоля = пбп_ПредопределенныеЗначенияПереопределяемый.ИсключаемыеПоляДляРасчетаХешаЭлемент();
	
	ДобавляемыеРеквизиты = Новый Структура;
	Для Каждого Колонка Из Таблица.Колонки Цикл
		Если ИсключаемыеПоля.Свойство(Колонка.Имя)
			Или СтрНачинаетсяС(Колонка.Имя, "Служеб_") Тогда
			Продолжить;
		КонецЕсли;
		ДобавляемыеРеквизиты.Вставить(ПрефиксКод + Колонка.Имя, Колонка.ТипЗначения);
		ДобавляемыеРеквизиты.Вставить(ПрефиксБаза + Колонка.Имя, Колонка.ТипЗначения);
		Поля.Добавить(Колонка.Имя, Колонка.Имя);
	КонецЦикла;
	пбп_РаботаСФормами.СоздатьРеквизитыТаблицы(ЭтотОбъект, "ТаблицаКонфликтов", ДобавляемыеРеквизиты);
	
	Синонимы = Новый Структура;
	Для Каждого Реквизит Из ДобавляемыеРеквизиты Цикл
		Родитель = Элементы.ГруппаЭлементВКоде;
		Имя = СтрЗаменить(Реквизит.Ключ, ПрефиксКод, "");
		Если СтрНачинаетсяС(Реквизит.Ключ, ПрефиксБаза) Тогда
			Родитель = Элементы.ГруппаЭлементВБазе;
			Имя = СтрЗаменить(Имя, ПрефиксБаза, "");
		КонецЕсли;
		
		Синоним = "";
		Если Не Синонимы.Свойство(Имя, Синоним) Тогда
			Синоним = пбп_СтроковыеФункцииКлиентСервер.СинонимСтроки(Имя);
			Синонимы.Вставить(Имя, Синоним);
		КонецЕсли;
		
		Свойства = Новый Структура;
		Свойства.Вставить("Ширина", 5);
		Свойства.Вставить("ТолькоПросмотр", Истина);
		пбп_РаботаСФормами.СоздатьПоле(ЭтотОбъект, Реквизит.Ключ, Родитель, Синоним, 1,
			"ТаблицаКонфликтов." + Реквизит.Ключ, Свойства);
	КонецЦикла;
	
	Возврат Поля;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуКонфликтов(Таблица, Поля)
	
	Если ПустаяСтрока(ИмяФормыВладельца) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбъекта = пбп_ОбщегоНазначенияСлужебный.МенеджерОбъектаПоПолномуИмени(ИмяФормыВладельца);
	
	СписокПредопределенных = Таблица.ВыгрузитьКолонку("Служеб_ПредопределенныйЭлемент");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	пбп_ПредопределенныеЗначения.Ссылка КАК Ссылка
		|ИЗ
		|	%1 КАК пбп_ПредопределенныеЗначения
		|ГДЕ
		|	пбп_ПредопределенныеЗначения.Ссылка В(&СписокПредопределенных)";
	
	ПолноеИмя = Метаданные.НайтиПоТипу(ТипЗнч(МенеджерОбъекта)).ПолноеИмя();
	Запрос.Текст = СтрШаблон(Запрос.Текст, ПолноеИмя);
	Запрос.УстановитьПараметр("СписокПредопределенных", СписокПредопределенных);
	
	Запрос = пбп_СхемыЗапросов.ДобавитьПоляВыборкиВЗапрос(Запрос, Поля);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ОбщиеПоля = СтрСоединить(Поля.ВыгрузитьЗначения(), ",");
	БазоваяСтруктура = Новый Структура(ОбщиеПоля);
	Для Каждого Строка Из Таблица Цикл
		нСтрока = ТаблицаКонфликтов.Добавить();
		
		ЗаполнитьЗначенияСвойств(БазоваяСтруктура, Строка);
		Для Каждого КлючЗначение Из БазоваяСтруктура Цикл
			нСтрока[ПрефиксКод + КлючЗначение.Ключ] = КлючЗначение.Значение;
		КонецЦикла;
		
		Выборка.НайтиСледующий(Строка.Служеб_ПредопределенныйЭлемент, "Ссылка");
		ЗаполнитьЗначенияСвойств(БазоваяСтруктура, Выборка);
		Для Каждого КлючЗначение Из БазоваяСтруктура Цикл
			нСтрока[ПрефиксБаза + КлючЗначение.Ключ] = КлючЗначение.Значение;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПредопределенныеЭлементы()
	
	Если ПустаяСтрока(ИмяФормыВладельца) Тогда
		Возврат;
	КонецЕсли;
	
	ИдентификаторНастройки = "ИдентификаторНастройки";
	Таблица = ПолучитьИзВременногоХранилища(АдресТаблицы);
	
	Если Не ЗначениеЗаполнено(Таблица) Тогда
		Возврат;
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(АдресТаблицы);
	Таблица.Индексы.Добавить(ИдентификаторНастройки);
	Для Каждого Строка Из ТаблицаКонфликтов Цикл
		Стр = Таблица.Найти(Строка[ПрефиксКод + ИдентификаторНастройки], ИдентификаторНастройки);
		Если Строка.ЗаменитьЭлементомИзКода Тогда
			Стр.Служеб_ОбновитьЭлемент = Истина;
		Иначе
			Стр.Служеб_УстановитьФлагРучноеИзменение = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Менеджер = пбп_ОбщегоНазначенияСлужебный.МенеджерОбъектаПоПолномуИмени(ИмяФормыВладельца);
	ДопПараметры = пбп_ПредопределенныеЗначения.ДопПараметрыОбработкиПредопределенныхЭлементов(
		Таблица, Менеджер);
	пбп_ПредопределенныеЗначения.СоздатьОбновитьПредопределенныеЗначения(Таблица, ДопПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОтметки(ЗначениеОтметки)
	Модифицированность = Истина;
	Для Каждого Строка Из ТаблицаКонфликтов Цикл
		Строка.ЗаменитьЭлементомИзКода = ЗначениеОтметки;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
