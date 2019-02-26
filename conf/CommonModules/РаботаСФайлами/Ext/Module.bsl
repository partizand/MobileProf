﻿Функция АдресВопросовПоУмолчанию() Экспорт
	Возврат "https://raw.githubusercontent.com/partizand/MobileProf/master/q.xml";	
КонецФункции


Функция ПолучитьФайлССервера(ПолныйАдресРесурса) 
	
	СтруктураURI = СтруктураURI(ПолныйАдресРесурса);
	
	
	Если СтруктураURI.Схема = "http" Тогда
		ЗащСоединение = Неопределено;
	Иначе
		ЗащСоединение = Новый ЗащищенноеСоединениеOpenSSL(); 
	КонецЕсли;
	
	Попытка	
			Соединение = Новый HTTPСоединение( СтруктураURI.Хост,СтруктураURI.Порт,,,,,ЗащСоединение,);
    Исключение
        Сообщить("Нет соединения");
        Возврат Неопределено;
    КонецПопытки;
 
	
	ИмяФайлаОтвета = ПолучитьИмяВременногоФайла();

	Попытка
		Соединение.Получить(СтруктураURI.ПутьНаСервере,ИмяФайлаОтвета);
	Исключение
		 // исключение здесь говорит о том, что запрос не дошел до HTTP-Сервера
		 Сообщить("Произошла сетевая ошибка!");
		 //ВызватьИсключение;
		 Возврат Неопределено;
	 КонецПопытки;
 
    ФайлОтвета = Новый Файл(ИмяФайлаОтвета);
    Если ФайлОтвета.Существует() Тогда
		Возврат ИмяФайлаОтвета;
		
    Иначе
        Сообщить("не получилось получить данные");
        Возврат Неопределено;
    КонецЕсли;	
КонецФункции

Процедура ОтправитьФайлНаСервер(ПолныйАдресРесурса, ИмяФайлаОтправки)
	СтруктураURI = СтруктураURI(ПолныйАдресРесурса);
	
	
	
	Попытка
        Соединение = Новый HTTPСоединение(СтруктураURI.Хост,СтруктураURI.Порт,,,,,);
		
		HTTPЗапрос = Новый HTTPЗапрос(СтруктураURI.ПутьНаСервере);
    	HTTPЗапрос.УстановитьИмяФайлаТела(ИмяФайлаОтправки);
	    Результат  = Соединение.ОтправитьДляОбработки(HTTPЗапрос );
	    Соединение = Неопределено;
	
		//Соединение.ОтправитьДляОбработки(ИмяФайлаОтправки, СтруктураURI.ПутьНаСервере, имяВыходногоФайла); Получить(СтруктураURI.ПутьНаСервере,ИмяФайлаОтвета);
		
		Сообщить("Файл отправлен на сервер");
		
	Исключение
        Сообщить("Нет соединения");
        
    КонецПопытки;

КонецПроцедуры

Процедура ВыгрузитьВопросыВФайл(ИмяФайла) Экспорт
	Если ИмяФайлаЭтоВеб(ИмяФайла) Тогда
		ВременноеИмяФайла = ПолучитьИмяВременногоФайла("xml");
		ВыгрузитьВопросыВXML(ВременноеИмяФайла);
		ОтправитьФайлНаСервер(ИмяФайла, ВременноеИмяФайла);
		УдалитьФайлы(ВременноеИмяФайла);
		
	Иначе
		ВыгрузитьВопросыВXML(ИмяФайла);
	
	КонецЕсли
	
	
КонецПроцедуры


