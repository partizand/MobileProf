﻿
&НаСервере
Процедура ПоказатьВопрос()
	
	ТекущийВопрос = Параметры.ТекущийВопрос; // СсылкаВопрос;
	Ответ = Параметры.ВыбранныйОтвет;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВопросыИОтветы.Владелец,
	               |	ВопросыИОтветы.Владелец.Наименование КАК НаименованиеРаздела,
	               |	ВопросыИОтветы.Владелец.НомерРаздела КАК НомерРаздела,
	               |	ВопросыИОтветы.НомерВопроса,
	               |	ВопросыИОтветы.Вопрос,
	               |	ВопросыИОтветы.ХранилищеКартинки,
	               |	ВопросыИОтветы.Комментарий
	               |ИЗ
	               |	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	               |ГДЕ
	               |	ВопросыИОтветы.Ссылка = &Вопрос
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВопросыИОтветыОтветы.НомерОтвета КАК НомерОтвета,
	               |	ВопросыИОтветыОтветы.Ответ,
	               |	ВопросыИОтветыОтветы.ЭтоПравильный
	               |ИЗ
	               |	Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	               |ГДЕ
	               |	ВопросыИОтветыОтветы.Ссылка = &Вопрос
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерОтвета";
	
	Запрос.УстановитьПараметр("Вопрос", ТекущийВопрос);
	
	ПакетыЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаВопрос = ПакетыЗапроса[0].Выбрать();
	ВыборкаВопрос.Следующий();
	
	Раздел = Строка(ВыборкаВопрос.НомерРаздела) + ". " + ВыборкаВопрос.НаименованиеРаздела;
	Вопрос = Строка(ВыборкаВопрос.НомерРаздела) + "." + Строка(ВыборкаВопрос.НомерВопроса) + ". " + ВыборкаВопрос.Вопрос;
	ТекущийРаздел = ВыборкаВопрос.Владелец;
	
	НеОтвеченных = Параметры.НеОтвеченных;
	
	
	ДвоичныеДанныеКартинки = ВыборкаВопрос.ХранилищеКартинки.Получить();
	Если ДвоичныеДанныеКартинки = Неопределено или ДвоичныеДанныеКартинки.Размер() = 0 Тогда
		АдресКартинки = "";
		Элементы.Картинка.Видимость = Ложь;
	Иначе
		АдресКартинки = ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинки);
		Элементы.Картинка.Видимость = Истина;
	КонецЕсли;
	
	
	
	ВыборкаОтветы = ПакетыЗапроса[1].Выбрать();
	//
	//НайденныеСтроки = Отвеченные.НайтиСтроки(Новый Структура("Вопрос", ТекущийВопрос));
	//
	//Если НайденныеСтроки.Количество() = 0 Тогда
	//	ЕстьОтвеченный = Неопределено;
	//	Ответ = 0;
	//Иначе
	//	ЕстьОтвеченный = НайденныеСтроки[0];
	//	
	//КонецЕсли;
	
	Элементы.Комментарий.Видимость = (Параметры.ПоказатьОтвет) И ((НЕ ПустаяСтрока(ТекущийВопрос.Комментарий)));
	
	н = 1;
	
	Пока ВыборкаОтветы.Следующий() Цикл
		
		// Заполнить значения ответов
		ЭлОтвет = Элементы["Ответ" + Строка(н)];
		ЭлОтвет.Заголовок = Строка(ВыборкаОтветы.НомерОтвета) + ". " + ВыборкаОтветы.Ответ;
		ЭлОтвет.Видимость = Истина;
		ЭлОтвет.Шрифт = Новый Шрифт(ЭлОтвет.Шрифт,,,Ложь,,Ложь);
		
		ЭлФлажок = Элементы["Флажок" + Строка(н)];
		ЭлФлажок.Видимость = Истина;
		ЭлФлажок.Заголовок = Строка(ВыборкаОтветы.НомерОтвета);
		
		
		ЭтаФорма["Флажок" + Строка(н)] = Ложь;
		//ЭлФлажок = Ложь; //????
		
		// Если Ответ>0 поставить флажок
		Если Ответ = ВыборкаОтветы.НомерОтвета Тогда
			ЭтаФорма["Флажок" + Строка(н)] = Истина;
		КонецЕсли;
		
		// Если ПоказатьОтвет
		Если Параметры.ПоказатьОтвет Тогда
			// 	Заблокировать флажки
			ЭлФлажок.Доступность = Ложь;
			// 	Подчеркнуть правильный ответ
			Если ВыборкаОтветы.ЭтоПравильный Тогда
				ЭлОтвет.Шрифт = Новый Шрифт(ЭлОтвет.Шрифт,,,Истина,,Истина);
				// 	Если ответ=0 то поставить флажок на правильном ответе
				Если Ответ=0 Тогда
					ЭтаФорма["Флажок" + Строка(н)] = Истина;
				КонецЕсли;

			КонецЕсли;
						
		КонецЕсли;

		
		н = н + 1;
		
		
	КонецЦикла;
	
	Пока н <= 10 Цикл
		ЭтаФорма["Флажок" + Строка(н)] = Ложь;
		
		ЭлФлажок = Элементы["Флажок" + Строка(н)];
		ЭлФлажок.Видимость = Ложь;
		ЭлФлажок.Заголовок = "";
		
		ЭлОтвет = Элементы["Ответ" + Строка(н)];
		ЭлОтвет.Заголовок = "";		
		
		ЭлОтвет.Шрифт = Новый Шрифт(ЭлОтвет.Шрифт,,,Ложь,,Ложь);
		
		
		ЭлОтвет.Видимость = Ложь;
		
		н = н + 1;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура КомандаПредыдущий(Команда)
	// Вернуть Предыдущий	
	Возвр = Новый Структура ("Режим", "Предыдущий");
	Закрыть(Возвр);
	//Закрыть("Предыдущий");	 
	
	
