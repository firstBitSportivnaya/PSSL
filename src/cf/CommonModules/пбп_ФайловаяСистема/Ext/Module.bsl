﻿// Библиотека проектных подсистем для упрощения разработки архитектуры на 1С: Предприятие 8,
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
// Файловая система: аналог модуля БСП

#Область ПрограммныйИнтерфейс

#Область МетодыАналогиБСП

// Аналог метода БСП. Удаляет временный файл.
// 
// Выбрасывает исключение, если передано имя не временного файла.
// 
// Если временный файл не может быть удален (например, он занят каким-то процессом),
// то в журнал регистрации записывается соответствующее предупреждение, а процедура завершается.
//
// Для совместного использования с методом ПолучитьИмяВременногоФайла, 
// после окончания работы с временным файлом.
//
// Параметры:
//   Путь - Строка - полный путь к временному файлу.
//
Процедура УдалитьВременныйФайл(Знач Путь) Экспорт
	
	Если НЕ ЭтоИмяВременногоФайла(Путь) Тогда
		ВызватьИсключение пбп_СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Неверное значение параметра %1 в %2:
				|Файл не является временным ""%3"".'"), 
			"Путь", "ФайловаяСистема.УдалитьВременныйФайл", Путь);
	КонецЕсли;
	
	УдалитьВременныеФайлы(Путь);
	
КонецПроцедуры

#Область ЗапускВнешнихПриложений

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции для работы с внешними приложениями.

// Аналог метода БСП. Конструктор параметров для ФайловаяСистема.ЗапуститьПрограмму.
//
// Возвращаемое значение:
//  Структура:
//    * ТекущийКаталог - Строка - задает текущий каталог запускаемого приложения.
//    * ДождатьсяЗавершения - Булево - Ложь - дожидаться завершения запущенного приложения 
//         перед продолжением работы.
//    * ПолучитьПотокВывода - Булево - Ложь - результат, направленный в поток stdout,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * ПолучитьПотокОшибок - Булево - Ложь - ошибки, направленные в поток stderr,
//         если не указан ДождатьсяЗавершения - игнорируется.
//    * КодировкаПотоков - КодировкаТекста
//                       - Строка - кодировка, используемая для чтения stdout и stderr.
//         По умолчанию используется для Windows "CP866", для остальных - "UTF-8".
//    * КодировкаИсполнения - Строка
//                          - Число - кодировка, устанавливаемая в Windows с помощью команды chcp,
//             возможные значения: "OEM", "CP866", "UTF8" или номер кодовой страницы.
//         В Linux устанавливается переменной окружения "LANGUAGE" для конкретной команды,
//             возможные значения можно определить выполнив команду "locale -a", например "ru_RU.UTF-8".
//         В MacOS игнорируется.
//
Функция ПараметрыЗапускаПрограммы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТекущийКаталог", "");
	Параметры.Вставить("ДождатьсяЗавершения", Ложь);
	Параметры.Вставить("ПолучитьПотокВывода", Ложь);
	Параметры.Вставить("ПолучитьПотокОшибок", Ложь);
	Параметры.Вставить("КодировкаПотоков", Неопределено);
	Параметры.Вставить("КодировкаИсполнения", Неопределено);
	
	Возврат Параметры;
	
КонецФункции