Процедура ВыгрузитьВопросыВXML(ИмяФайла)
	//РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("ПутьКФайлу", ПутьКФайлу) ;
	Запись = Новый ЗаписьXML;
	Запись.ОткрытьФайл(ИмяФайла, "UTF-8");
	Запись.ЗаписатьОбъявлениеXML();
	ВыборкаРазделы = Справочники.Разделы.Выбрать();
	Запись.ЗаписатьНачалоЭлемента("OBJECTS");
	Пока ВыборкаРазделы.Следующий() Цикл
		ЗаписатьXML(Запись, ВыборкаРазделы.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	
	ВыборкаВопросы = Справочники.ВопросыИОтветы.Выбрать();
	Пока ВыборкаВопросы.Следующий() Цикл
		ЗаписатьXML(Запись, ВыборкаВопросы.Ссылка.ПолучитьОбъект());
	КонецЦикла;
	
	Запись.ЗаписатьКонецЭлемента();//OBJECTS
	Запись.Закрыть();
	//Сообщить("Выгружено! Файл "+ПутьКФайлу);
КонецПроцедуры

Функция ИмяФайлаЭтоВеб(ИмяФайла)
	Веб =  "http://";
	Веб2 = "https://";
	
	ПозВеб=НАйти(ИмяФайла, Веб);
	Если ПозВеб=1 Тогда
		Возврат Истина;		
	ИначеЕсли НАйти(ИмяФайла, Веб2) Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;

КонецФункции

// Загрузка вопросов из текстового файла
// Написано для загрузки вопросов УТ
Процедура ЗагрузитьВопросы(ИмяФайла) Экспорт
	
	// Удаляем все к херам
	 ОчиститьВсе();
	
	// Файл выглядит так
	
	// Управление торговлей 
	//01.Подготовительный этап
	//01.01 Каким образом можно заполнить информационную базу имеющимися данными?
	//1. Только вручную, регистрируя все документы, подтверждающие торговые операции за все время существования компании
	//2. Переносом данных из торговых программ предыдущих редакций ("1С:Торговля и склад 7.7" и "1С:Управление торговлей", редакция 10.3)
	//3. Вручную при помощи документа "Ввод начальных остатков"
	//4. Верны утверждения 2 и 3
	//01.02 Каким образом определяется использование мультивалютного учета на предприятии?
	//1. Ведение мультивалютного учета доступно по умолчанию и не требует дополнительной настройки
	//2. В программе возможно ведение учета лишь в одной валюте – рублях
	//3. Регулируется функциональной опцией "Несколько валют"
	//4. Регулируется функциональной опцией "Мультивалютный учет"
	//01.03 Как можно заполнить справочник "Валюты"?
	//1. Вручную при помощи команды "Создать"
	//2. Подбором из Общероссийского классификатора валют (ОКВ)
	//3. Верны утверждения 1 и 2
	//4. Справочник поставляется уже заполненным в соответствии с ОКВ
	//01.04 Новый курс валюты…
	//1. Вводится вручную
	//2. Загружается из Интернета
	//3. Рассчитывается по формуле
	//4. Зависит от курса другой валюты
	//5. Все вышеперечисленное
	//6. Верны утверждения 1,2 и 4
	
	// Число.Текст - раздел
	// Число.Число Текст - вопрос
	// Число. Текст - ответ
	
	// хх.Х - Раздел
	// хх.хх[пробел] - Вопрос
	// х.[пробел] - Ответ
	
	// Точка во втором символе - ответ
	// точка в третьем символе, пробел в шестом - вопрос
	// иначе - раздел
	
	ТекущийРаздел=Неопределено;
	ТекущийВопрос=Неопределено;
	ТекущийНомерОтвета=1;
	ТекущийНомерВопроса = 1;
	
	СодержимоеФайла = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.ANSI);
	СтрокаФайла = СодержимоеФайла.ПрочитатьСтроку();
	Пока СтрокаФайла <> Неопределено Цикл // строки читаются до символа перевода строки

		ПозТочка = СтрНайти(СтрокаФайла, ".");
		
		ПозПробел = СтрНайти(СтрокаФайла, " ");
		
		Если ПозТочка>0 Тогда
			
			Если ПозТочка=2 Тогда // Это ответ
				
				Если ТекущийВопрос <> Неопределено Тогда
					
					// После пробела
					СтрНаименование = Прав(СтрокаФайла, СтрДлина(СтрокаФайла)- ПозПробел);
					
					НовыйОтвет = ТекущийВопрос.Ответы.Добавить();
					НовыйОтвет.НомерОтвета = ТекущийНомерОтвета;
					НовыйОтвет.Ответ = СтрНаименование;
					
					ТекущийНомерОтвета = ТекущийНомерОтвета + 1; 
				
				КонецЕсли; 
			
			ИначеЕсли ПозТочка=3 Тогда // Это раздел или впорос
				// 
				Если ПозПробел=6 Тогда // Это вопрос
					
					// Номер вопроса между . и пробелом, текст после пробела
					СтрНомер = Сред(СтрокаФайла, ПозТочка+1, ПозПробел-ПозТочка);
					СтрНаименование = Прав(СтрокаФайла, СтрДлина(СтрокаФайла)- ПозПробел);
					
					// Записать предыдущее
					Если ТекущийВопрос <> Неопределено Тогда
						ТекущийВопрос.Записать();	
					КонецЕсли; 
					
					ТекущийНомерОтвета = 1;
					Если ТекущийРаздел <> Неопределено Тогда
					
						ТекущийВопрос = Справочники.ВопросыИОтветы.СоздатьЭлемент();
						ТекущийВопрос.Наименование = СтрНаименование;
						ТекущийВопрос.Вопрос = СтрНаименование;
						ТекущийВопрос.НомерВопроса = СтрНомер;
						ТекущийВопрос.Владелец = ТекущийРаздел;
						//ТекущийВопрос.Записать();
						ТекущийНомерВопроса = ТекущийНомерВопроса + 1;
					
					КонецЕсли; 
					
				
				Иначе // Раздел	
					
					// Номер до точки, название после
					СтрНомер = Лев(СтрокаФайла, ПозТочка-1);
					СтрНаименование = Прав(СтрокаФайла, СтрДлина(СтрокаФайла)- ПозТочка);
					ТекущийНомерВопроса = 1;
					
					НовыйРаздел = Справочники.Разделы.СоздатьЭлемент();
					НовыйРаздел.Наименование = СтрНаименование;
					НовыйРаздел.НомерРаздела = СтрНомер;
					НовыйРаздел.Записать();
					
					ТекущийРаздел = НовыйРаздел.Ссылка;
					
				КонецЕсли; 
			
			КонецЕсли; 
			
		
		
			
		
		КонецЕсли; 
		
	    СтрокаФайла = СодержимоеФайла.ПрочитатьСтроку();
	КонецЦикла;

	// Записать предыдущее
	Если ТекущийВопрос <> Неопределено Тогда
		ТекущийВопрос.Записать();	
	КонецЕсли; 
	

