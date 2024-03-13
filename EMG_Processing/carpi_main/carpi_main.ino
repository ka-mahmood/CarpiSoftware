#include <ArduinoBLE.h>

/*
Carpi rehab device development code
*/
const int sensors = 6;
const char* servUUID = "77b69bf6-0f21-4261-9141-bf758add0037";
const char* EMG_1_UUID = "77b69bf7-0f21-4261-9141-bf758add0037";
const char* EMG_2_UUID = "77b69bf8-0f21-4261-9141-bf758add0037";
const char* EMG_3_UUID = "77b69bf9-0f21-4261-9141-bf758add0037";
const char* EMG_4_UUID = "77b69bfA-0f21-4261-9141-bf758add0037";
const char* EMG_5_UUID = "77b69bfB-0f21-4261-9141-bf758add0037";
const char* EMG_6_UUID = "77b69bfC-0f21-4261-9141-bf758add0037";
int analogAd[sensors] = {A0,A1,A2,A3,A4,A5};
int analogIn[sensors];
int rep;

// dont know if the uuid is that important so just use this for now 
// (I think it needs to be 0-9, A-F, but im not sure) and it definitely needs to be a string
BLEService commService(servUUID);

BLEIntCharacteristic EMG_1_Char(EMG_1_UUID, BLENotify);
BLEIntCharacteristic EMG_2_Char(EMG_2_UUID, BLENotify);
BLEIntCharacteristic EMG_3_Char(EMG_3_UUID, BLENotify);
BLEIntCharacteristic EMG_4_Char(EMG_4_UUID, BLENotify);
BLEIntCharacteristic EMG_5_Char(EMG_5_UUID, BLENotify);
BLEIntCharacteristic EMG_6_Char(EMG_6_UUID, BLENotify);

BLEIntCharacteristic EMG_Data[sensors] = {
  EMG_1_Char, 
  EMG_2_Char,
  EMG_3_Char,
  EMG_4_Char,
  EMG_5_Char,
  EMG_6_Char
};


void setup() {
    Serial.begin(9600);
    while (!Serial);

    // drop and notify if the bluetooth doesn't work
    if (!BLE.begin()) {
      Serial.println("starting Bluetooth® Low Energy module failed!");
      while (1);
    }

    BLE.setLocalName("Carpi Rehab");
    BLE.setAdvertisedService(commService);

    commService.addCharacteristic(EMG_1_Char);
    commService.addCharacteristic(EMG_2_Char);
    commService.addCharacteristic(EMG_3_Char);
    commService.addCharacteristic(EMG_4_Char);
    commService.addCharacteristic(EMG_5_Char);
    commService.addCharacteristic(EMG_6_Char);

    BLE.addService(commService);

    for(int i = 0; i < sensors; i++){
      EMG_Data[i].writeValue(0);
    }

    BLE.advertise();
}

void loop() {
  // tutorial im following has this top of main loop to ensure any breakages get reconnected, seems bad but i guess not
  BLEDevice central = BLE.central();

  Serial.println("- Discovering central device...");
  delay(500);

  if(central){
    rep = 0;
    while(central.connected()){
      if(rep == 1000){
        //read analog data and update the ble values
        for(int i = 0; i < sensors; i++){
          analogIn[i] = analogRead(analogAd[i]);
          EMG_Data[i].writeValue(analogIn[i]);
        }
        Serial.print("A0 pin = ");
        Serial.println(analogIn[0]);
        rep = 0;
      }
      rep++;
    }
  }
}