КонецПроцедуры

&НаКлиенте
Процедура КомандСледующий(Команда)
	// Вернуть Следующий
	Возвр = Новый Структура ("Режим", "Следующий");
	Закрыть(Возвр);	 
КонецПроцедуры


&НаКлиенте
Процедура КомандаВыборРаздела(Команда)
	//КомандаВыборРазделаНаСервере();
	// Вернуть ВыборРаздела
	//Если ТестЗавершен Тогда
	//	ОткрытьФорму("Справочник.Разделы.ФормаВыбора", Новый Структура("ТекущаяСтрока, Ссылки", ТекущийРаздел, КомандаВыборРазделаНаСервере()),ЭтаФорма);
	//Иначе
	//	ОткрытьФорму("Справочник.Разделы.ФормаВыбора", Новый Структура("ТекущаяСтрока", ТекущийРаздел),ЭтаФорма);
	//КонецЕсли;
	 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	//ТекущийВопрос = Параметры.ТекущийВопрос;
	//Ответ = Параметры.ВыбранныйОтвет;
	//ПоказыватьРезультат = Параметры.Режим = Перечисления.РежимыОткрытияВопросов.ПоказатьОтвет;
	
	//Если ТекущийВопрос.Пустая() Тогда
	//
	//	Рез = ВыборВопроса("first");
	//	Тек = Рез.Ссылка;
	//Иначе
	//	Тек = ТекущийВопрос;
	//КонецЕсли;
	
	Если Параметры.ПоказатьОтвет Тогда
		Элементы.КомандаПоказатьПравильный.Видимость = Ложь;
		Элементы.КомандаОтветить.Видимость = Ложь;
	Иначе
		Элементы.КомандаПоказатьПравильный.Видимость = Истина;
		Элементы.КомандаОтветить.Видимость = Истина;

	КонецЕсли;
	
	Элементы.ФормаКомандаВыборРаздела.Видимость = Ложь;
	Элементы.ФормаКомандаВыборВопроса.Видимость = Ложь;
	
	
	
	ПоказатьВопрос();
	
	 
КонецПроцедуры

&НаКлиенте
//Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
//	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Разделы") Тогда
//		ТекущийРаздел = ВыбранноеЗначение;
//		Рез = ВыборВопроса("first");
//	
//		ПоказатьВопрос(Рез.Ссылка);
//	Иначе
//		ПоказатьВопрос(ВыбранноеЗначение);
//	КонецЕсли;
//КонецПроцедуры

