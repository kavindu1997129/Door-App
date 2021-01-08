#include <Arduino.h>
#include <WiFi.h>
// link to the library https://github.com/ioxhop/IOXhop_FirebaseESP32
// you must add ArduinoJson version 5 library to the arduino workspace https://github.com/bblanchon/ArduinoJson/tree/5.x
#include <IOXhop_FirebaseESP32.h>  

// configuation for firebase
#define FIREBASE_HOST "door-app-12838-default-rtdb.firebaseio.com"   
#define FIREBASE_AUTH "4D7DcGhyQCnAX3CbjExrysiQ0PGsWQL1FAhCJr6Y"   

// you have to enter your wifi ssd and the password
#define WIFI_SSID "SLT-ADSL-8749D"               
#define WIFI_PASSWORD "Dinidu19971103"

// delay you want before the Relay turned off
#define DELAY 20

// relay attached pin
#define RELAY_PIN 2

void setup() {
  // starting serial communication
  Serial.begin(9600);
  delay(1000);
  // define the pin as output
  pinMode(RELAY_PIN, OUTPUT);  
  // connecting to the wifi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);                                  
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("\nConnected Successfully");
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());

  // connecting to the wifi network
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
  // getting the door status from the firebase
  String fireStatus = Firebase.getString("DoorStatus");

  if (fireStatus == "Open") {
    // turn on the relay
    digitalWrite(2, HIGH);
    // wait for 20s
    delay(20000);
    // turn off the relay
    digitalWrite(2, LOW);
    // set the status of the firebase
    Firebase.setString("DoorStatus", "Close");
  }

  // delay before next reading
  delay(DELAY*1000);

}