/*
* oscP5 library by Andreas Schlegel
* oscP5 website at http://www.sojamo.de/oscP5
*/
import oscP5.*;
import netP5.*;

import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
  
OscP5 oscP5;
NetAddress myRemoteLocation;
int toggle = 0;
int pin = 12;
String[] IP = {"127.0.0.1","192.168.43.1"};

void setup() {
  size(400,400);
  frameRate(60);
  oscP5 = new OscP5(this,3200);
  
  myRemoteLocation = new NetAddress(IP[0],12000);
  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(pin, Arduino.OUTPUT);
}


void draw() {
  background(0);  
  float Sensor = arduino.analogRead(0);
  float Sensor4 = arduino.analogRead(3);
  //float count = 50.0;
  //println(flexiforceSensor);
  sendValue(map(Sensor,0,1024,1,-1), map(Sensor4,0,1024,-1,1));
}

void sendValue(float sensorValue,float sensorValue4) {
  OscMessage oscMess = new OscMessage("/counterTest");//("/flexiforce");
  oscMess.add(sensorValue);
  oscMess.add(sensorValue4);

  oscP5.send(oscMess, myRemoteLocation);
  println(sensorValue); 
  println(sensorValue4); 
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  int rel = theOscMessage.get(0).intValue();
  
  
  if (rel == 1 && toggle == 0){
    arduino.digitalWrite(pin, Arduino.HIGH);
    println("ON");
    toggle = 1;
  }else{
    arduino.digitalWrite(pin, Arduino.LOW);
    println("OFF");
    toggle = 0;
  }
  
  
}