&НаКлиенте
Процедура КартинкаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Файл = ПолучитьИмяВременногоФайла(".jpg");
	ПолучитьИзВременногоХранилища(АдресКартинки).Записать(Файл);
	ЗапуститьПриложение(Файл,,Истина);
	#Если МобильноеПриложениеКлиент или МобильноеПриложениеСервер Тогда
	УдалитьФайлы(Файл);
	#КонецЕсли
КонецПроцедуры

//&НаСервере
//Функция КомандаВыборВопросаНаСервере()
//	СписокСсылок = Новый СписокЗначений;
//	Запрос = Новый Запрос;
//	Запрос.УстановитьПараметр("Ссылки", Отвеченные.Выгрузить(,"Вопрос").ВыгрузитьКолонку("Вопрос"));
//	Запрос.УстановитьПараметр("Раздел", ТекущийРаздел);
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	ВопросыИОтветы.Ссылка
//	               |ИЗ
//	               |	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
//	               |ГДЕ
//	               |	ВопросыИОтветы.Ссылка В(&Ссылки)
//	               |	И ВопросыИОтветы.Владелец = &Раздел";
//	СписокСсылок.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
//	
//	Возврат СписокСсылок;
//КонецФункции

&НаКлиенте
Процедура КомандаВыборВопроса(Команда)
	// Вернуть ВыборВопроса
	//Если ТестЗавершен Тогда
	//	ОткрытьФорму("Справочник.ВопросыИОтветы.ФормаВыбора", Новый Структура("Владелец, ТекущаяСтрока, Ссылки", ТекущийРаздел, ТекущийВопрос, КомандаВыборВопросаНаСервере()),ЭтаФорма);
	//Иначе
	//	ОткрытьФорму("Справочник.ВопросыИОтветы.ФормаВыбора", Новый Структура("Владелец, ТекущаяСтрока", ТекущийРаздел, ТекущийВопрос),ЭтаФорма);
	//КонецЕсли;
КонецПроцедуры

//&НаКлиенте
//Процедура ПриЗакрытии()
//	ПриЗакрытииСервер1();
//КонецПроцедуры

//&НаСервереБезКонтекста
//Процедура ПриЗакрытииСервер1()
//	//РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("Подготовка.ТекущийРаздел", ТекущийРаздел);
//	//РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("Подготовка.ТекущийВопрос", ТекущийВопрос);
//КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	//Если ТестЗавершен или (Отвеченные.Количество() = 0 и Ответ = 0) Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//СтандартнаяОбработка = Ложь;
	//Если Вопрос("Завершить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
	//	Отказ = Истина;
	//Иначе
	//	Если НЕ КомандаЗавершитьНаСервере() Тогда
	//		Отказ = Истина;
	//		
	//		Если НЕ ПустаяСтрока(СтрРезультатТестирования) Тогда
	//			Сообщить(СтрРезультатТестирования);
	//		КонецЕсли;
	//		Элементы.КомандаОтветить.Доступность = Ложь;
	//		Элементы.КомандаПоказатьПравильный.Доступность = Ложь;
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

//&НаСервере
//Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
//	ТекНастр = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("ТестированиеПоРазделам.ТекущийРаздел");
//	ПоказыватьРезультат = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("ПоказыватьРезультат", Истина);
//	Если ТекНастр = Неопределено Тогда
//		ТекущийРаздел = Справочники.Разделы.ПустаяСсылка();
//	Иначе
//		ТекущийРаздел = ТекНастр;
//	КонецЕсли;
//	
//	ТекНастр = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("ТестированиеПоРазделам.ТекущийВопрос");
//	Если ТекНастр = Неопределено Тогда
//		ТекущийВопрос = Справочники.ВопросыИОтветы.ПустаяСсылка();
//	Иначе
//		ТекущийВопрос = ТекНастр;
//	КонецЕсли;
//КонецПроцедуры


&НаКлиенте
Процедура Флажок1ПриИзменении(Элемент)
	
	ТекНомерЭлемента = Число(СтрЗаменить(Элемент.Имя, "Флажок", ""));
	
	Ответ = Число(Элемент.Заголовок);
	
	Для н = 1 по 10 Цикл
		ЭтаФорма["Флажок" + Строка(н)] = н = ТекНомерЭлемента;
	КонецЦикла;
	
