#include <Arduino.h>
#include "NimBLEDevice.h"

#define BLUE 5   
#define GREEN 4
#define RED 2
#define BLUE2 21
#define GREEN2 19
#define RED2 18

#define SERVICE_UUID "093fe01c-c46c-4e24-94ec-279a1b837d06"
#define CHARACTERISTIC_TURN_ON_OFF_UUID "56a4dcee-fe97-4f04-be3e-cec59388d516"
#define CHARACTERISTIC_RGB_UUID "5a206a7c-2b58-4171-984d-3d7ac3e10a58"

int redValue = 255;
int greenValue = 165;
int blueValue = 0;
bool isTurnOn = false;

class ServerCallBacks : public NimBLEServerCallbacks {

  void onDisconnect(NimBLEServer* pServer, NimBLEConnInfo& connInfo, int reason) {
        pServer->startAdvertising();
    }

} serverCallBacks;

class CharacteristicsCallBacks: public NimBLECharacteristicCallbacks {

  void onWrite(NimBLECharacteristic *pCharacteristic, NimBLEConnInfo &conninfo) {
    std::string uuid = pCharacteristic->getUUID().toString();
    std::string value = pCharacteristic->getValue();

    if(uuid == CHARACTERISTIC_TURN_ON_OFF_UUID) {
      if(value[0] == 0) {
        isTurnOn = false;
        analogWrite(RED, 0);
        analogWrite(RED2, 0);
        analogWrite(BLUE, 0);
        analogWrite(BLUE2, 0);
        analogWrite(GREEN, 0);
        analogWrite(GREEN2, 0);
      } else if (value[0] == 1) {
        isTurnOn = true;
        analogWrite(RED, redValue);
        analogWrite(RED2, redValue);
        analogWrite(BLUE, blueValue);
        analogWrite(BLUE2, blueValue);
        analogWrite(GREEN, greenValue);
        analogWrite(GREEN2, greenValue);
      }
    } else if (uuid == CHARACTERISTIC_RGB_UUID) {
      if(value.length() == 3){
        redValue = value[0];
        greenValue = value[1];
        blueValue = value[2];
        if(isTurnOn){
          analogWrite(RED, redValue);
          analogWrite(RED2, redValue);
          analogWrite(BLUE, blueValue);
          analogWrite(BLUE2, blueValue);
          analogWrite(GREEN, greenValue);
          analogWrite(GREEN2, greenValue);
        }
        
      }
      
    }



  }

} characteristicsCallBacks;


void setup() {
  Serial.begin(115200);

  NimBLEDevice::init("SVITILNIK");

  NimBLEServer *pServer = NimBLEDevice::createServer();
  pServer->setCallbacks(&serverCallBacks);

  NimBLEService *pService = pServer->createService(SERVICE_UUID);
  NimBLECharacteristic *pTurnOnOffCharacteristic = pService->createCharacteristic(CHARACTERISTIC_TURN_ON_OFF_UUID, NIMBLE_PROPERTY::WRITE_NR);
  NimBLECharacteristic *pRGBCharacteristic = pService->createCharacteristic(CHARACTERISTIC_RGB_UUID, NIMBLE_PROPERTY::WRITE_NR);

  pTurnOnOffCharacteristic->setCallbacks(&characteristicsCallBacks);
  pRGBCharacteristic->setCallbacks(&characteristicsCallBacks);

  NimBLEAdvertising *pAdvertising = NimBLEDevice::getAdvertising();
  NimBLEAdvertisementData advData;
  advData.setCompleteServices(NimBLEUUID(SERVICE_UUID));
  pAdvertising->setAdvertisementData(advData);

  NimBLEAdvertisementData scanData;
  scanData.setName("SVITILNIK");
  pAdvertising->setScanResponseData(scanData);

  pAdvertising->start();

  pinMode(BLUE, OUTPUT);
  pinMode(GREEN, OUTPUT);
  pinMode(RED, OUTPUT);
  pinMode(BLUE2, OUTPUT);
  pinMode(GREEN2, OUTPUT);
  pinMode(RED2, OUTPUT);
  
}

void loop() {
}
