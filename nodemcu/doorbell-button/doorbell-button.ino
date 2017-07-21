#include <WiFiServer.h>
#include <WiFiClientSecure.h>
#include <ESP8266WiFiAP.h>
#include <ESP8266WiFiGeneric.h>
#include <ESP8266WiFiScan.h>
#include <ESP8266WiFiType.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <ESP8266WiFiSTA.h>
#include <WiFiClient.h>


/*
 *  This sketch sends a message to a TCP server
 *
 */

// WiFi settings
// jules's house
//const char* ssid = "VM6339503";
//const char* password = "zdhzmcFCy2vr";
//sky 4 desk
//const char* ssid = "SKYFB337";
//const char* password = "XDSUPDAU";
// in the home office
const char* ssid="mitchsoft";
const char* password="davethecat";

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

    // Sleep - pull the reset pin low to restart
    Serial.println("ESP8266 in sleep mode");
    ESP.deepSleep(0);
}

void loop() {

}