КонецПроцедуры

// Возврат Истина - если верный ответ
// Возврат Ложь - если ошибочный
//&НаСервере
//Функция КомандаОтветитьНаСервере(ПереходитьНаСледующий = Истина)
//	
//	Если Ответ = 0 Тогда
//		Возврат Ложь;
//	КонецЕсли;
//		
//	НайденныеСтроки = Отвеченные.НайтиСтроки(Новый Структура("Вопрос", ТекущийВопрос));
//	
//	Если НайденныеСтроки.Количество() = 0 Тогда
//		ТекСтр = Отвеченные.Добавить();
//		ТекСтр.Вопрос = ТекущийВопрос;
//		
//		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
//		                      |	ВопросыИОтветыОтветы.НомерОтвета
//		                      |ИЗ
//		                      |	Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
//		                      |ГДЕ
//		                      |	ВопросыИОтветыОтветы.Ссылка = &Ссылка
//		                      |	И ВопросыИОтветыОтветы.ЭтоПравильный");
//		Запрос.УстановитьПараметр("Ссылка", ТекущийВопрос);
//		Выборка = Запрос.Выполнить().Выбрать();
//		Если Выборка.Следующий() Тогда
//			ТекСтр.ПравильныйОтвет = Выборка.НомерОтвета;
//		КонецЕсли;
//		
//	Иначе
//		ТекСтр = НайденныеСтроки[0];
//	КонецЕсли;
//	
//	
//	ТекСтр.НомерОтвета = Ответ;
//	
//	ПравильностьОтвета = Ответ = ТекСтр.ПравильныйОтвет;

//	
//	Если ПереходитьНаСледующий Тогда
//		ПоказатьВопрос(ВыборВопроса("next").Ссылка);
//	КонецЕсли;
//	
//	Возврат ПравильностьОтвета;
//КонецФункции


&НаКлиенте
Процедура КомандаОтветить(Команда)
	Если Ответ = 0 Тогда
		Сообщить("Не выбран ответ!");
	Иначе
		// Вернуть Ответить
		//ПравильностьОтвета = КомандаОтветитьНаСервере();
		//Если ПоказыватьРезультат Тогда
		//	Если ПравильностьОтвета Тогда
		//		Сообщить("Правильно!");
		//	Иначе
		//		Сообщить("Неправильно!");
		//	КонецЕсли;
		//	
		//КонецЕсли;
		Правильный = РаботаСВопросами.ДобавитьОтвет(Параметры.ТекущийВопрос, Ответ);
		//Сообщение = Новый СообщениеПользователю();
		Если Правильный Тогда
			//Сообщение = Новый СообщениеПользователю();
			//Сообщение.Текст = "Правильно!";
			//Сообщение.Сообщить();
			//Сообщить("Правильно!");
			Возвр = Новый Структура ("Режим");
			Возвр.Режим = "Следующий";
			Закрыть(Возвр);
		Иначе
			//Сообщение = Новый СообщениеПользователю();
			//Сообщение.Текст = "Неправильно!";
			//Сообщение.Сообщить();
			//Сообщить("Неправильно!");
			Возвр = Новый Структура ("Режим");
			Возвр.Режим = "ПоказатьПравильный";
			Закрыть(Возвр);
		КонецЕсли;
			 
	КонецЕсли;
КонецПроцедуры


