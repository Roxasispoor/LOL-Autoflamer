import java.awt.*;
public class BlizzardCommunication {

    private String apiKey="RGAPI-fb66faaf-5446-44a4-b5c6-0258c1f6e765";
    private String summonerName="missingk";
    private String summonerSteamId="";
    public JSONObject match;
    private ArrayList<JSONArray> playersList;
    private long playerId;
    private int injureNumber = 2;
    int ourTeam;

   
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
      int seed = (int)(Math.random() * 3);
      switch(seed) {
        case 0 :
          result = "Stop suiciding you " + getName(getMinKDA(ourTeam)) + " !!!!!!!";
          break;
        case 1 :
          result = "F***, " + getName(getMinXP(ourTeam)) + ", try to pex !!!!!!!";
          break;
        case 2 :
          JSONObject playerToInjure = getBot(ourTeam);
          if(playerToInjure != null) {
            result = "F***ing bot " + getName(playerToInjure) + " !!!!!!!";
          }
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
      int seed = (int)(Math.random() * 4;
      switch(seed) {
        case 0 :
          result = "" + getName(getMaxKDA((ourTeam + 1) % 2)) + " FOCUS !!!!!!!";
          break;
        case 1 :
          result = "F***, " + getName(getMaxXP((ourTeam + 1) % 2)) + ", cheater !!!!!!!";
          break;
        case 2 :
          JSONObject playerToInjure = getBot((ourTeam + 1) % 2);
          if(playerToInjure != null) {
            result = "F***ing bot " + getName(playerToInjure) + " !!!!!!!";
          }
          break;
        case 3 :
          result = "with" + getName(getMaxKill((ourTeam + 1) % 2)) + ", we take you 2v8 !!!!!!!";
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
    
    public long GetCurrentMatch()
  {
     println(summonerSteamId);
     JSONObject matchData = loadJSONArray("https://api.opendota.com/api/players/" + summonerSteamId + "/recentMatches").getJSONObject(0);  
     if (matchData == null) 
     {
        println("JSONObject could not be parsed");
        return 0;
     } 
    else 
    {
     println("Hello there"); 
   
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
           println("Hello there 1.5"); 
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
         println("Hello there 2"); 
   return matchData.getLong("match_id");
  }
   
   /* public void GetPlayers(long matchId)
    {
      Boolean playerSide = false;
      JSONArray playersList;

      matchData = loadJSONObject("https://api.opendota.com/api/matches/" + matchId);
      playersList = matchData.getJSONArray("players");
 
      for (int i = 0; i<10;i++) {
        int idSummoner = Integer.parseInt(summonerSteamId);
        if (playersList.getJSONObject(i).get("account_id") instanceof Integer) {
          println("Cest un entier");
        }
        if (playersList.getJSONObject(i).getInt("account_id") == idSummoner) {
          playerSide = playersList.getJSONObject(i).getBoolean("isRadiant");
        }
      }

      for (int i = 0; i<10;i++) {
        if (playersList.getJSONObject(i).getBoolean("isRadiant") == playerSide) {
          allies.append(playersList.getJSONObject(i));
        }
        else if (playersList.getJSONObject(i).getBoolean("isRadiant") != playerSide) {
            enemies.append(playersList.getJSONObject(i)); 
        }
      }
    }
*/
   public String GetRandomInsultNoStart()
   {
     return "";
   }
   public String GetRandomInsult()
   {
     return "";
   }
   public String GetMostPing()
   {
     JSONArray allies=null;
     int maxPing=0;
     JSONObject maxPinger=null;
     for (int i=0; i < allies.size(); i++) 
     {
       int numberOfPings = allies.getJSONObject(i).getInt("pings");
        if(numberOfPings>maxPing)
        {
          maxPinger = allies.getJSONObject(i);
          maxPing = numberOfPings;
        }
    }
    if(maxPing==0)
    {
      return "If any of you guys ping me I ragequit";
    }
    else
    {
      return "If you ping only once more" + GetChampion(maxPinger) + "I quit";
    }
  }
 
}