// Запускает внешнюю программу на исполнение (например, *.exe, *bat), 
// или системную команду (например, ping, tracert или traceroute, обращаться к rac-клиенту),
// Позволяет также получать код возврата и значения потоков вывода (stdout) и ошибок (stderr)
//
// При запуске внешней программы в пакетном режиме поток вывода и поток ошибок может возвращаться на не ожидаемом языке. 
// Для того чтобы передать внешней программе язык, на котором ожидается результат следует:
// - указать язык в параметре запуска этой программы (если такой параметр предусмотрен). 
//   Например, в пакетном режиме платформы 1С:Предприятие предусмотрен ключ "/L en";
// - в других случаях явно установить кодировку исполнения пакетной команды.
//   См. свойство КодировкаИсполнения возвращаемого значения ФайловаяСистема.ПараметрыЗапускаПрограммы. 
//
// Параметры:
//  КомандаЗапуска - Строка - командная строка для запуска программы.
//                 - Массив - первый элемент массива, путь к исполняемому приложению, 
//                            остальные элементы массива - это передаваемые параметры,
//                            массив соответствует тому, который получит вызываемая программа в argv.
//  ПараметрыЗапускаПрограммы - см. ФайловаяСистема.ПараметрыЗапускаПрограммы
//
// Возвращаемое значение:
//  Структура:
//    * КодВозврата - Число  - код возврата программы;
//    * ПотокВывода - Строка - результат работы программы, направленный в поток stdout;
//    * ПотокОшибок - Строка - ошибки исполнения программы, направленные в поток stderr.
//
// Пример:
//	// Простой запуск
//	ФайловаяСистема.ЗапуститьПрограмму("calc");
//	
//	// Запуск с ожиданием завершения
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ФайловаяСистема.ЗапуститьПрограмму("C:\Program Files\1cv8\common\1cestart.exe", 
//		ПараметрыЗапускаПрограммы);
//	
//	// Запуск с ожиданием завершения и получением потока вывода
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
//	Результат = ФайловаяСистема("ping 127.0.0.1 -n 5", ПараметрыЗапускаПрограммы);
//	ОбщегоНазначений.СообщитьПользователю(Результат.ПотокВывода);
//
//	// Запуск с ожиданием завершения и получением потока вывода и с конкатенацией команды запуска
//	ПараметрыЗапускаПрограммы = ФайловаяСистема.ПараметрыЗапускаПрограммы();
//	ПараметрыЗапускаПрограммы.ДождатьсяЗавершения = Истина;
//	ПараметрыЗапускаПрограммы.ПолучитьПотокВывода = Истина;
//	КомандаЗапуска = Новый Массив;
//	КомандаЗапуска.Добавить("ping");
//	КомандаЗапуска.Добавить("127.0.0.1");
//	КомандаЗапуска.Добавить("-n");
//	КомандаЗапуска.Добавить(5);
//	Результат = ФайловаяСистема.ЗапуститьПрограмму(КомандаЗапуска, ПараметрыЗапускаПрограммы);
//	ОбщегоНазначений.СообщитьПользователю(Результат.ПотокВывода);
//
Функция ЗапуститьПрограмму(Знач КомандаЗапуска, ПараметрыЗапускаПрограммы = Неопределено) Экспорт 
	
	// АПК:534-выкл методы безопасного запуска обеспечиваются этой функцией
	
	СтрокаКоманды = пбп_ОбщегоНазначенияСлужебныйКлиентСервер.БезопаснаяСтрокаКоманды(КомандаЗапуска);
	
	Если ПараметрыЗапускаПрограммы = Неопределено Тогда 
		ПараметрыЗапускаПрограммы = ПараметрыЗапускаПрограммы();
	КонецЕсли;
	
	ТекущийКаталог = ПараметрыЗапускаПрограммы.ТекущийКаталог;
	ДождатьсяЗавершения = ПараметрыЗапускаПрограммы.ДождатьсяЗавершения;
	ПолучитьПотокВывода = ПараметрыЗапускаПрограммы.ПолучитьПотокВывода;
	ПолучитьПотокОшибок = ПараметрыЗапускаПрограммы.ПолучитьПотокОшибок;
	КодировкаПотоков = ПараметрыЗапускаПрограммы.КодировкаПотоков;
	КодировкаИсполнения = ПараметрыЗапускаПрограммы.КодировкаИсполнения;
	
	ПроверитьТекущийКаталог(СтрокаКоманды, ТекущийКаталог);
	
	Если ДождатьсяЗавершения Тогда
		Если ПолучитьПотокВывода Тогда
			// BSLLS:MissingTemporaryFileDeletion-off
			ИмяФайлаПотокаВывода = ПолучитьИмяВременногоФайла("stdout.tmp");
			// BSLLS:MissingTemporaryFileDeletion-on
			СтрокаКоманды = СтрокаКоманды + " > """ + ИмяФайлаПотокаВывода + """";
		КонецЕсли;
		
		Если ПолучитьПотокОшибок Тогда
			// BSLLS:MissingTemporaryFileDeletion-off
			ИмяФайлаПотокаОшибок = ПолучитьИмяВременногоФайла("stderr.tmp");
			// BSLLS:MissingTemporaryFileDeletion-on
			СтрокаКоманды = СтрокаКоманды + " 2>""" + ИмяФайлаПотокаОшибок + """";
		КонецЕсли;
	КонецЕсли;
	
	Если КодировкаПотоков = Неопределено Тогда
		КодировкаПотоков = КодировкаСтандартныхПотоков();
	КонецЕсли;
	
	// Для cmd не всегда активна текущая кодовая страница, поэтому всегда задаем по-умолчанию.
	Если КодировкаИсполнения = Неопределено И пбп_ОбщегоНазначенияСлужебный.ЭтоWindowsСервер() Тогда
		КодировкаИсполнения = "CP866";
	КонецЕсли;
	
	КодВозврата = Неопределено;
	
	Если пбп_ОбщегоНазначенияСлужебный.ЭтоWindowsСервер() Тогда
		
		СтрокаКоманды = пбп_ОбщегоНазначенияСлужебныйКлиентСервер.СтрокаЗапускаКомандыWindows(
			СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодировкаИсполнения);
		
		Если пбп_ОбщегоНазначенияСлужебный.ИнформационнаяБазаФайловая() Тогда
			// В файловой информационной базе показывать окно консоли не следует и в серверном контексте.
			Оболочка = Новый COMОбъект("Wscript.Shell");
			КодВозврата = Оболочка.Run(СтрокаКоманды, 0, ДождатьсяЗавершения);
			Оболочка = Неопределено;
		Иначе
			// BSLLS:ExternalAppStarting-off
			ЗапуститьПриложение(СтрокаКоманды, , ДождатьсяЗавершения, КодВозврата);
			// BSLLS:ExternalAppStarting-on
		КонецЕсли;
		
	Иначе
		
		Если пбп_ОбщегоНазначенияСлужебный.ЭтоLinuxСервер() И ЗначениеЗаполнено(КодировкаИсполнения) Тогда
			СтрокаКоманды = "LANGUAGE=" + КодировкаИсполнения + " " + СтрокаКоманды;
		КонецЕсли;
		
		// BSLLS:ExternalAppStarting-off
		ЗапуститьПриложение(СтрокаКоманды, ТекущийКаталог, ДождатьсяЗавершения, КодВозврата);
		// BSLLS:ExternalAppStarting-on
	КонецЕсли;
	
	ПотокВывода = "";
	ПотокОшибок = "";
	
	Если ДождатьсяЗавершения Тогда
		Если ПолучитьПотокВывода Тогда
			ПотокВывода = ПрочитатьФайлЕслиСуществует(ИмяФайлаПотокаВывода, КодировкаПотоков);
			УдалитьВременныйФайл(ИмяФайлаПотокаВывода);
		КонецЕсли;
		
		Если ПолучитьПотокОшибок Тогда 
			ПотокОшибок = ПрочитатьФайлЕслиСуществует(ИмяФайлаПотокаОшибок, КодировкаПотоков);
			УдалитьВременныйФайл(ИмяФайлаПотокаОшибок);
		КонецЕсли;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КодВозврата", КодВозврата);
	Результат.Вставить("ПотокВывода", ПотокВывода);
	Результат.Вставить("ПотокОшибок", ПотокОшибок);
	
	Возврат Результат;
	
	// АПК:534-вкл
	
КонецФункции

#КонецОбласти

#КонецОбласти // МетодыАналогиБСП

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Аналог метода БСП.
Процедура УдалитьВременныеФайлы(Знач Путь)
	
	Попытка
		УдалитьФайлы(Путь);
	Исключение
		пбп_ЖурналРегистрацииСлужебный.ДобавитьСообщениеДляЖурналаРегистрации(
			НСтр("ru = 'Стандартные подсистемы'", пбп_ОбщегоНазначенияСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка, , ,
			пбп_СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось удалить временный файл ""%1"" по причине:
					|%2'"),
				Путь,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())));
	КонецПопытки;
	
КонецПроцедуры

// Аналог метода БСП.
Функция ЭтоИмяВременногоФайла(Путь)
	
	// Ожидается, что Путь получен методом ПолучитьИмяВременногоФайла().
	// Перед проверкой разворачиваем слэши в одну сторону.
	Возврат СтрНачинаетсяС(СтрЗаменить(Путь, "/", "\"), СтрЗаменить(КаталогВременныхФайлов(), "/", "\"));
	
КонецФункции

#Область ЗапуститьПрограмму

// Аналог метода БСП.
Процедура ПроверитьТекущийКаталог(СтрокаКоманды, ТекущийКаталог)
	
	Если Не ПустаяСтрока(ТекущийКаталог) Тогда 
		
		ФайлИнфо = Новый Файл(ТекущийКаталог);
		
		Если Не ФайлИнфо.Существует() Тогда
			ВызватьИсключение пбп_СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить программу
				           |%1
				           |по причине:
				           |Не существует каталог %2
				           |%3'"),
				СтрокаКоманды, "ТекущийКаталог", ТекущийКаталог);
		КонецЕсли;
		
		Если Не ФайлИнфо.ЭтоКаталог() Тогда 
			ВызватьИсключение пбп_СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось запустить программу
				           |%1
				           |по причине:
				           |%2 не является каталогом 
				           |%3'"),
				СтрокаКоманды, "ТекущийКаталог", ТекущийКаталог);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Аналог метода БСП.
Функция ПрочитатьФайлЕслиСуществует(Путь, Кодировка)
	
	Результат = Неопределено;
	ФайлИнфо = Новый Файл(Путь);
	
	Если ФайлИнфо.Существует() Тогда 
		
		ЧтениеПотокаОшибок = Новый ЧтениеТекста(Путь, Кодировка);
		Результат = ЧтениеПотокаОшибок.Прочитать();
		ЧтениеПотокаОшибок.Закрыть();
		
	КонецЕсли;
	
	Если Результат = Неопределено Тогда 
		Результат = "";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// // Аналог метода БСП. Возвращает кодировку стандартных поток вывода и ошибок, используемую в текущей ОС.
//
// Возвращаемое значение:
//  КодировкаТекста
//
Функция КодировкаСтандартныхПотоков()
	
	Если пбп_ОбщегоНазначенияСлужебный.ЭтоWindowsСервер() Тогда
		Кодировка = "CP866";
	Иначе
		Кодировка = "UTF-8";
	КонецЕсли;
	
	Возврат Кодировка;
	
КонецФункции

#КонецОбласти

#КонецОбласти