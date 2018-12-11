import static java.awt.event.KeyEvent.*;
import java.awt.Robot;

JSONArray allies;
JSONArray enemies;
JSONArray heroes;

void setup() {
  allies = new JSONArray();
  enemies = new JSONArray();
  heroes = loadJSONArray("https://api.opendota.com/api/heroes");
      try
      {
        Keyboard keyboard = new Keyboard();
        BlizzardCommunication bc=new BlizzardCommunication();
        bc.FillSteamID();
        //println(bc.GetCurrentMatch());
        bc.GetPlayers(bc.GetCurrentMatch());
        //println(enemies.get(3));
        println(bc.GetChampion(allies.getJSONObject(0)));
        
      // keyboard.type("Hello there, how are you?");  
    }
       catch (AWTException e)
    {
    e.printStackTrace();
    }
       
    }
