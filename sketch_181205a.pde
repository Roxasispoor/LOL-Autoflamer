import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

IntList allies;
IntList enemies;

void setup() {
  allies = new IntList();
  enemies = new IntList();
      try
      {
        Keyboard keyboard = new Keyboard();
        BlizzardCommunication bc=new BlizzardCommunication();
        bc.FillSteamID();
        println(bc.GetCurrentMatch());
        bc.GetPlayers(bc.GetCurrentMatch());
        println(enemies.get(1));
        
      // keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
       
    }
