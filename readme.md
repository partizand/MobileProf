Измененная версия для мобильной подготовки к 1С Профессионал
============================================================

Оригинал здесь http://birgom.ru/2016/07/26/мобильное-приложение-для-подготовки/

Изменения
---------

* Убрал ошибку завершения тестов. Когда последний принятый ответ перетирает уже отвеченный на экране, если нажать "Завершить". Теперь Завершить нужно жать после Ответить

* Вопросы можно грузить из файла или http(s). Можно указать как файл на диске, так и указывать веб адрес типа http://ИмяСервера:Порт/ПутьНаСервере

* При загрузке вопросов история неправильно отвеченных не затирается. Добавил галку очищать историю.  Повторная загрузка не дублирует ответы, ссылки сохраняются. Можно вносить изменения в вопросы и загружать их так же как мобильное приложение.

* Убрал вопросы из макета в конфигурации, т.к. они сильно увеличивают ее объем. По сути данные хранятся дважды.

* Добавил поле Комментарий к ответам. Показывается при подготовке и при отображении неправильно отвеченных

* Добавил показ сообщения "Правильно"/"Неправильно" после ответа в Тестировании по разделам. Отключить можно в Настройках/Хранилище настроек/ПоказыватьРезультат

* Добавил вопрос "Показать подсказку", (палец случайно попадает на кнопку при скролинге)

* Частично убрал повторяющийся код

* Добавил свои комментарии к вопросам, немного обновил вопросы


Установка
---------

1. Установить приложение в мобильной версии 1С по ссылкеhttps://raw.githubusercontent.com/partizand/MobileProf/master/mobileprof.xml

2. Запустить приложение. В настройках выбрать "Загрузка ответов". Нажать "Загрузить из файла". 

