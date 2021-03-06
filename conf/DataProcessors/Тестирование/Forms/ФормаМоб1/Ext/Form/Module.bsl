﻿&НаКлиенте
Процедура КомандаОтветить(Команда)
	Объект.ТаблицаВопросов[НомерВопроса - 1].ТекущийОтвет = Ответ;
	
	Для каждого ТекЭл из Элементы.НомераВопросов1.СписокВыбора Цикл
		Если Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ТекущийОтвет <> 0 Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "*";
		Иначе
			ТекЭл.Представление = Строка(ТекЭл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекЭл из Элементы.НомераВопросов2.СписокВыбора Цикл
		Если Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ТекущийОтвет <> 0 Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "*";
		Иначе
			ТекЭл.Представление = Строка(ТекЭл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	
	ЕстьНеОтвеченный = Ложь;
	НовыйНомерВопроса = НомерВопроса;
	
	КолЦиклов = 1;
	
	КоличествоДляПроверки = Объект.ТаблицаВопросов.Количество() + 1;
	
	Пока НЕ ЕстьНеОтвеченный и КолЦиклов < КоличествоДляПроверки Цикл
		
		НовыйНомерВопроса = НовыйНомерВопроса + 1;
		
		Если НовыйНомерВопроса > Объект.ТаблицаВопросов.Количество() Тогда
			НовыйНомерВопроса = 1;
		КонецЕсли;
		
		Если Объект.ТаблицаВопросов[НовыйНомерВопроса - 1].ТекущийОтвет = 0 Тогда
			ЕстьНеОтвеченный = Истина;
		КонецЕсли;
		
		КолЦиклов = КолЦиклов + 1;
	КонецЦикла;

	Если ЕстьНеОтвеченный Тогда                                                      
		НомерВопроса = НовыйНомерВопроса;
		ПоказатьВопросНомер(НомерВопроса);
	Иначе
		Элементы.КомандаЗавершить.Видимость = Истина;
		
		//#Если НЕ МобильноеПриложениеКлиент и НЕ МобильноеПриложениеСервер Тогда
		//Сообщение = Новый СообщениеПользователю;
		//Сообщение.Текст = "Тест закончен! Нажмите завершить!";
		//Сообщение.Сообщить();
		//#КонецЕсли
		Если Вопрос("Завершить тестирование?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			КомандаЗавершить(Команда);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ЭтаФорма.Модифицированность = Истина;
	//ЭтаФорма.ТекущийЭлемент = Элементы.НомераВопросов1;
КонецПроцедуры

&НаСервере
Процедура ПоказатьВопросНомер(Ном)
	НомерВопроса = Ном;
	
	ТекСтрока = Объект.ТаблицаВопросов[Ном - 1];
	
	Раздел = "" + Строка(ТекСтрока.Вопрос.Владелец.НомерРаздела) + ". " + ТекСтрока.Вопрос.Владелец.Наименование;
	Вопрос = "" + Строка(ТекСтрока.Вопрос.Владелец.НомерРаздела) + "." + Строка(ТекСтрока.Вопрос.НомерВопроса) + ". " + ТекСтрока.Вопрос.Вопрос;
	
	АдресКартинки = ТекСтрока.Картинка;
	Элементы.Картинка.Видимость = НЕ ПустаяСтрока(АдресКартинки);
	
	//Ответ = 0;
	
	Ответ = ТекСтрока.ТекущийОтвет;
	
	Комментарий = ТекСтрока.Комментарий;
	
	н = 1;
	Для каждого ТекОтвет из ТекСтрока.Вопрос.Ответы Цикл
		
		ЭтаФорма["Флажок" + Строка(н)] = ТекОтвет.НомерОтвета = ТекСтрока.ТекущийОтвет;
		Элементы["Флажок" + Строка(н)].Заголовок = Строка(ТекОтвет.НомерОтвета);
		Элементы["Флажок" + Строка(н)].Видимость = Истина;
		
		
		ЭлОтвет = Элементы["Ответ" + Строка(н)];
		ЭлОтвет.Заголовок = ТекОтвет.Ответ;
		//ЭлОтвет.ЦветТекста = Новый Цвет(0, 0, 0);
		
					
		Элементы.Комментарий.Видимость = ПоказыватьПравильныеОтветы И (НЕ ПустаяСтрока(Комментарий));
		
		Если ПоказыватьПравильныеОтветы и ТекОтвет.НомерОтвета = ТекСтрока.ПравильныйОтвет Тогда
			ЭлОтвет.Шрифт = Новый Шрифт(ЭлОтвет.Шрифт,,,Истина,,Истина);
		Иначе
			ЭлОтвет.Шрифт = Новый Шрифт(ЭлОтвет.Шрифт,,,Ложь,,Ложь);
		КонецЕсли;
		
		ЭлОтвет.Видимость = Истина;
		
		н = н + 1;
	КонецЦикла;
	
	Пока н <=10 Цикл
		
		ЭтаФорма["Флажок" + Строка(н)] = Ложь;
		Элементы["Флажок" + Строка(н)].Заголовок = "";
		Элементы["Флажок" + Строка(н)].Видимость = Ложь;
		
		Элементы["Ответ" + Строка(н)].Заголовок = "";
		Элементы["Ответ" + Строка(н)].Видимость = Ложь;
		н = н + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НачатьТестирование()
	УникЧисло = РегистрыСведений.УникальностьГенератораСлучайныхЧисел.ПолучитьНовоеЧисло();
	Ген = Новый ГенераторСлучайныхЧисел(УникЧисло);
	
	//Сообщить(УникЧисло);
	НеПодбиратьУдаленные = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("НеПодбиратьУдаленные", Истина);
	
	
	
	АнализироватьРезультаты = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("АнализироватьРезультатыПриПодбореВопросов", Истина);
	ПериодАнализаРезультатов = РегистрыСведений.ХранилищеНастроек.ПолучитьНастройку("ПериодАнализаРезультатовПриПодбореВопросов", 20);
	Если АнализироватьРезультаты = Неопределено Тогда
		АнализироватьРезультаты = Истина;
		РегистрыСведений.ХранилищеНастроек.ЗаписатьНастройку("АнализироватьРезультатыПриПодбореВопросов", АнализироватьРезультаты);
	КонецЕсли;
	
	Объект.ТаблицаВопросов.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НеПодбиратьУдаленные", НеПодбиратьУдаленные);
	
	Запрос.УстановитьПараметр("АнализироватьРезультаты", АнализироватьРезультаты);
	Запрос.УстановитьПараметр("ТекущийМоментВремени", ТекущаяДата());
	Запрос.УстановитьПараметр("МоментВремени", ТекущаяДата() - ПериодАнализаРезультатов*60);
	//Запрос.УстановитьПараметр("МоментВремени", ТекущаяДата());
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	РезультатыТестированияСрезПоследних.Вопрос.Владелец КАК Раздел,
	               |	РезультатыТестированияСрезПоследних.Вопрос КАК Ссылка,
	               |	РезультатыТестированияСрезПоследних.Вопрос.НомерВопроса КАК НомерВопроса,
	               |	ЕСТЬNULL(РезультатыТестированияСрезПоследнихТекущий.Правильный, РезультатыТестированияСрезПоследних.Правильный) КАК Правильный
	               |ПОМЕСТИТЬ ВтПредыдущийРезультат
	               |ИЗ
	               |	РегистрСведений.РезультатыТестирования.СрезПоследних(
	               |			&МоментВремени,
	               |			&АнализироватьРезультаты
	               |				И ВЫБОР
	               |					КОГДА &НеПодбиратьУдаленные
	               |						ТОГДА НЕ Вопрос.ПометкаУдаления
	               |								И НЕ Вопрос.Владелец.ПометкаУдаления
	               |					ИНАЧЕ ИСТИНА
	               |				КОНЕЦ) КАК РезультатыТестированияСрезПоследних
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.РезультатыТестирования.СрезПоследних(
	               |				&ТекущийМоментВремени,
	               |				&АнализироватьРезультаты
	               |					И ВЫБОР
	               |						КОГДА &НеПодбиратьУдаленные
	               |							ТОГДА НЕ Вопрос.ПометкаУдаления
	               |									И НЕ Вопрос.Владелец.ПометкаУдаления
	               |						ИНАЧЕ ИСТИНА
	               |					КОНЕЦ) КАК РезультатыТестированияСрезПоследнихТекущий
	               |		ПО РезультатыТестированияСрезПоследних.Вопрос = РезультатыТестированияСрезПоследнихТекущий.Вопрос
	               |			И (РезультатыТестированияСрезПоследних.Правильный = 0)
	               |ГДЕ
	               |	ЕСТЬNULL(РезультатыТестированияСрезПоследнихТекущий.Правильный, РезультатыТестированияСрезПоследних.Правильный) = 0
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВопросыИОтветы.Владелец,
	               |	ВопросыИОтветы.Владелец.НомерРаздела КАК НомерРаздела,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВопросыИОтветы.Ссылка) КАК КоличествоВопросов,
	               |	МИНИМУМ(ВопросыИОтветы.НомерВопроса) КАК МинВопрос,
	               |	МАКСИМУМ(ВопросыИОтветы.НомерВопроса) КАК МаксВопрос,
	               |	ЕСТЬNULL(ПредыдущийРезультат.КоличествоВопросов, 0) > 0 КАК ЕстьПредыдущие
	               |ИЗ
	               |	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			ВтПредыдущийРезультат.Раздел КАК Раздел,
	               |			КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВтПредыдущийРезультат.Ссылка) КАК КоличествоВопросов
	               |		ИЗ
	               |			ВтПредыдущийРезультат КАК ВтПредыдущийРезультат
	               |		
	               |		СГРУППИРОВАТЬ ПО
	               |			ВтПредыдущийРезультат.Раздел) КАК ПредыдущийРезультат
	               |		ПО (ПредыдущийРезультат.Раздел = ВопросыИОтветы.Владелец)
	               |ГДЕ
	               |	ВЫБОР
	               |			КОГДА &НеПодбиратьУдаленные
	               |				ТОГДА НЕ ВопросыИОтветы.ПометкаУдаления
	               |						И НЕ ВопросыИОтветы.Владелец.ПометкаУдаления
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВопросыИОтветы.Владелец,
	               |	ВопросыИОтветы.Владелец.НомерРаздела,
	               |	ЕСТЬNULL(ПредыдущийРезультат.КоличествоВопросов, 0) > 0
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	НомерРаздела";
	ВыборкаВопросы = Запрос.Выполнить().Выбрать();
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ВопросыИОтветы.Ссылка,
	               |	ВопросыИОтветы.ХранилищеКартинки,
	               |	ВопросыИОтветыОтветы.НомерОтвета КАК ПравильныйОтвет,
	               |	ВопросыИОтветы.Комментарий
	               |ИЗ
	               |	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	               |		ПО (ВопросыИОтветыОтветы.Ссылка = ВопросыИОтветы.Ссылка)
	               |			И (ВопросыИОтветыОтветы.ЭтоПравильный)
	               |ГДЕ
	               |	ВопросыИОтветы.Владелец = &Владелец
	               |	И ВопросыИОтветы.НомерВопроса = &СлучайныйНомер
	               |	И ВЫБОР
	               |			КОГДА &НеПодбиратьУдаленные
	               |				ТОГДА НЕ ВопросыИОтветы.ПометкаУдаления
	               |						И НЕ ВопросыИОтветы.Владелец.ПометкаУдаления
	               |			ИНАЧЕ ИСТИНА
	               |		КОНЕЦ";
				   
	ТекстЗапросаСлучайныйВопрос = "ВЫБРАТЬ ПЕРВЫЕ 1
	                              |	ВопросыИОтветы.Ссылка,
	                              |	ВопросыИОтветы.ХранилищеКартинки,
	                              |	ВопросыИОтветыОтветы.НомерОтвета КАК ПравильныйОтвет,
	                              |	ВопросыИОтветы.Комментарий
	                              |ИЗ
	                              |	Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	                              |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	                              |		ПО (ВопросыИОтветыОтветы.Ссылка = ВопросыИОтветы.Ссылка)
	                              |			И (ВопросыИОтветыОтветы.ЭтоПравильный)
	                              |ГДЕ
	                              |	ВопросыИОтветы.Владелец = &Владелец
	                              |	И ВопросыИОтветы.НомерВопроса = &СлучайныйНомер
	                              |	И ВЫБОР
	                              |			КОГДА &НеПодбиратьУдаленные
	                              |				ТОГДА НЕ ВопросыИОтветы.ПометкаУдаления
	                              |						И НЕ ВопросыИОтветы.Владелец.ПометкаУдаления
	                              |			ИНАЧЕ ИСТИНА
	                              |		КОНЕЦ";
								  
	//ТекстЗапросаАнализВопросов = "ВЫБРАТЬ
	//                             |	ВтПредыдущийРезультат.Ссылка,
	//                             |	ВтПредыдущийРезультат.Ссылка.ХранилищеКартинки КАК ХранилищеКартинки,
	//                             |	ВопросыИОтветыОтветы.НомерОтвета КАК ПравильныйОтвет
	//							 |ИЗ
	//                             |	ВтПредыдущийРезультат КАК ВтПредыдущийРезультат
	//                             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	//                             |		ПО (ВопросыИОтветыОтветы.Ссылка = ВтПредыдущийРезультат.Ссылка)
	//                             |			И (ВопросыИОтветыОтветы.ЭтоПравильный)
	//                             |ГДЕ
	//                             |	ВтПредыдущийРезультат.Раздел = &Владелец";
	
	ТекстЗапросаАнализВопросов = "ВЫБРАТЬ
	                             |	ВтПредыдущийРезультат.Ссылка,
	                             |	ВтПредыдущийРезультат.Ссылка.ХранилищеКартинки КАК ХранилищеКартинки,
	                             |	ВопросыИОтветыОтветы.НомерОтвета КАК ПравильныйОтвет,
	                             |	ВопросыИОтветы.Комментарий
	                             |ИЗ
	                             |	ВтПредыдущийРезультат КАК ВтПредыдущийРезультат
	                             |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы.Ответы КАК ВопросыИОтветыОтветы
	                             |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВопросыИОтветы КАК ВопросыИОтветы
	                             |			ПО ВопросыИОтветыОтветы.Ссылка = ВопросыИОтветы.Ссылка
	                             |		ПО (ВопросыИОтветыОтветы.Ссылка = ВтПредыдущийРезультат.Ссылка)
	                             |			И (ВопросыИОтветыОтветы.ЭтоПравильный)
	                             |ГДЕ
	                             |	ВтПредыдущийРезультат.Раздел = &Владелец";
	
	
	
	
	Пока ВыборкаВопросы.Следующий() Цикл
		
		Запрос.УстановитьПараметр("Владелец", ВыборкаВопросы.Владелец);
		
		Если ВыборкаВопросы.ЕстьПредыдущие Тогда
			Запрос.Текст = ТекстЗапросаАнализВопросов;
			ТЗПредыдущиеВопросы = Запрос.Выполнить().Выгрузить();
			КолПредыдуших = ТЗПредыдущиеВопросы.Количество();
			СлучайныйНомер = Ген.СлучайноеЧисло(0, КолПредыдуших - 1);
			
			ТекСтрокаЗапроса = ТЗПредыдущиеВопросы[СлучайныйНомер];
		Иначе
		
			Запрос.Текст = ТекстЗапросаСлучайныйВопрос;
			
			Флаг = Истина;
			Пока Флаг Цикл
				СлучайныйНомер = Ген.СлучайноеЧисло(ВыборкаВопросы.МинВопрос, ВыборкаВопросы.МаксВопрос);
				
				Запрос.УстановитьПараметр("СлучайныйНомер", СлучайныйНомер);
				ТЗСлучайныйВопрос = Запрос.Выполнить().Выгрузить();
				Если ТЗСлучайныйВопрос.Количество() > 0 Тогда
					Флаг = Ложь;                                      
				КонецЕсли;
			КонецЦикла;
			
			ТекСтрокаЗапроса = ТЗСлучайныйВопрос[0];
		КонецЕсли;
		
		НовСтр = Объект.ТаблицаВопросов.Добавить();
		
		
		ДвоичныеДанные = ТекСтрокаЗапроса.ХранилищеКартинки.Получить();
		
		НовСтр.Вопрос = ТекСтрокаЗапроса.Ссылка;
		НовСтр.ПравильныйОтвет = ТекСтрокаЗапроса.ПравильныйОтвет;
		НовСтр.Комментарий = ТекСтрокаЗапроса.Комментарий;
		Если ДвоичныеДанные = Неопределено Тогда
			НовСтр.Картинка = "";
		Иначе
			НовСтр.Картинка = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	НачатьТестирование();
		
	КоличествоВопросов = Объект.ТаблицаВопросов.Количество();
	Если КоличествоВопросов = 0 Тогда
		Отказ = Истина;
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не заполнена ТЗ вопросов!";
		Сообщение.Сообщить();
		
		Возврат;
	КонецЕсли;                                                                  
	
	НомерВопроса = 1;
	
	
	НовСписокВыбора = Новый СписокЗначений;

	КолВопросов1 = Цел(КоличествоВопросов / 2) + КоличествоВопросов % 2;
	
	Для н = 1 по КолВопросов1 Цикл
		НовСписокВыбора.Добавить(н);
	КонецЦикла;
	
	Элементы.НомераВопросов1.СписокВыбора.ЗагрузитьЗначения(НовСписокВыбора.ВыгрузитьЗначения());
	
	НовСписокВыбора = Новый СписокЗначений;
	
	Пока н <= КоличествоВопросов Цикл
		НовСписокВыбора.Добавить(н);
		н = н + 1;
	КонецЦикла;
	
	Элементы.НомераВопросов2.СписокВыбора.ЗагрузитьЗначения(НовСписокВыбора.ВыгрузитьЗначения());
	
	ПоказатьВопросНомер(1);
