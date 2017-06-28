/*
 *  This sketch sends a message to a TCP server
 *
 */

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <WiFiUDP.h>

// WiFi settings
const char* ssid = "VM6339503";
const char* password = "zdhzmcFCy2vr";

WiFiUDP UDP;

void setup() {
    Serial.begin(115200);
    delay(10);

    // We start by connecting to a WiFi network
    WiFi.begin(ssid, password);

    Serial.println();
    Serial.println();
    Serial.print("Wait for WiFi to connect to ");
    Serial.print(ssid);

    while(WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(50);
    }

    delay(100);
    
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());

    Serial.println("Sending button press message...");
    byte message[] = "doorbell-button-press";
    UDP.beginPacket("192.168.0.255",4950);
    UDP.write(message,sizeof(message));
    UDP.endPacket();
    Serial.println("sent!");

    delay(20);

    // Sleep
    Serial.println("ESP8266 in sleep mode");
    ESP.deepSleep(0);
}

void loop() {

}

