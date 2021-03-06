﻿Функция СледующийРаздел(РазделСсылка) Экспорт
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Разделы.Ссылка,
		|	Разделы.НомерРаздела
		|ПОМЕСТИТЬ РазделыСорт
		|ИЗ
		|	Справочник.Разделы КАК Разделы
		|ГДЕ
		|	Разделы.ПометкаУдаления = ЛОЖЬ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РазделыСорт.Ссылка КАК Раздел,
		|	РазделыСорт.НомерРаздела КАК НомерРаздела
		|ИЗ
		|	РазделыСорт КАК РазделыСорт
		|ГДЕ
		|	РазделыСорт.НомерРаздела > &НомерРаздела
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	РазделыСорт.Ссылка,
		|	РазделыСорт.НомерРаздела
		|ИЗ
		|	РазделыСорт КАК РазделыСорт";
	
	Запрос.УстановитьПараметр("НомерРаздела", РазделСсылка.НомерРаздела);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Раздел;
	КонецЦикла;
	
	Возврат Справочники.Разделы.ПустаяСсылка();
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции



Функция СледующийВопрос(ТекущийВопрос, Вперед=Истина) 
	
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВопросыИОтветы.Владелец КАК ТекущийРаздел
		|ПОМЕСТИТЬ ВТ
		|ИЗ
		|	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
		|ГДЕ
		|	ВопросыИОтветы.Ссылка = &ТекущийВопрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВопросыИОтветы.Ссылка КАК Следующий
		|ИЗ
		|	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ КАК ВТ
		|		ПО ВопросыИОтветы.Владелец = ВТ.ТекущийРаздел
		|ГДЕ
		|	ВопросыИОтветы.Ссылка > &ТекущийВопрос
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВопросыИОтветы.НомерВопроса УБЫВ";
	
	Если Не Вперед Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, ">", "<");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "УБЫВ", "");
	КонецЕсли;
	
	
	Запрос.УстановитьПараметр("ТекущийВопрос", ТекущийВопрос);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Следующий;
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
	Возврат КрайнийВопрос(ТекущийВопрос.Владелец, Вперед);
	
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
КонецФункции


Функция КрайнийВопрос(ТекущийРаздел, Первый=Истина) 
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВопросыИОтветы.Ссылка КАК Первый
		|ИЗ
		|	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
		|ГДЕ
		|	ВопросыИОтветы.Владелец = &ТекущийРаздел
		|
		|УПОРЯДОЧИТЬ ПО
		|	ВопросыИОтветы.НомерВопроса УБЫВ";
	
	Если Первый Тогда
		Запрос.Текст = СтрЗаменить (Запрос.Текст,"УБЫВ", "");
	КонецЕсли;
	
	
	
	Запрос.УстановитьПараметр("ТекущийРаздел", ТекущийРаздел);
	//Запрос.УстановитьПараметр("
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Первый;
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
КонецФункции

