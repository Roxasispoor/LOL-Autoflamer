import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// Pin analogue des capteurs
int inPindB=0;
int inPindB2= 2;
int inPinPressure=1;
//  Pin nimérique de la led
int outPinLED = 13;

//  Valeur normale des capteurs (initialisee plus tard)
float normaldB1 = 0;
float normaldB2 = 0;
int normalPressure = 0;

//  Valeur de trigger de la pression
int triggerPressure = 300;

//  Permet de savoir s'il faut initialiser les valeurs normale
boolean isInitialized = false;

//  Taille du buffer
int historicSize = 50;

//  Classe contenant les donnees recuperees à chaque tic
class SensorData {
  public float dB;
  public float dB2;
  public int pressure;
}

//  Buffer
ArrayList<SensorData> SensorHistoric;


void setup()
{
  //noLoop();
  SensorHistoric = new ArrayList<SensorData>();
  arduino=new Arduino(this,Arduino.list()[0],57600);
  //  Pin input
  arduino.pinMode(inPindB,Arduino.INPUT);
  arduino.pinMode(inPindB2,Arduino.INPUT);
  arduino.pinMode(inPinPressure,Arduino.INPUT);
  // Pin output
  arduino.pinMode(outPinLED, Arduino.OUTPUT);

  //  ça faudrait le virer
  size(0,0);
}

//  Lit les capteurs et stocke les valeurs dans le buffer
void readSensors() {
  SensorData newData = new SensorData();
  newData.dB = arduino.analogRead(inPindB);
  newData.dB2 = arduino.analogRead(inPindB2);
  newData.pressure = arduino.analogRead(inPinPressure);
  
  SensorHistoric.add(newData);
  
  println("dB 1 : " + newData.dB);
  println("dB 2 : " + newData.dB2);
  println("pressure : " + newData.pressure + "\n");
}

//  Analyse les données du buffer, renvoie true si l'utilisateur rage
boolean proceedData() {
  boolean r = false;

  //  l'analyse ne se fait que si le buffer a une taille suffisante
  if(SensorHistoric.size() > historicSize) {

    // Si l'initialisation n'a pas été fait on la fait a partir des premières valeurs du buffer
    if(!isInitialized) {
      initializedNormal();
    }
    
    SensorHistoric.remove(0);
    
    float dBSum1 = 0;
    float dBSum2 = 0;
    int pressureSum = 0;
    
    println("normal dB 1 : " + normaldB1);
    println("normal dB 2 : " + normaldB2);
    println("normal pressure : " + normalPressure + "\n\n");
  
    for(int i = 0; i < SensorHistoric.size(); ++i) {
      dBSum1 += SensorHistoric.get(i).dB;
      dBSum2 += SensorHistoric.get(i).dB2;
      pressureSum += SensorHistoric.get(i).pressure;
    }
  
    //  Test si les capteurs dépassent les valeurs de seuil
    r =  dBSum1 / SensorHistoric.size() >= normaldB1 + 2.f 
      || dBSum2 / SensorHistoric.size() >= normaldB2 + 2.f
      || pressureSum / SensorHistoric.size() > triggerPressure;
  
    if(r) {
      SensorHistoric.clear();
    }
  }  
  
  return r;
}

//  Fonction d'initialisation
void initializedNormal() {
  normaldB1 = 0;
    normaldB2 = 0;
    normalPressure = 0;
    for(int i = 0; i < SensorHistoric.size(); ++i) {
      normaldB1 += SensorHistoric.get(i).dB;
      normaldB2 += SensorHistoric.get(i).dB2;
      normalPressure += SensorHistoric.get(i).pressure;
    }
    normaldB1 /= SensorHistoric.size();
    normaldB2 /= SensorHistoric.size();
    normalPressure /= SensorHistoric.size();
    
    isInitialized = true;
}

//  Allume la led quand l'utilisateur rage 
//  Attention méthode synchrone
void turnLightOn() {
     arduino.digitalWrite(outPinLED, Arduino.HIGH); //LED turns on
     delay(500);
     arduino.digitalWrite(outPinLED, Arduino.LOW); //LED turns off
     
}

//  Main loop
void draw() {
  readSensors();
  if(proceedData()){
    println("Rage !!!!!!!");
    turnLightOn();
  }
}
