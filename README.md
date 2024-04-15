<div align="center">

# Light House
LED светильник. Flutter приложение. Arduino. Шейдеры

[О приложении](#-о-проекте) •
[Используемый стек](#-используемый-стек) •
[Функционал](#-функционал)

<b>WEB демка. [Открыть демо](https://rosshs.github.io/light_house)</b>

<p align="center">
    <a href="https://rosshs.github.io/light_house" align="center">
        <img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/demo_preview.jpg?raw=true">
    </a>
</p>



</div>

## 🤔 О проекте
В рамках проекта было сделано:
- Создано устройство на базе Arduino. С его кодом можно ознакомиться вот [тут](https://github.com/RossHS/light_house/tree/master/arduino_source/ble_rgb). Используемые платы:
    - Вычислитель - [Arduino NANO](https://aliexpress.ru/item/1005002976480289.html?sku_id=12000023034462919&spm=a2g2w.productlist.search_results.0.2cc15e81tViNh2)
    - Bluetooth - [BLE HM-10](https://aliexpress.ru/item/32888733000.html?sku_id=12000020204883344&spm=a2g2w.productlist.search_results.0.2cc15e81tViNh2)
    - LED - [RGB Module KY-016](https://aliexpress.ru/item/32977462875.html?sku_id=66739573349&spm=a2g2w.productlist.search_results.0.374234db0N2EQs)


Упрощенная схема подключения

<p align="left">
        <img src="https://github.com/RossHS/light_house/blob/finalize/docs/assets/connection_scheme.jpg?raw=true" width="600px">
</p>


- Написано мобильное приложение на Flutter, при помощи которого можно подключаться к устройству по BLE и управлять светильником 

было написано мобильне приложение на Flutter с подключение шейдеров для управления цветом, данные приложение подключается по BLE к конкретному светильнику и  


## 📦 Используемый стек

- Менеджер состояний - [MobX](https://pub.dev/packages/mobx)
- Навигация - [GoRouter](https://pub.dev/packages/go_router)
- DI - [GetIt](https://pub.dev/packages/get_it)
- Тестирование и прототипирование UI - [Widgetbook](https://pub.dev/packages/widgetbook)
- Работа с BLE - [flutter_reactive_ble](https://pub.dev/packages/flutter_reactive_ble)
- БД - [Hive](https://pub.dev/packages/hive)
- Логирование - [Logger](https://pub.dev/packages/logger)

## 🛠️ Функционал