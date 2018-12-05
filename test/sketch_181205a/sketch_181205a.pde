import processing.serial.*;
import cc.arduino.*;
//import hypermedia.net.*;
Arduino arduino;

int inPindB=0;
int inPinPressure=1;

int normaldB = 58;
int normalPressure = 0;
int triggerPressure = 300;

int historicSize = 50;

class SensorData {
  public int dB;
  public int pressure;
}

ArrayList<SensorData> SensorHistoric;


void setup()
{
  //noLoop();
  SensorHistoric = new ArrayList<SensorData>();
  
  arduino=new Arduino(this,Arduino.list()[0],57600);
  arduino.pinMode(inPindB,Arduino.INPUT);
  arduino.pinMode(inPinPressure,Arduino.INPUT);
  size(0,0);
}

void readSensors() {
  SensorData newData = new SensorData();
  newData.dB = arduino.analogRead(inPindB);
  newData.pressure = arduino.analogRead(inPinPressure);
  
  SensorHistoric.add(newData);
  // println(newData.pressure + "\n");
}

boolean proceedData() {
  boolean r = false;
  
  if(SensorHistoric.size() > historicSize) {
    SensorHistoric.remove(0);
    
    int dBSum = 0;
    int pressureSum = 0;
  
    for(int i = 0; i < SensorHistoric.size(); ++i) {
      dBSum += SensorHistoric.get(i).dB;
      pressureSum += SensorHistoric.get(i).pressure;
    }
  
    r =  dBSum / SensorHistoric.size() > normaldB * 4 
      || pressureSum / SensorHistoric.size() > triggerPressure;
  
    if(r) {
      SensorHistoric.clear();
    }
  }
  
  
  
  return r;
}
void draw() {
  readSensors();
  if(proceedData()){
    println("Rage !!!!!!!");
  }
}
