import java.awt.*;
import java.io.*;
public class BlizzardCommunication {

    private String apiKey="RGAPI-fb66faaf-5446-44a4-b5c6-0258c1f6e765";
    private String summonerName="missingk";
    private String summonerSteamId="";
    public JSONObject match;
    private ArrayList<JSONArray> playersList;
    private long playerId;
    private int injureNumber = 2;
    int ourTeam;
    String [] Beginnings = {"Oh my god ", "How is it possible that ", "Hey! ", "WTF ", "WOW! ", "FFS "};
    String [] Endings = {" uninstall pls", " kill yourself!!!", " you bad!", " fakn noob", ", going AFK", " stop it, get some help"};
    String beginning = "";
    String ending = "";

   
    private JSONObject getMinKDA(int team) {
        int minKDA = 1000;
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            int kda = playersList.get(team).getJSONObject(i).getInt("kda");
            if(kda < minKDA) {
                minKDA = kda;
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }
    
      private JSONObject getMaxKDA(int team) {
        int maxKDA = 0;
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            int kda = playersList.get(team).getJSONObject(i).getInt("kda");
            if(kda > maxKDA) {
                maxKDA = kda;
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }

    private JSONObject getMinXP(int team) {
        int minXP = 1000000000;
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            int xp = playersList.get(team).getJSONObject(i).getInt("total_xp");
            if(xp < minXP) {
                minXP = xp;
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }

    private JSONObject getMaxXP(int team) {
        int maxXP = 0;
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            int xp = playersList.get(team).getJSONObject(i).getInt("total_xp");
            if(xp > maxXP) {
                maxXP = xp;
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }


    private JSONObject getBot(int team) {
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            if(playersList.get(team).getJSONObject(i).isNull("account_id")) {
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }

    private JSONObject getMaxKill(int team) {
        int maxKill = 0;
        JSONObject playerToInjure = null;
        for(int i = 0; i < playersList.get(team).size(); i++) {
            int kill = playersList.get(team).getJSONObject(i).getInt("kills");
            if(kill > maxKill) {
                maxKill = kill;
                playerToInjure = playersList.get(team).getJSONObject(i);
            }
        }
        
        return playerToInjure;
    }

  
    
    public String injureOurTeam() {
      String result = "";
      int seed = (int)(Math.random() * 4);
      if (seed<=1){
      beginning = Beginnings[int(random(Beginnings.length))];
      ending = Endings[int(random(Endings.length))];
      }
      println("seed = "+seed);
      switch(seed) {
        case 0 :
          result =  beginning + getName(getMinKDA(ourTeam)) + " feeds AF!!!" + ending;
          break;
        case 1 :
          result =  beginning + getName(getMinXP(ourTeam)) + " cant soak xp!!" + ending;
          break;
        case 2 :
          JSONObject playerToInjure = getBot(ourTeam);
          if(playerToInjure != null) {
            result = "F***ing bot " + getName(playerToInjure) + "!!!!!!!";
          }
          else{
            result = "go play tetris!";
          }
          break;
        case 3 : 
        result = GetMostPing(ourTeam);
        break;
         case 4 : 
        result = MinMaxLastChat();
        break;

        default: break;
      }
      
      return result;
    }


    public String getName(JSONObject player) {
      if(player.isNull("personaname"))
        return GetChampion(player);
      return player.getString("personaname");
    }

    public String GetChampion(JSONObject player) {
      int id;
      String name;
      id = player.getInt("hero_id");
      if (id < 0 || id > 121) {
          println("Champion does not exist");
          return "No champion"; 
      }
      if ( id > 23) {
          id--; 
      }
      if (id > 112) {
          id = id - 4; 
      } 
      name = heroes.getJSONObject(id - 1).getString("localized_name");
      return name;
    }
    
    public int GetLaneEfficiency(JSONObject player) {
      float efficiency;
      int result = 0;
      efficiency = player.getFloat("lane_efficiency");
      if (efficiency < 0.7) {
          result = 1;
      }
      if (efficiency > 0.7) {
          result = 0;
      }
      return result;
    }

    public String injureOtherTeam() {
      String result = "";
      int seed = (int)(Math.random() * 4);
      if (seed<=1)
      {
        beginning = Beginnings[int(random(Beginnings.length))];
        ending = Endings[int(random(Endings.length))];
      }
    println("seed = "+seed);
      switch(seed) {
        case 0 :
          result = beginning + getName(getMinKDA((ourTeam + 1) % 2)) + " just cant play!!!" + ending;
          break;
        case 1 :
        String name =getName(getMaxXP((ourTeam + 1) % 2)).replaceAll( "[^a-zA-Z0-9 !*]" , "" );
        println(name);
        if (name.equals(""));
        {
        name = GetChampion(getMaxXP((ourTeam + 1) % 2));
        }
          result = beginning + name + " only knows how to cheat!" + ending;
          break;
        case 2 :
          JSONObject playerToInjure = getBot((ourTeam + 1) % 2);
          if(playerToInjure != null) {
            result = "F***ing bot " + getName(playerToInjure) + "noob!!!!!!! get rekt";
          }
          else{
            result = "go play tetris!";
          }
          break;
        case 3 :
        String name2 =getName(getMaxXP((ourTeam + 1) % 2)).replaceAll( "[^a-zA-Z0-9 !*]" , "" );
        println(name2);
        if (name2.equals(""));
        {
        name2 = GetChampion(getMaxKill((ourTeam + 1) % 2));
        }
          result = "with " + name2 + ", we take you 2v8 !!!!!!!";
          break;
        default: break;
      }
      
      return result;
    }

 
    public void FillSteamID()
    {
      
      XML xml = loadXML("https://steamcommunity.com/id/" + summonerName + "?xml=1");
      XML[] children =xml.getChildren("steamID64");
      long steamid64ffs = Long.parseLong(children[0].getContent());
      println(steamid64ffs);
      long substract = 76561197960265728l;
      playerId=steamid64ffs-substract;
      summonerSteamId = String.format ("%d",playerId );
      println(summonerSteamId);
    
    
    }
  public void FillSteamIDDemo()
  {
  summonerSteamId="397574220";
  }
  public long GetCurrentMatchDemo()
  {
         playersList = new ArrayList<JSONArray>();   
      playersList.add(new JSONArray());
      playersList.add(new JSONArray());
      match = loadJSONObject("https://api.opendota.com/api/matches/" + "4136801721");
      if(match==null)
      {
        println("match not found");
      }
     JSONArray temp = match.getJSONArray("players");
    if(temp==null)
     {
       println("error");
       return 0;  
   }
      for(int i = 0; i < temp.size(); i++) 
      {
   //        println("Hello there 1.5"); 
            if (temp.getJSONObject(i).getBoolean("isRadiant") == true) 
            {
                playersList.get(0).append(temp.getJSONObject(i));
                if(!temp.getJSONObject(i).isNull("account_id") && ((Integer) temp.getJSONObject(i).get("account_id")).intValue() ==  playerId) ourTeam = 0;
            }
            else if (temp.getJSONObject(i).getBoolean("isRadiant") == false)
            {
                playersList.get(1).append(temp.getJSONObject(i));
                if( !temp.getJSONObject(i).isNull("account_id") && ((Integer) temp.getJSONObject(i).get("account_id")).intValue() ==  playerId) ourTeam = 1;
            }
        }
        ourTeam = 1;
         println("Our team" + ourTeam); 
   return 4136801721l;
    
  }
    public long GetCurrentMatch()
  {
     println(summonerSteamId);
     JSONObject matchData = loadJSONArray("https://api.opendota.com/api/players/" + summonerSteamId + "/recentMatches").getJSONObject(0);  
     if (matchData == null) 
     {
        println("JSONObject could not be parsed");
        return 0;
     } 
   
    
      playersList = new ArrayList<JSONArray>();   
      playersList.add(new JSONArray());
      playersList.add(new JSONArray());
     println(matchData.getLong("match_id"));
      match = loadJSONObject("https://api.opendota.com/api/matches/" + matchData.getLong("match_id"));
      if(match==null)
      {
        println("match not found");
      }
     JSONArray temp = match.getJSONArray("players");
    if(temp==null)
     {
       println("error");
       return 0;  
   }
      for(int i = 0; i < temp.size(); i++) 
      {
   //        println("Hello there 1.5"); 
            if (temp.getJSONObject(i).getBoolean("isRadiant") == true) 
            {
                playersList.get(0).append(temp.getJSONObject(i));
                if(!temp.getJSONObject(i).isNull("account_id") && ((Integer) temp.getJSONObject(i).get("account_id")).intValue() ==  playerId) ourTeam = 0;
            }
            else if (temp.getJSONObject(i).getBoolean("isRadiant") == false)
            {
                playersList.get(1).append(temp.getJSONObject(i));
                if( !temp.getJSONObject(i).isNull("account_id") && ((Integer) temp.getJSONObject(i).get("account_id")).intValue() ==  playerId) ourTeam = 1;
            }
        }
         //println("Hello there 2"); 
   return matchData.getLong("match_id");
  }
   
   public String MinMaxLastChat()
   {
     JSONArray chat= match.getJSONArray("chat");
   
     String r = "";
       String s="";
     for (int z= chat.size()-1;z>0;z--)
     {
        if(chat.getJSONObject(z).getString("type").equals("chat"))
        {
          s= chat.getJSONObject(z).getString("key");
         break;
        }
     }
   //  s="patate is life";
     for (int i = 0; i < s.length(); i++) 
     {
    if (i % 2 == 0) {
        r += s.substring(i, i + 1).toUpperCase();
    } 
    else {
        r += s.substring(i, i + 1);
    }
    }
     if(r=="")
     {
       return "Don't you bunch of tards know how to write?!";
     }
     return r;
   }

   public String GetMostPing(int team)
   {
    
     int maxPing=0;
     JSONObject maxPinger=null;
     for (int i=0; i < playersList.get(team).size(); i++) 
     {
       int numberOfPings = playersList.get(team).getJSONObject(i).getInt("pings");
        if(numberOfPings>maxPing)
        {
          maxPinger = playersList.get(team).getJSONObject(i);
          maxPing = numberOfPings;
        }
    }
    if(maxPing==0)
    {
      return "If any of you guys ping me I ragequit";
    }
    else
    {
      String str =  "If " + GetChampion(maxPinger) + " pings just once more I quit";
      return str;
    }
  }
 public String Yell(){
   if (Math.random()<=0.5)
   {
     println("insulting them");
     return injureOtherTeam();
   }
   else
   {
     println("insulting us");
     return injureOurTeam();
   }
 }
}
