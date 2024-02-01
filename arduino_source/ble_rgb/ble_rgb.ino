// Структура пакета #cff00ff1$, где
// # - начало пакета
// c - тип пакета
// ff00ff - полезная нагрузка
// 1 - контрольная сумма пакета, один байт суммы всех char (тип + полезная нагрузка)
// $ - терминатор пакета

#include <GRGB.h>

GRGB led(COMMON_CATHODE, 3, 5, 6);

void setup() {
  // Подключение bluetooth
  Serial.begin(9600);  /*Baud Rate for serial communication*/
  Serial.setTimeout(100);
  pinMode(13, OUTPUT); 

  // установить ОБЩУЮ яркость
  // led.setBrightness(255);

  // включить гамма-коррекцию (по умолч. выключено)
  led.setCRT(true);
}

void loop() {
  if (Serial.available() > 0) {
    String incData = Serial.readStringUntil('$');
    if (checkData(incData) == false) return;
    // Полезная нагрузка пакета
    String payload = incData.substring(2, incData.length() - 1);
    // Забираем заголовок, чтобы понять тип пакета
    switch (incData.charAt(1)) {
      case 'c':
        setColor(payload);
        break;
      case 'b':
        setBrightness(payload);
        break;
    }
  }                         
}

// Установка цвета
void setColor(String colorStr) {
  uint32_t color = strtoul(colorStr.c_str(), NULL, 16);
  led.setHEX(color);
}

// Установка яркости
void setBrightness(String brightnessStr) {
  uint32_t brightness = strtoul(brightnessStr.c_str(), NULL, 16);
  led.setBrightness(brightness);
}

// Метод првоерки входящего пакета, если false, то пакет битый и его пропускаем
boolean checkData(String dataStr) {
  if (dataStr[0] != '#') return false;
  String payload = dataStr.substring(1, dataStr.length() - 1);
  // Проверка контрольной суммы
  if (dataStr.charAt(dataStr.length() - 1) != calcHashSum(payload)) return false;
  return true;
}

char calcHashSum(String payload) {
  int sum = 0;
  for (int i = 0; i < payload.length(); i++) {
    sum += payload.charAt(i);
  }
  return sum % 256;
}