//&НаСервере
//Процедура КомандаПоказатьПравильныйНаСервере()
//	
//	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
//		                  |	ВопросыИОтветыОтветы.НомерОтвета
//	                      |ИЗ
//	                      |	Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
//	                      |ГДЕ
//	                      |	ВопросыИОтветыОтветы.Ссылка = &Ссылка
//	                      |	И ВопросыИОтветыОтветы.ЭтоПравильный");
//	Запрос.УстановитьПараметр("Ссылка", ТекущийВопрос);
//	Выборка = Запрос.Выполнить().Выбрать();
//	
//	БылаИспользованаПодсказка = Истина;
//	ПравильныйОтвет = 0;
//	
//	Если Выборка.Следующий() Тогда
//		ПравильныйОтвет = Выборка.НомерОтвета;
//	КонецЕсли;
//	
//	Если Ответ = ПравильныйОтвет Тогда
//		БылаИспользованаПодсказка = Ложь;
//	КонецЕсли;
//	
//	НайденныеСтроки = Отвеченные.НайтиСтроки(Новый Структура("Вопрос", ТекущийВопрос));
//	
//	Если НайденныеСтроки.Количество() = 0 Тогда
//		ТекСтр = Отвеченные.Добавить();
//		ТекСтр.Вопрос = ТекущийВопрос;
//		ТекСтр.ПравильныйОтвет = ПравильныйОтвет;
//		ТекСтр.БылаИспользованаПодсказка = БылаИспользованаПодсказка;
//	Иначе
//		ТекСтр = НайденныеСтроки[0];
//		Если НЕ ТекСтр.БылаИспользованаПодсказка Тогда
//			ТекСтр.БылаИспользованаПодсказка = БылаИспользованаПодсказка;
//		КонецЕсли;
//	КонецЕсли;
//	
//		
//КонецПроцедуры


