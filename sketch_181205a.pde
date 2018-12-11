import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

JSONArray heroes;

void setup() {
  heroes = loadJSONArray("https://api.opendota.com/api/heroes");
      try
      {
        Keyboard keyboard = new Keyboard();
        BlizzardCommunication bc=new BlizzardCommunication();
        bc.FillSteamID();
        
        bc.GetCurrentMatch();//Initialize
       // bc.GetPlayers(bc.GetCurrentMatch());
        //println(enemies.get(3));
        //println(bc.GetChampion(bc.allies.getJSONObject(0)));
        
      // keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
       
    }