Функция ПолучитьСсылкуНаВопрос(НомерРаздела, НомерВопроса)  
	// Вставить содержимое обработчика.
	 
	
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВопросыИОтветы.Ссылка КАК Вопрос,
	|	Разделы.Ссылка КАК Раздел
	|ИЗ
	|	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Разделы КАК Разделы
	|		ПО ВопросыИОтветы.Владелец = Разделы.Ссылка
	|ГДЕ
	|	Разделы.НомерРаздела = &НомерРаздела
	|	И ВопросыИОтветы.НомерВопроса = &НомерВопроса";
	
	Запрос.УстановитьПараметр("НомерРаздела", НомерРаздела);
	Запрос.УстановитьПараметр("НомерВопроса", НомерВопроса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекущийВопрос = ВыборкаДетальныеЗаписи.Вопрос;
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
	КонецЦикла;
	
	Возврат ТекущийВопрос;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
		
	
КонецФункции

Функция ДобавитьВопрос(Вопрос)
	НовЗапись = Справочники.ТекущиеОтветы.СоздатьЭлемент();
	НовЗапись.Вопрос = Вопрос;
	НовЗапись.Ответ = 0;
	НовЗапись.Записать();
	
КонецФункции


Функция ДобавитьОтвет(Вопрос, Ответ) Экспорт
	
	ПравильныйОтвет = ПолучитьПравильныйОтвет(Вопрос);
	
	НайденныйВопрос = Справочники.ТекущиеОтветы.НайтиПоРеквизиту("Вопрос", Вопрос);
	
	Правильный = Ответ = ПравильныйОтвет;
	
	Если НайденныйВопрос = Справочники.ТекущиеОтветы.ПустаяСсылка() Тогда
	
		НовыйЭлемент = Справочники.ТекущиеОтветы.СоздатьЭлемент();
		НовыйЭлемент.Вопрос = Вопрос;
		НовыйЭлемент.Ответ = Ответ;
		НовыйЭлемент.Правильный = Правильный;
		НовыйЭлемент.Записать();
	Иначе
		Об = НайденныйВопрос.ПолучитьОбъект();
		Об.Ответ = Ответ;
		Об.Правильный = Правильный;
		Об.Записать();
		//НайденныйВопрос. .Ответ = Ответ;
	КонецЕсли;
	
	Возврат Правильный;
	
	
КонецФункции

Функция ПолучитьОтвет(Вопрос) Экспорт
	НайденныйВопрос = Справочники.ТекущиеОтветы.НайтиПоРеквизиту("Вопрос", Вопрос);
	
	Если НайденныйВопрос = Справочники.ТекущиеОтветы.ПустаяСсылка() Тогда
	
		Возврат 0;
	Иначе
		Возврат НайденныйВопрос.Ответ;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПравильныйОтвет(Вопрос) 
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		                      |	ВопросыИОтветыОтветы.НомерОтвета
		                      |ИЗ
		                      |	Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
		                      |ГДЕ
		                      |	ВопросыИОтветыОтветы.Ссылка = &Ссылка
		                      |	И ВопросыИОтветыОтветы.ЭтоПравильный");
		Запрос.УстановитьПараметр("Ссылка", Вопрос);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Возврат Выборка.НомерОтвета;
		КонецЕсли;

	
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	ВопросыИОтветыОтветы.НомерОтвета КАК ПравильныйОтвет
	//	|ИЗ
	//	|	Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	//	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	//	|		ПО ВопросыИОтветыОтветы.Ссылка = ВопросыИОтветы.Ссылка
	//	|ГДЕ
	//	|	ВопросыИОтветы.Ссылка = &Вопрос
	//	|	И ВопросыИОтветы.Ответы.ЭтоПравильный = ИСТИНА";
	//
	//Запрос.УстановитьПараметр("Вопрос", Вопрос);
	//
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	Возврат ВыборкаДетальныеЗаписи.ПравильныйОтвет;
	//КонецЦикла;
	
	Возврат 0;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

Процедура ОчиститьТекущиеВопросы() Экспорт
	Выборка = Справочники.ТекущиеОтветы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Об1 = Выборка.ПолучитьОбъект();
		Об1.Удалить();
	КонецЦикла;
		
КонецПроцедуры

Процедура ОчиститьРазделы() Экспорт

	Выборка = Справочники.Разделы.Выбрать();
	Пока Выборка.Следующий() Цикл
		Об1 = Выборка.ПолучитьОбъект();
		Об1.Удалить();
	КонецЦикла;

КонецПроцедуры

Процедура ОчиститьРаздлыИВопросы() Экспорт

ОчиститьТекущиеВопросы();
ОчиститьРазделы();

КонецПроцедуры
 

Процедура ЗаполнитьВопросыТестирования(Раздел=Неопределено) Экспорт
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВопросыИОтветы.Ссылка КАК Вопрос
		|ИЗ
		|	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
		|ГДЕ
		|	ВЫБОР
		|			КОГДА &Раздел = НЕОПРЕДЕЛЕНО
		|				ТОГДА ИСТИНА
		|			ИНАЧЕ ВопросыИОтветы.Владелец = &Раздел
		|		КОНЕЦ
		|	И НЕ ВопросыИОтветы.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Раздел", Раздел);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ОчиститьТекущиеВопросы();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		ДобавитьВопрос(ВыборкаДетальныеЗаписи.Вопрос);
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецПроцедуры

Функция СлучайныйВопрос()Экспорт 
	
	// Список не отвеченных вопросов
	
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТекущиеОтветы.Вопрос
		|ИЗ
		|	Справочник.ТекущиеОтветы КАК ТекущиеОтветы
		|ГДЕ
		|	ТекущиеОтветы.Ответ = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВсегоВопросов = ВыборкаДетальныеЗаписи.Количество();
	
	Если ВсегоВопросов = 0 Тогда
		Возврат Справочники.ВопросыИОтветы.ПустаяСсылка();
	КонецЕсли;
		
	ГСЧ = Новый ГенераторСлучайныхЧисел();
	СлучайноеЧисло = ГСЧ.СлучайноеЧисло(1,ВсегоВопросов-1);
	
	Счетчик = 1;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если Счетчик = СлучайноеЧисло Тогда
			Возврат ВыборкаДетальныеЗаписи.Вопрос;
		КонецЕсли;
		Счетчик = Счетчик + 1;
	КонецЦикла;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	Возврат Справочники.ВопросыИОтветы.ПустаяСсылка();
	
КонецФункции

Функция ЕстьНеОтвеченные() Экспорт
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК НеОтвеченных
		|ИЗ
		|	Справочник.ТекущиеОтветы КАК ТекущиеОтветы
		|ГДЕ
		|	ТекущиеОтветы.Ответ = 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		Возврат ВыборкаДетальныеЗаписи.НеОтвеченных;
		//Если ВыборкаДетальныеЗаписи.НеОтвеченных > 0 Тогда
		//	Возврат Истина;
		//Иначе
		//	Возврат Ложь;
		//КонецЕсли;
		
			
	КонецЦикла;
	
	Возврат 0;
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

Функция РезультатТестирования() Экспорт
		//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ПравильныхКоличество
		|ИЗ
		|	Справочник.ТекущиеОтветы КАК ТекущиеОтветы
		|ГДЕ
		|	ТекущиеОтветы.Правильный";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Правильных = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		Правильных = ВыборкаДетальныеЗаписи.ПравильныхКоличество;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК ВсегоКоличество
		|ИЗ
		|	Справочник.ТекущиеОтветы КАК ТекущиеОтветы";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВсегоКоличество = 0;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		// Вставить обработку выборки ВыборкаДетальныеЗаписи
		ВсегоКоличество = ВыборкаДетальныеЗаписи.ВсегоКоличество;
	КонецЦикла;
	
	НеОтвеченных = ЕстьНеОтвеченные();
	
	Отвеченных = ВсегоКоличество - НеОтвеченных;
	
	Неправильных = Отвеченных - Правильных;
	
	Если Отвеченных = 0 Тогда
		Стр = "Нет ни одного ответа!";
	Иначе
	
		Процент = Окр ((Правильных/Отвеченных)*100);
		
		Стр = "Результат: "+Процент +"%" +"(" + Правильных + " из " + Отвеченных + ")" +Символы.ПС;
		Стр = Стр + "Неправильных: " +Неправильных;
	КонецЕсли;
	
	Если НеОтвеченных>0 тогда
		Стр = Стр + Символы.ПС + "Неотвечено: "+НеОтвеченных 
	КонецЕсли;
	
	Возврат Стр;
	
	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
КонецФункции

Процедура ЗаписатьРезультатыТестирования () Экспорт
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТекущиеОтветы.Вопрос,
		|	ТекущиеОтветы.Ответ
		|ИЗ
		|	Справочник.ТекущиеОтветы КАК ТекущиеОтветы
		|ГДЕ
		|	ТекущиеОтветы.Ответ <> 0";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	НовыйДок = Документы.РезультатТестирования.СоздатьДокумент();
	
	НовыйДок.Дата = ТекущаяДата();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
				НовСтр = НовыйДок.Ответы.Добавить();
		НовСтр.Вопрос =  ВыборкаДетальныеЗаписи.Вопрос;
		НовСтр.НомерОтвета = ВыборкаДетальныеЗаписи.Ответ;
	КонецЦикла;
	
	НовыйДок.Записать();
	НовыйДок.Записать(РежимЗаписиДокумента.Проведение);	
КонецПроцедуры





