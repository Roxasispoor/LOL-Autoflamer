import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

void setup() {
      try
      {
        Keyboard keyboard = new Keyboard();
        BlizzardCommunication bc=new BlizzardCommunication();
        bc.FillSteamID();
        println(bc.GetCurrentMatch());
        
      // keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
       
    }