КонецПроцедуры
 


// Загружает вопросы из файла или веб
Процедура ЗагрузитьВопросыИзФайла(ИмяФайла, ОчиститьИсторию) Экспорт
	
		
	Если ИмяФайлаЭтоВеб(ИмяФайла) Тогда
		// http
		ИмяДляЗагрузки=ПолучитьФайлССервера(ИмяФайла);
		УдалятьФайл=Истина;
		Если ПустаяСтрока(ИмяДляЗагрузки) Тогда
			Возврат;
		КонецЕсли
		
	Иначе
		ИмяДляЗагрузки = ИмяФайла;
		УдалятьФайл=Ложь;
	КонецЕсли;
		
	Если ОчиститьИсторию Тогда
		ОчиститьВсе();
	КонецЕсли;
	
	ЗагрузитьВопросыИзXML(ИмяДляЗагрузки);
	
	Если УдалятьФайл Тогда
		УдалитьФайлы(ИмяДляЗагрузки);
	КонецЕсли;
	
КонецПроцедуры


// <Описание процедуры>
Процедура ЗагрузитьВопросыИзМакета() Экспорт

	   //ПолучитьМакет
	//Двоичные = ПолучитьОбщийМакет("Загрузка");
	//ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	//Двоичные.Записать(ИмяФайла);
	//
	//ЗагрузитьВопросыИзXML(ИмяФайла);
	//
	//УдалитьФайлы(ИмяФайла);

КонецПроцедуры 


Процедура ЗагрузитьВопросыИзXML(ИмяФайла) 
	
	
	//Если ПустаяСтрока(ИмяФайла) Тогда
	//	
	//	Сообщить("Укажите путь к файлу");
	//	Возврат;
	//КонецЕсли;
	
	ФайлПроверка = Новый Файл(ИмяФайла);
    Если НЕ ФайлПроверка.Существует() Тогда
		Сообщить("Файл не найден");
		Возврат;
    КонецЕсли;
	    
	Чтение = Новый ЧтениеXML;
	Чтение.ОткрытьФайл(ИмяФайла);
	н = 0;                                                                                                    
	Чтение.Прочитать();
	Чтение.Прочитать();
	
	ФлагКонец = Ложь;
	
	//ОчиститьВсе();
	
	//Попытки = 1;
	
	Пока НЕ ФлагКонец Цикл
		Попытка
			ТекОбъект = ПрочитатьXML(Чтение);
			ТипЗнчОбъект = ТипЗнч(ТекОбъект);
			//Сообщить(Строка(н) + " " + ТипЗнчОбъект);
			Если ТипЗнчОбъект = Тип("СправочникОбъект.Разделы") или ТипЗнчОбъект = Тип("СправочникОбъект.ВопросыИОтветы") Тогда
				ТекОбъект.Записать();
				
				Если ТипЗнчОбъект = Тип("СправочникОбъект.ВопросыИОтветы") Тогда
					н = н + 1;
				КонецЕсли;
			КонецЕсли;
		Исключение
			ФлагКонец = Истина;
		КонецПопытки;
		
	КонецЦикла;
	Чтение.Закрыть();
	Сообщить("Успешно прочитано " + Строка(н) + " вопросов!");
	
	
	
