#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <EEPROM.h>


#define PHOTO_BUTTON_PUSHED   'p'
#define PHOTO_BUTTON_RELEASE  'q'

#define PRINT_BUTTON_PUSHED   'r'
#define PRINT_BUTTON_RELEASE  's'

#define LED_ON                'O'
#define LED_OFF               'F'
#define LED_INTENSITY         'l' //folow by a chat representing the value

#define NB_PHOTO              'N'
#define PHOTO_PRICE           'R'
#define PHOTO_FREE            'G'

#define PIN_PHOTO_BUTTON  0
#define PIN_PRINT_BUTTON 1
#define PIN_WHITE_LED 23

#define NUMFLAKES 10
#define XPOS 0
#define YPOS 1
#define DELTAY 2

//EPPROM 0 : photo_price 1
//EPPROM 1 : photo_price 2
//EPPROM 2 : free_photos 1
//EPPROM 3 : free_photos 2
//EPPROM 4 : nb_photos 1
//EPPROM 5 : nb_photos 2

int previous_photo_status = HIGH;
int previous_print_status = HIGH;

String  inputString = ""; 
bool    stringComplete = false;
char    brightness = 255;
bool    ledOn = false;

float   photo_price;
unsigned int free_photos;
unsigned int nb_photos;

Adafruit_PCD8544 display = Adafruit_PCD8544(3, 4, 5);

void updateScreen() {
    unsigned int tmp = 0;
    tmp += EEPROM.read(0);
    tmp = tmp << 8;
    tmp += EEPROM.read(1);
    photo_price = tmp / 100.0;

    tmp = 0;
    tmp += EEPROM.read(2);
    tmp = tmp << 8;
    tmp += EEPROM.read(3);
    free_photos = tmp;

    tmp = 0;
    tmp += EEPROM.read(4);
    tmp = tmp << 8;
    tmp += EEPROM.read(5);
    nb_photos = tmp;    
    
  
    display.clearDisplay();
    display.setTextSize(1);
    display.print("Photos:");
    display.println(nb_photos);

    display.setTextSize(1);
    display.print("Free:");
    display.println(free_photos);
    display.print("Euro/p:");
    display.println(photo_price);

    display.setTextSize(2);
    display.print("tt:");
    int res = nb_photos > free_photos ? ((nb_photos - free_photos) * photo_price) : 0;
    display.print(res);
    display.display();
}

int byteToInt() {
  unsigned int result = 0;

  if (Serial.available()) {
    byte incomingByte = Serial.read();
    while ((incomingByte != -1) && (incomingByte != '\n')) {
      result <<= 8;
      result += incomingByte;
      incomingByte = Serial.read();
    }
  }
  
  return result;
}

void setup() {
  Serial.begin(9600);
  pinMode(PIN_WHITE_LED, OUTPUT);  
  pinMode(PIN_PHOTO_BUTTON, INPUT_PULLUP);
  pinMode(PIN_PRINT_BUTTON, INPUT_PULLUP);
  inputString.reserve(200);

  photo_price = 0.4;
  free_photos = 250;
  nb_photos = 350;
  
  display.begin();
  //display.setContrast(40);
  updateScreen();
}

void writeToEEPROM(byte address, byte value) {
  if (EEPROM.read(address) != value) {
    EEPROM.write(address, value);
  }
}

void savePhotoPrice() {
  if (Serial.available()) {
    byte incomingByte = Serial.read();
    if (incomingByte != -1) {
      writeToEEPROM(0, incomingByte);
    }
    incomingByte = Serial.read();
    if (incomingByte != -1) {
      writeToEEPROM(1, incomingByte);
    }
  }
}

void saveFreePhoto() {
    byte incomingByte = Serial.read();
    if (incomingByte != -1) {
      writeToEEPROM(2, incomingByte);
    }
    incomingByte = Serial.read();
    if (incomingByte != -1) {
      writeToEEPROM(3, incomingByte);
    }
}

void saveNbPhoto() {
  byte incomingByte = Serial.read();
  if (incomingByte != -1) {
    writeToEEPROM(4, incomingByte);
  }
  incomingByte = Serial.read();
  if (incomingByte != -1) {
    writeToEEPROM(5, incomingByte);
  }
}

void loop() {
  //Write Data photo button
  if ((previous_photo_status == LOW) && (digitalRead(PIN_PHOTO_BUTTON) == HIGH)) {
    Serial.println(PHOTO_BUTTON_RELEASE);
    previous_photo_status = HIGH;
  }
  if ((previous_photo_status == HIGH) && (digitalRead(PIN_PHOTO_BUTTON) == LOW)) {
    Serial.println(PHOTO_BUTTON_PUSHED);
    previous_photo_status = LOW;
  }

  //Write Data print button
  if ((previous_print_status == LOW) && (digitalRead(PIN_PRINT_BUTTON) == HIGH)) {
    Serial.println(PRINT_BUTTON_RELEASE);
    previous_print_status = HIGH;
  }
  if ((previous_print_status == HIGH) && (digitalRead(PIN_PRINT_BUTTON) == LOW)) {
    Serial.println(PRINT_BUTTON_PUSHED);
    previous_print_status = LOW;
  }
  
  if (Serial.available()) {
      byte incomingByte = Serial.read();  // will not be -1

      if (incomingByte == LED_ON) {
        analogWrite(PIN_WHITE_LED, brightness);
        Serial.read();
        Serial.read();        
        ledOn = true;
      }

      if (incomingByte == LED_OFF) {
        analogWrite(PIN_WHITE_LED, LOW);
        Serial.read();
        Serial.read();    
        ledOn = false;    
      }

      if (incomingByte == LED_INTENSITY) {
        incomingByte = Serial.read(); //Autre byte avec l'intensite
        brightness = incomingByte;
        if (ledOn) {
          analogWrite(PIN_WHITE_LED, brightness); //For test, to remove
        }
        Serial.read();
        Serial.read();
      }

      if (incomingByte == NB_PHOTO) {
        saveNbPhoto();
        Serial.read();
        Serial.read();
        updateScreen();
      }

      if (incomingByte == PHOTO_PRICE) {
        savePhotoPrice();
        Serial.read();
        Serial.read();
        updateScreen();
      }

      if (incomingByte == PHOTO_FREE) {
        saveFreePhoto();
        Serial.read();
        Serial.read();
        updateScreen();
      }
  }

  delay(50);
}