КонецПроцедуры


&НаСервере
Процедура ЗавершитьТестирование(Сообщение)
	НовыйДок = Документы.РезультатТестирования.СоздатьДокумент();
	
	НовыйДок.Дата = ТекущаяДата();
	
	КолВопросов = 0;
	КолПравильных = 0;
	
	Для каждого ТекВопрос из Объект.ТаблицаВопросов Цикл
		НовСтр = НовыйДок.Ответы.Добавить();
		НовСтр.Вопрос = ТекВопрос.Вопрос;
		НовСтр.НомерОтвета = ?(ТекВопрос.БылаИспользованаПодсказка, 0, ТекВопрос.ТекущийОтвет);
		
		Если ТекВопрос.ТекущийОтвет = ТекВопрос.ПравильныйОтвет и НЕ ТекВопрос.БылаИспользованаПодсказка Тогда
			КолПравильных = КолПравильных + 1;
		КонецЕсли;
		
		КолВопросов = КолВопросов + 1;
	КонецЦикла;
	
	НовыйДок.Записать();
	НовыйДок.Записать(РежимЗаписиДокумента.Проведение);
	
//	#Если НЕ МобильноеПриложениеКлиент и НЕ МобильноеПриложениеСервер Тогда
//	
//	ОтчетРезультат = Отчеты.ТекущийРезультатТестирования.Создать();
//	ОтчетРезультат.РезультатТестирования = НовыйДок.Ссылка;
//	
//	ТабДок = Новый ТабличныйДокумент;
//	ОтчетРезультат.СкомпоноватьРезультат(ТабДок);
//	Возврат ТабДок;
//	
//	#Иначе
//	Возврат Новый ТабличныйДокумент;
//#КонецЕсли

	Сообщение = "Ваш результат: " + Строка(Формат(КолПравильных / КолВопросов, "ЧДЦ=; ЧС=-2")) + "% (" + Строка(КолПравильных) + " из " + Строка(КолВопросов) + ")";
	
	ПоказыватьПравильныеОтветы = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НомераВопросовПриИзменении(Элемент)
	ПоказатьВопросНомер(НомерВопроса);
