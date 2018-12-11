import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

// Pin analogue des capteurs
int inPindB=0;
int inPindB2= 2;
int inPinPressure=1;

int inDigPindB = 12;

//  Pin nimérique de la led
int outPinLED = 13;

//  Valeur normale des capteurs (initialisee plus tard)
float normaldB1 = 0;
float normaldB2 = 0;
int normalPressure = 0;

float maxdB1 = 0;
float maxdB2 = 0;
int maxPressure = 0;

//  Valeur de trigger de la pression
int triggerPressure = 800;

//  Permet de savoir s'il faut initialiser les valeurs normale
boolean isInitialized = false;

//  Taille du buffer
int historicSize = 20;

//  Classe contenant les donnees recuperees à chaque tic
class SensorData {
  public float dB;
  public float dB2;
  public int pressure;
}

//  Buffer
ArrayList<SensorData> SensorHistoric;
JSONArray heroes;
BlizzardCommunication bc;

void setup()
{
  
  heroes = loadJSONArray("https://api.opendota.com/api/heroes");
      try
      {
        Keyboard keyboard = new Keyboard();
        bc=new BlizzardCommunication();
        bc.FillSteamID();
        
        bc.GetCurrentMatch();
   
       // println(bc.injureOurTeam());
        //Initialize
       // bc.GetPlayers(bc.GetCurrentMatch());
        //println(enemies.get(3));
        //println(bc.GetChampion(bc.allies.getJSONObject(0)));
     println(bc.MinMaxLastChat());
     
     //   keyboard.type(bc.injureOurTeam());
     
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
  //noLoop();
  SensorHistoric = new ArrayList<SensorData>();
  arduino=new Arduino(this,Arduino.list()[0],57600);
  //  Pin input
  arduino.pinMode(inPindB,Arduino.INPUT);
  arduino.pinMode(inPindB2,Arduino.INPUT);
  arduino.pinMode(inPinPressure,Arduino.INPUT);
  arduino.pinMode(inDigPindB,Arduino.INPUT);
  // Pin output
  arduino.pinMode(outPinLED, Arduino.OUTPUT);
       
   
}

//  Lit les capteurs et stocke les valeurs dans le buffer
void readSensors() {
  SensorData newData = new SensorData();
  newData.dB = arduino.analogRead(inPindB);
  newData.dB2 = arduino.analogRead(inPindB2);
  newData.pressure = arduino.analogRead(inPinPressure);
  
  SensorHistoric.add(newData);
  
  if(maxdB1 < newData.dB) maxdB1 = newData.dB;
  if(maxdB2 < newData.dB2) maxdB2 = newData.dB2;
  if(maxPressure < newData.pressure) maxPressure = newData.pressure;
  
  println("dB 1 : " + newData.dB + " ; Max : " + maxdB1);
  println("dB 2 : " + newData.dB2 + " ; Max : " + maxdB2);
  // println("dB 1 digital : " + (float)arduino.digitalRead(inDigPindB));
  println("pressure : " + newData.pressure + " ; Max : " + maxPressure + "\n");
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
    r =  SensorHistoric.get(SensorHistoric.size() - 1).dB >= normaldB1 + 4.f 
      || SensorHistoric.get(SensorHistoric.size() - 1).dB2 >= normaldB2 + 4.f
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
        println(bc.injureOurTeam());
    turnLightOn();
  }
}
