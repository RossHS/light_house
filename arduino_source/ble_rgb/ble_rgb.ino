#include <GRGB.h>

const int BUFFER_SIZE = 100;
char buf[BUFFER_SIZE];
GRGB led(COMMON_CATHODE, 3, 5, 6);

void setup()
{
  // Подключение bluetooth
  Serial.begin(9600);  /*Baud Rate for serial communication*/
  pinMode(13, OUTPUT); 

  // установить ОБЩУЮ яркость
  led.setBrightness(255);

  // включить гамма-коррекцию (по умолч. выключено)
  led.setCRT(true);
}
void loop()
{
    if(Serial.available() > 0)       /*check for serial data availability*/
    {
        size_t bytesLen = Serial.readBytesUntil(0x25, buf, BUFFER_SIZE); /*read data coming from Bluetooth device*/
        // Проверка ведущего символа пакета, если это не # (0x23) - значит пакет битый и его мы пропускаем
        for(int i = 0; i < bytesLen; i++){
          uint8_t ddd = (const uint8_t *)buf[i];
          Serial.print(ddd);
        }
        Serial.print("\n");
        if (buf[0] != 0x23) return;
        // Ищем контрольную сумму
        int8_t foundIndex = -1; // Индекс, в котором будет найден элемент (-1, если не найден)
        for (int i = 0; i < bytesLen; i++) {
          if (buf[i] == 0x24) {
            foundIndex = i;
            break;
          }
        }

        if (foundIndex == -1) return;

        // Проверка контрольной суммы
        if (buf[foundIndex] != calcHashSum(1, foundIndex)) return;

        // uint32_t colorValue = strtoul(color.c_str(), NULL, 16);
        led.setHEX(buf[1] << 2 + buf[2] << 1 + buf[3]);
    }                            
}

int calcHashSum(uint8_t start, uint8_t end) {
  int sum = 0;
  for (int i = start; i < end; i++) {
    sum += buf[i];
  }
  return sum % 256;
}
