#include <Arduino.h>

#define BLUE 5   
#define GREEN 4
#define RED 2
#define BLUE2 21
#define GREEN2 19
#define RED2 18

int delayTime = 10;
int redValue;
int greenValue;
int blueValue;
int red2Value;
int green2Value;
int blue2Value;

void setup() {
  Serial.begin(115200);
  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(RED, OUTPUT);
  pinMode(BLUE2, OUTPUT);
  pinMode(GREEN2, OUTPUT);
  pinMode(RED2, OUTPUT);
}

void loop() {
  redValue = 255;
  greenValue = 0;
  blueValue = 0;
  red2Value = 0;
  green2Value = 0;
  blue2Value = 255;

  for(int i = 0; i<255; i++){
    redValue -=1;
    greenValue +=1;
    blue2Value -=1;
    green2Value +=1;
    analogWrite(RED, redValue);
    analogWrite(GREEN, greenValue);
    analogWrite(BLUE2, blue2Value);
    analogWrite(GREEN2, green2Value);
    delay(delayTime);
  }

  redValue = 0;
  greenValue = 255;
  blueValue = 0;
  red2Value = 0;
  green2Value = 255;
  blue2Value = 0;

  for(int i = 0; i<255; i++){
    greenValue -= 1;
    blueValue  += 1;
    green2Value -= 1;
    red2Value +=1;
    analogWrite(GREEN, greenValue);
    analogWrite(BLUE, blueValue);
    analogWrite(GREEN2, green2Value);
    analogWrite(RED2, red2Value);
    delay(delayTime);
  }

  redValue = 0;
  greenValue = 0;
  blueValue = 255;
  red2Value = 255;
  green2Value = 0;
  blue2Value = 0;

  for(int i = 0; i<255; i++){
    blueValue -= 1;
    redValue += 1;
    red2Value -= 1;
    blue2Value +=1;
    analogWrite(BLUE, blueValue);
    analogWrite(RED, redValue);
    analogWrite(BLUE2, blue2Value);
    analogWrite(RED2, red2Value);
    delay(delayTime);
  }
}
