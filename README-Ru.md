# Описание

Клиент для OpenWeather, написанный на Swift 5. Используемая архитектура – Clean Swift (VIP)

# Использование

1. Зарегистрироваться на https://openweathermap.org и получить App Key
2. Указать полученный ключ в AppPrivateData.openWeatherMapAPIKey
3. Запустить проект и нажать на "+" в навигационном баре
4. Ввести название города на английском для поиска. Нажать на ячейку с результатом поиска, чтобы добавить город в хранилище
5. Перейти в Cities, чтобы посмотреть прогноз и текущую температуру по сохраненным городам

# Скриншоты

<img src="http://www.picshare.ru/uploads/190618/t7UE6rp8DJ.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/Jo3GRmP1x7.png" width=375 height=667>
<img src="http://www.picshare.ru/uploads/190618/E7i10aE20i.png" width=375 height=667> <img src="http://www.picshare.ru/uploads/190618/0lxFD5ocv7.png" width=375 height=667>

# Архитектура

Проект написан на Clean Swift (VIP). Для генерации модулей используется шаблон YARCH от Альфа-Банка (https://github.com/alfa-laboratory/YARCH), но проект не имеет полного соответствия предложенной схеме

# Содержание проекта

## Модули

### Поиск

### Карта

### Сохраненные города

### Город / Прогноз

## Сетевой слой

## Хранилище