КонецПроцедуры


&НаКлиенте
Процедура КомандаЗавершить(Команда)
	Сообщение = "";
	ЗавершитьТестирование(Сообщение);
	
	Элементы.КомандаОтветить.Видимость = Ложь;
	Элементы.КомандаПоказатьПравильный.Видимость = Ложь;
	Элементы.КомандаЗавершить.Видимость = Ложь;
	
	Элементы.КомандаЗакрыть.Видимость = Истина;
	
	
	//ТабДок.Показать();
	
	Для каждого ТекЭл из Элементы.НомераВопросов1.СписокВыбора Цикл
		Если Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ТекущийОтвет <> Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ПравильныйОтвет Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "#";
		ИначеЕсли Объект.ТаблицаВопросов[ТекЭл.Значение - 1].БылаИспользованаПодсказка Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "?";
		Иначе
			ТекЭл.Представление = Строка(ТекЭл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекЭл из Элементы.НомераВопросов2.СписокВыбора Цикл
		Если Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ТекущийОтвет <> Объект.ТаблицаВопросов[ТекЭл.Значение - 1].ПравильныйОтвет Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "#";
		ИначеЕсли Объект.ТаблицаВопросов[ТекЭл.Значение - 1].БылаИспользованаПодсказка Тогда
			ТекЭл.Представление = Строка(ТекЭл.Значение) + "?";
		Иначе
			ТекЭл.Представление = Строка(ТекЭл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	ЭтаФорма.Модифицированность = Ложь;
	ПоказатьВопросНомер(1);
	
	Сообщить(Сообщение);
	
	//Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если ЭтаФорма.Модифицированность Тогда
		Если Вопрос("Тест не завершен. Данные не будут сохранены. Закрыть?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			
			Отказ = Истина;
			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Флажок1ПриИзменении(Элемент)
	
	ТекНомерЭлемента = Число(СтрЗаменить(Элемент.Имя, "Флажок", ""));
	
	Ответ = Число(Элемент.Заголовок);
	
	Для н = 1 по 10 Цикл
		ЭтаФорма["Флажок" + Строка(н)] = н = ТекНомерЭлемента;
	КонецЦикла;
	
КонецПроцедуры

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


&НаСервере
Процедура КомандаПоказатьПравильныйНаСервере()
	
	ТекСтрока = Объект.ТаблицаВопросов[НомерВопроса - 1];
	
	Если Ответ <> ТекСтрока.ПравильныйОтвет Тогда
		ТекСтрока.БылаИспользованаПодсказка = Истина;
	КонецЕсли;
	
	н = 1;
	
	Для каждого ТекОтвет из ТекСтрока.Вопрос.Ответы Цикл
		
		ЭтаФорма["Флажок" + Строка(н)] = ТекОтвет.ЭтоПравильный;
		
		Если ТекОтвет.ЭтоПравильный Тогда
			Ответ = ТекОтвет.НомерОтвета;
		КонецЕсли;
		
		н = н + 1;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура КомандаПоказатьПравильный(Команда)
	Если Вопрос("Показать подсказку?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		КомандаПоказатьПравильныйНаСервере();
		 Элементы.Комментарий.Видимость=Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	Закрыть();
КонецПроцедуры
