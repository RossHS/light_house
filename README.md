<div align="center">

# Light House
LED светильник. Flutter приложение. Arduino. Шейдеры

[О проекте](#-о-проекте) •
[Используемый стек](#-используемый-стек) •
[Функционал](#%EF%B8%8F-функционалл)

<b>WEB демка. [Открыть демо](https://rosshs.github.io/light_house)</b>

<p align="center">
    <a href="https://rosshs.github.io/light_house" align="center">
        <img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/demo_preview.jpg?raw=true">
    </a>
</p>



</div>

## 🤔 О проекте
В рамках проекта было сделано:
Создано устройство на базе Arduino. С его кодом можно ознакомиться вот [тут](https://github.com/RossHS/light_house/tree/master/arduino_source/ble_rgb). 

Используемые платы:
- Вычислитель - [Arduino NANO](https://aliexpress.ru/item/1005002976480289.html?sku_id=12000023034462919&spm=a2g2w.productlist.search_results.0.2cc15e81tViNh2)
- Bluetooth - [BLE HM-10](https://aliexpress.ru/item/32888733000.html?sku_id=12000020204883344&spm=a2g2w.productlist.search_results.0.2cc15e81tViNh2)
- LED - [RGB Module KY-016](https://aliexpress.ru/item/32977462875.html?sku_id=66739573349&spm=a2g2w.productlist.search_results.0.374234db0N2EQs)



| <p align="left"><a align="center"><img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/kolhoz.jpg?raw=true" width="250px"></a></p> | <p align="left"><a align="center"><img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/under_the_lid.jpg?raw=true" width="250px"></a></p> | <p align="left"><a align="center"><img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/day.jpg?raw=true" width="250px"></a></p> | <p align="left"><a align="center"><img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/night.jpg?raw=true" width="250px"></a></p> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Колхозная пайка на полу 🤡 | "Под капотом 😂" | День | Ночь |


Упрощенная схема подключения

<p align="left">
        <img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/connection_scheme.jpg?raw=true" width="500px">
</p>

- Написано мобильное Flutter приложение (с использованием шейдеров), при помощи которого можно подключаться к устройству по BLE и управлять светильником. При разработке приложения практически всегда создавались кастомные элементы, а именно (переходы, выводы модалок, эффекты, окна и т.п.)

Ключевые моменты

| <p align="left"><a href="https://frezyx.github.io/talker" align="center"><img src="https://github.com/Frezyx/talker/blob/dev/docs/assets/v3/talker_flutter/start.png?raw=true" width="250px"></a></p> | <p align="left"><a href="https://frezyx.github.io/talker" align="center"><img src="https://github.com/Frezyx/talker/blob/dev/docs/assets/v3/talker_flutter/filter.png?raw=true" width="250px"></a></p> | <p align="left"><a href="https://frezyx.github.io/talker" align="center"><img src="https://github.com/Frezyx/talker/blob/dev/docs/assets/v3/talker_flutter/actions.png?raw=true" width="250px"></a></p> | <p align="left"><a href="https://frezyx.github.io/talker" align="center"><img src="https://github.com/Frezyx/talker/blob/dev/docs/assets/v3/talker_flutter/settings.png?raw=true" width="250px"></a></p> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Общий вид | Логи | Выбор режима пригрывавания | Кастомные переходы |


## 📦 Используемый стек

- Менеджер состояний - [MobX](https://pub.dev/packages/mobx)
- Навигация - [GoRouter](https://pub.dev/packages/go_router)
- DI - [GetIt](https://pub.dev/packages/get_it)
- Тестирование и прототипирование UI - [Widgetbook](https://pub.dev/packages/widgetbook)
- Работа с BLE - [flutter_reactive_ble](https://pub.dev/packages/flutter_reactive_ble)
- БД - [Hive](https://pub.dev/packages/hive)
- Логирование - [Logger](https://pub.dev/packages/logger)

## 🛠️ Функционал
- Автопоиск и автоподключение к BLE
- Система логирования с возможностью поделиться файлом логов
- Фунционал избранного для понравившихся цветом
- Вывод названия цвета по его hex значению 
- 2 Динамические темы приложения, цветовая схема которых зависит от установленного света светильника 
- 3 режима проигрывания цветов
- Различные кастомные переходы между экранами