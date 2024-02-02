// Структура пакета #cff00ff1$, где
// # - начало пакета
// c - тип пакета (может быть c - цвет, b - яркость, m - световой режим)
// ff00ff - полезная нагрузка
// 1 - контрольная сумма пакета, один байт суммы всех char (тип + полезная нагрузка)
// $ - терминатор пакета

#include <GRGB.h>

GRGB led(COMMON_CATHODE, 3, 5, 6);

// Переменные для алгоритмов свечения
char lightMode = '0'; // Режим свечения выключен
uint32_t tmr; // время


void setup() {
  // Подключение bluetooth
  Serial.begin(9600);  /*Baud Rate for serial communication*/
  Serial.setTimeout(100);
  pinMode(13, OUTPUT); 
  // включить гамма-коррекцию (по умолч. выключено)
  led.setCRT(true);
}

void loop() {
  readSerialData();
//  playLightMode();
}

// Чтение входящих пакетов
void readSerialData() {
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
      case 'm': // Установка светового режима
        lightMode = payload[0];
        break;
    }
  }   
}


//--------------------------------------Световой режим--------------------------------------//

// Определение светового режима 
void playLightMode() {
  if (lightMode == '1') return;
  else if (lightMode == '0') switchingBrightnessLightMode();
}

void switchingBrightnessLightMode() {
  static int val = 0;
  static bool dir = true; // направление алгоритма
  if (millis() - tmr >= 20) {
    tmr = millis();
    if (dir) val++; // увеличиваем яркость
    else val--;     // уменьшаем
    if (val >= 255 || val <= 0) dir = !dir; // разворачиваем
    led.setBrightness(val);
  }
}


//--------------------------------------Цвета-----------------------------------------------//

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


//--------------------------------------Утилиты---------------------------------------------//

// Метод проверки входящего пакета, если false, то пакет битый и его пропускаем
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
