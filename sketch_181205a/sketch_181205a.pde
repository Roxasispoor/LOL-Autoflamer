import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

IntList allies;
IntList enemies;
String [] Beginnings = {"Oh my god ", "How is it possible that ", "Never seen someone that ", "Hey ", "WTF ", "WOW...", "FFS "};
String [] Endings = {" uninstall pls", " kill yourself!!!", " you bad", " noob"};
Keyboard keyboard;
void setup() {
  allies = new IntList();
  enemies = new IntList();
      try
      {
        keyboard = new Keyboard();
        BlizzardCommunication bc=new BlizzardCommunication();
        bc.FillSteamID();
        println(bc.GetCurrentMatch());
        bc.GetPlayers(bc.GetCurrentMatch());
        println(enemies.get(1));
        TypeComplexInsult("you were killed 20 times");
      // keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
}
public void TypeSimpleInsult(String statInsult){
keyboard.type(statInsult);
}
public void TypeComplexInsult(String statInsult){
  int a = (int) Math.random()*(Beginnings.length-1);
  int b = (int) Math.random()*(Endings.length-1);
  CharSequence message = Beginnings[a]+statInsult+Endings[b];
  keyboard.type(message);

    }