КонецПроцедуры

// Очистка всех вопросов и результатов тестирования
Процедура ОчиститьВсе() 
	
	Выборка = Справочники.Разделы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Об1 = Выборка.ПолучитьОбъект();
		Об1.Удалить();
	КонецЦикла;
	
	Выборка = Справочники.ВопросыИОтветы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Об1 = Выборка.ПолучитьОбъект();
		Об1.Удалить();
	КонецЦикла;
	
	
	Выборка = Документы.РезультатТестирования.Выбрать();
	Пока Выборка.Следующий() Цикл
		Об1 = Выборка.ПолучитьОбъект();
		Об1.Удалить();
	КонецЦикла;
КонецПроцедуры


// Определяет это файл на компе или на веб
// Возвращает структуру с описанием
Функция РазобратьИмяФайла(ИмяФайла)
	
	СтрВозврат=Новый Структура;
	
	Веб =  "http://";
	
	ПозВеб=НАйти(ИмяФайла, Веб);
	Если ПозВеб=1 Тогда
		// http
		
		// Получаем адрес сервера и путь к файлу
		БезНачала=СтрЗаменить(ИмяФайла,Веб,"");
		ПозРазд = Найти(БезНачала, "/");
		ИмяСервера = Лев(БезНачала, ПозРазд-1);
		ФайлНаСервере = Прав(БезНачала, СтрДлина(БезНачала)-ПозРазд);
		
		СтрВозврат.Вставить("Тип", "Веб");
		СтрВозврат.Вставить("Сервер", ИмяСервера);
		СтрВозврат.Вставить("ИмяФайла", ФайлНаСервере);
		
		
	Иначе
		// Просто файл
		СтрВозврат.Вставить("Тип", "Файл");
		СтрВозврат.Вставить("ИмяФайла", ИмяФайла);
	КонецЕсли;
	
	Возврат СтрВозврат;
	
КонецФункции

Функция СтруктураURI(Знач СтрокаURI) Экспорт
	
	СтрокаURI = СокрЛП(СтрокаURI);
	
	// схема
	Схема = "";
	Позиция = Найти(СтрокаURI, "://");
	Если Позиция > 0 Тогда
		Схема = НРег(Лев(СтрокаURI, Позиция - 1));
		СтрокаURI = Сред(СтрокаURI, Позиция + 3);
	КонецЕсли;

	// строка соединения и путь на сервере
	СтрокаСоединения = СтрокаURI;
	ПутьНаСервере = "";
	Позиция = Найти(СтрокаСоединения, "/");
	Если Позиция > 0 Тогда
		ПутьНаСервере = Сред(СтрокаСоединения, Позиция + 1);
		СтрокаСоединения = Лев(СтрокаСоединения, Позиция - 1);
	КонецЕсли;
		
	// информация пользователя и имя сервера
	СтрокаАвторизации = "";
	ИмяСервера = СтрокаСоединения;
	Позиция = Найти(СтрокаСоединения, "@");
	Если Позиция > 0 Тогда
		СтрокаАвторизации = Лев(СтрокаСоединения, Позиция - 1);
		ИмяСервера = Сред(СтрокаСоединения, Позиция + 1);
	КонецЕсли;
	
	// логин и пароль
	Логин = СтрокаАвторизации;
	Пароль = "";
	Позиция = Найти(СтрокаАвторизации, ":");
	Если Позиция > 0 Тогда
		Логин = Лев(СтрокаАвторизации, Позиция - 1);
		Пароль = Сред(СтрокаАвторизации, Позиция + 1);
	КонецЕсли;
	
	// хост и порт
	Хост = ИмяСервера;
	Порт = "";
	Позиция = Найти(ИмяСервера, ":");
	Если Позиция > 0 Тогда
		Хост = Лев(ИмяСервера, Позиция - 1);
		Порт = Сред(ИмяСервера, Позиция + 1);
	КонецЕсли;
	
	Если ПустаяСтрока(Порт) И Схема = "https" Тогда
		Порт="443";
	КонецЕсли;

	
	Результат = Новый Структура;
	Результат.Вставить("Схема", Схема);
	Результат.Вставить("Логин", Логин);
	Результат.Вставить("Пароль", Пароль);
	Результат.Вставить("ИмяСервера", ИмяСервера);
	Результат.Вставить("Хост", Хост);
	Результат.Вставить("Порт", ?(Порт <> "", Число(Порт), Неопределено));
	Результат.Вставить("ПутьНаСервере", ПутьНаСервере);
	
	Возврат Результат;
	
КонецФункции





	