&НаКлиенте
Процедура КомандаПоказатьПравильный(Команда)
	// Вернуть ПоказатьПодсказку
	Если Вопрос("Показать подсказку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		//КомандаПоказатьПравильныйНаСервере();
		 Элементы.Комментарий.Видимость=Истина;
	 КонецЕсли;
	
КонецПроцедуры


//&НаСервере
//Функция КомандаЗавершитьНаСервере()
//	Если Отвеченные.Количество() > 0 Тогда
//		ТекущийВопрос = Отвеченные[Отвеченные.Количество() - 1].Вопрос;
//		ТекущийРаздел = ТекущийВопрос.Владелец;
//	Иначе
//		Возврат Истина;
//	КонецЕсли;
//	
//	СтрСледВопрос = ВыборВопроса("next", Истина);
//	
//	Если СтрСледВопрос <> Неопределено Тогда
//		РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("ТестированиеПоРазделам.ТекущийРаздел", СтрСледВопрос.Ссылка.Владелец);
//		РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("ТестированиеПоРазделам.ТекущийВопрос", СтрСледВопрос.Ссылка);
//	КонецЕсли;
//	
//	Запрос = Новый Запрос;
//	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
//	Запрос.УстановитьПараметр("ТЗ", Отвеченные.Выгрузить());
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	ТЗ.Вопрос,
//	               |	ТЗ.НомерОтвета,
//	               |	ТЗ.ПравильныйОтвет,
//	               |	ТЗ.БылаИспользованаПодсказка
//	               |ПОМЕСТИТЬ ВТ
//	               |ИЗ
//	               |	&ТЗ КАК ТЗ
//	               |;
//	               |
//	               |////////////////////////////////////////////////////////////////////////////////
//	               |ВЫБРАТЬ
//	               |	ВЗ1.КоличествоПравильных,
//	               |	ВЗ2.КоличествоВсего,
//	               |	ВЫБОР
//	               |		КОГДА ВЗ2.КоличествоВсего = 0
//	               |			ТОГДА 0
//	               |		ИНАЧЕ ВЗ1.КоличествоПравильных / ВЗ2.КоличествоВсего * 100
//	               |	КОНЕЦ КАК Процент
//	               |ПОМЕСТИТЬ ВтРезультатТестирования
//	               |ИЗ
//	               |	(ВЫБРАТЬ
//	               |		КОЛИЧЕСТВО(ВТ.Вопрос) КАК КоличествоПравильных
//	               |	ИЗ
//	               |		ВТ КАК ВТ
//	               |	ГДЕ
//	               |		ВТ.НомерОтвета = ВТ.ПравильныйОтвет
//	               |		И НЕ ВТ.БылаИспользованаПодсказка) КАК ВЗ1
//	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
//	               |			КОЛИЧЕСТВО(ВТ.Вопрос) КАК КоличествоВсего
//	               |		ИЗ
//	               |			ВТ КАК ВТ) КАК ВЗ2
//	               |		ПО (ИСТИНА)
//	               |;
//	               |
//	               |////////////////////////////////////////////////////////////////////////////////
//	               |ВЫБРАТЬ
//	               |	ВТ.Вопрос,
//	               |	ВТ.НомерОтвета,
//	               |	ВТ.ПравильныйОтвет,
//	               |	ВТ.БылаИспользованаПодсказка
//	               |ИЗ
//	               |	ВТ КАК ВТ
//	               |
//	               |УПОРЯДОЧИТЬ ПО
//	               |	ВЫРАЗИТЬ(ВТ.Вопрос КАК Справочник.ВопросыИОтветы).Владелец.НомерРаздела,
//	               |	ВЫРАЗИТЬ(ВТ.Вопрос КАК Справочник.ВопросыИОтветы).НомерВопроса";
//	
//	Отвеченные.Загрузить(Запрос.Выполнить().Выгрузить());
//	
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	ВтРезультатТестирования.КоличествоПравильных,
//	               |	ВтРезультатТестирования.КоличествоВсего,
//	               |	ВтРезультатТестирования.Процент
//	               |ИЗ
//	               |	ВтРезультатТестирования КАК ВтРезультатТестирования";
//	Выборка = Запрос.Выполнить().Выбрать();
//	Выборка.Следующий();
//	СтрРезультатТестирования = "Ваш результат: " + Формат(Выборка.Процент, "ЧДЦ=; ЧН=0") + "% (" + Формат(Выборка.КоличествоПравильных, "ЧН=0") + " из " + Формат(Выборка.КоличествоВсего, "ЧН=0") + ")";
//	
//	НовыйДок = Документы.РезультатТестирования.СоздатьДокумент();
//	
//	НовыйДок.Дата = ТекущаяДата();
//	
//	
//	Для каждого ТекВопрос из Отвеченные Цикл
//		НовСтр = НовыйДок.Ответы.Добавить();
//		НовСтр.Вопрос = ТекВопрос.Вопрос;
//		НовСтр.НомерОтвета = ?(ТекВопрос.БылаИспользованаПодсказка, 0, ТекВопрос.НомерОтвета);
//	КонецЦикла;
//	
//	НовыйДок.Записать();
//	НовыйДок.Записать(РежимЗаписиДокумента.Проведение);
//	
//	
//	ТестЗавершен = Истина;

//	
//	СтрВыбора = ВыборВопроса("firstwrong");
//	
//	
//	
//	Если СтрВыбора = Неопределено Тогда
//		СтрВыбора = ВыборВопроса("first");
//		Элементы.КомандаПредыдущийНеправильный.Видимость = Ложь;
//		Элементы.КомандаСледующийНеправильный.Видимость = Ложь;
//	Иначе
//		Элементы.КомандаПредыдущийНеправильный.Видимость = Истина;
//		Элементы.КомандаСледующийНеправильный.Видимость = Истина;
//	КонецЕсли;
//	
//	ПоказатьВопрос(СтрВыбора.Ссылка);
//	Возврат Ложь;
//КонецФункции


&НаКлиенте
Процедура КомандаЗавершить(Команда)
	Если Вопрос("Завершить тестирование?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Возвр = Новый Структура ("Режим", "Завершить");
		Закрыть(Возвр);
	КонецЕсли;

		//Закрыть("Завершить");
КонецПроцедуры



&НаКлиенте
Процедура КомандаСледующийНеправильный(Команда)
	// Вернуть СледующийНеправильный
	//Рез = ВыборВопроса("nextwrong");
	//Если Рез.Очередь <> "nextwrong" Тогда
	//	Если Вопрос("Это последний неправильный ответ. Показать первый неправильный ответ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	//ПоказатьВопрос(Рез.Ссылка);
	 
КонецПроцедуры


&НаКлиенте
Процедура КомандаПредыдущийНеправильный(Команда)
	// Вернуть ПредыдущийНеправильный
	//Рез = ВыборВопроса("prevwrong");
	//Если Рез.Очередь <> "prevwrong" Тогда
	//	Если Вопрос("Это последний неправильный ответ. Показать первый неправильный ответ?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
	//		Возврат;
	//	КонецЕсли;
	//КонецЕсли;
	//ПоказатьВопрос(Рез.Ссылка);
	 
КонецПроцедуры

