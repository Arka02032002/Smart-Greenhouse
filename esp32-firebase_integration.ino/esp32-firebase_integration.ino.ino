#include <Arduino.h>
#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif
#include <Firebase_ESP_Client.h>
//Provide the token genera􀆟on process info.
#include "addons/TokenHelper.h"
//Provide the RTDB payload prin􀆟ng info and other helper func􀆟ons.
#include "addons/RTDBHelper.h"
#include <DFRobot_DHT11.h>
int sensor_pin = 33;
#define FIREBASE_HOST "iot-firebase-99a52-default-rtdb.firebaseio.com"  //database url
#define WEB_API_KEY "AIzaSyB3nOBhv1GYVYOBsJkepKOpi1FZ0Ak0pmQ"
#define WIFI_SSID "AndroidAP"
#define WIFI_PASSWORD "spoi9992"
//Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
DFRobot_DHT11 DHT;
#define DHT11_PIN 13
#define PUMP 21
#define PELTIER 26
#define HUMIDIFIER 27
#define FAN 14
#define FAN2 15
unsigned long sendDataPrevMillis = 0;
int count = 0;
bool signupOK = false;
String boolValue;
int moisture_percentage;
int temp,humidity,soil,humidity2;
int sensor_analog;
void setup() {
  pinMode(sensor_pin, INPUT);
  // pinMode(DHT11_PIN, INPUT);
  pinMode(PUMP, OUTPUT);
  pinMode(PELTIER, OUTPUT);
  pinMode(FAN, OUTPUT);
  pinMode(HUMIDIFIER, OUTPUT);
  pinMode(FAN2, OUTPUT);
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.println("Connec􀆟ng to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    // delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  /* Assign the api key (required) */
  config.api_key = WEB_API_KEY;
  /* Assign the RTDB URL (required) */
  config.database_url = FIREBASE_HOST;
  /* Sign up */
  if (Firebase.signUp(&config, &auth, "", "")) {
    Serial.println("ok");
    signupOK = true;
  } else {
    Serial.printf("%s\n", config.signer.signupError.message.c_str());
  }
  /* Assign the callback func􀆟on for the long running token genera􀆟on task */
  config.token_status_callback = tokenStatusCallback;  //see addons/TokenHelper.h
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);

  // if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/temp")) {
  //       temp = fbdo.intData();
  //       Serial.print("Threshold temp: ");
  //       Serial.println(temp);
  // } 
  // else {
  //     Serial.println(fbdo.errorReason());
  // }
  // if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/humidity")) {
  //       humidity = fbdo.intData();
  //       Serial.print("Threshold humidity: ");
  //       Serial.println(humidity);
  // } 
  // else {
  //     Serial.println(fbdo.errorReason());
  // }
  // if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/soil")) {
  //       soil = fbdo.intData();
  //       Serial.print("Threshold soil: ");
  //       Serial.println(soil);
  // } 
  // else {
  //     Serial.println(fbdo.errorReason());
  // }
  
  // if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/humidity2")) {
  //       humidity2 = fbdo.intData();
  //       Serial.print("Threshold humidity: ");
  //       Serial.println(humidity2);
  // } 
  // else {
  //     Serial.println(fbdo.errorReason());
  // }
}
void loop() {
  if (Firebase.ready() && signupOK && (millis() - sendDataPrevMillis > 5000 || sendDataPrevMillis == 0)) {
    sendDataPrevMillis = millis();

  if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/temp")) {
        temp = fbdo.intData();
        Serial.print("Threshold temp: ");
        Serial.println(temp);
  } 
  else {
      Serial.println(fbdo.errorReason());
  }
  if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/humidity")) {
        humidity = fbdo.intData();
        Serial.print("Threshold humidity: ");
        Serial.println(humidity);
  } 
  else {
      Serial.println(fbdo.errorReason());
  }
  if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/soil")) {
        soil = fbdo.intData();
        Serial.print("Threshold soil: ");
        Serial.println(soil);
  } 
  else {
      Serial.println(fbdo.errorReason());
  }
  
  if (Firebase.RTDB.getInt(&fbdo, "auto/threshold/humidity2")) {
        humidity2 = fbdo.intData();
        Serial.print("Threshold humidity: ");
        Serial.println(humidity2);
  } 
  else {
      Serial.println(fbdo.errorReason());
  }
    //read data from dht11
    DHT.read(DHT11_PIN);
    Serial.print("temp:");
    Serial.print(DHT.temperature);
    Serial.print("humi:");
    Serial.println(DHT.humidity);
    if (DHT.humidity < humidity) {
      digitalWrite(HUMIDIFIER, LOW);
      digitalWrite(FAN2, HIGH);
    } else if (DHT.humidity > humidity && DHT.humidity < humidity2) {
      digitalWrite(HUMIDIFIER, HIGH);
      digitalWrite(FAN2, HIGH);
    } else {
      digitalWrite(HUMIDIFIER, HIGH);
      digitalWrite(FAN2, LOW);
    }

    if (DHT.temperature > temp) {
      digitalWrite(PELTIER, LOW);
      digitalWrite(FAN, LOW);
    }
     else {
      digitalWrite(PELTIER, HIGH);
      digitalWrite(FAN, HIGH);
    }
    delay(1000);
    //read data from resis􀆟ve soil moisture sensor
    sensor_analog = analogRead(sensor_pin);
    moisture_percentage = (100 - ((sensor_analog / 4095.00) * 100));
    // Serial.println(sensor_analog);
    Serial.print("Moisture Percentage = ");
    Serial.print(moisture_percentage);
    Serial.print("%\n\n");
    if (moisture_percentage < soil) {
      digitalWrite(PUMP, LOW);
    } else {
      digitalWrite(PUMP, HIGH);
    }
    delay(1000);
    // Write temperature and humidity data on the database path auto/dht
    if (Firebase.RTDB.setFloat(&fbdo,
                               "auto/dht/temp", DHT.temperature)
        && Firebase.RTDB.setFloat(&fbdo,
                                  "auto/dht/humidity", DHT.humidity)) {
      Serial.println("PASSED");
    } else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }
    // Write soil moisture data on the database path auto/soil
    if (Firebase.RTDB.setFloat(&fbdo, "auto/soil", moisture_percentage)) {
      Serial.println("PASSED");
    } else {
      Serial.println("FAILED");
      Serial.println("REASON: " + fbdo.errorReason());
    }

    
    // Serial.printf("Pump: ", Firebase.RTDB.getBool(&fbdo, F("manual/pump")) ? String(fbdo.to<bool>()).c_str() : fbdo.errorReason().c_str());
    // Serial.printf("Peltier: ", Firebase.RTDB.getBool(&fbdo, F("manual/peltier")) ? String(fbdo.to<bool>()).c_str() : fbdo.errorReason().c_str());
    // Serial.printf("Humidifer: ", Firebase.RTDB.getBool(&fbdo, F("manual/humidifier")) ? String(fbdo.to<bool>()).c_str() : fbdo.errorReason().c_str());
  }
}