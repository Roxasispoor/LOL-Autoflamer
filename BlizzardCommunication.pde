import java.awt.*;
public class BlizzardCommunication {

    private String apiKey="RGAPI-fb66faaf-5446-44a4-b5c6-0258c1f6e765";
    private String summonerName="missingk";
    private String summonerSteamId="";
   // public static int totalrequest = 0;
    public JSONObject match;
    public void FillSteamID()
    {
      
      XML xml = loadXML("https://steamcommunity.com/id/" + summonerName + "?xml=1");
      XML[] children =xml.getChildren("steamID64");
      long steamid64ffs = Long.parseLong(children[0].getContent());
      println(steamid64ffs);
      long substract = 76561197960265728l;
      summonerSteamId = String.format ("%d", steamid64ffs-substract);
      println(summonerSteamId);
    
    
    }
    
    public long GetCurrentMatch()
    {
     println(summonerSteamId);
       JSONObject match = loadJSONArray("https://api.opendota.com/api/players/" + summonerSteamId + "/recentMatches").getJSONObject(0);
       
    if (match == null) {
    println("JSONObject could not be parsed");
    return 0;
  } 
  else {
     println("Hello there"); 
    return match.getLong("match_id"); 
  }
   }
   
    public void GetPlayers(long matchId)
    {
      JSONArray playersList;
      matchData = loadJSONObject("https://api.opendota.com/api/matches/" + matchId);
      playersList = matchData.getJSONArray("players");
 
      for (int i = 0; i<10;i++) {
        if (playersList.getJSONObject(i).getBoolean("isRadiant") == true) {
            allies.append(playersList.getJSONObject(i).getInt("hero_id"));
        }
        else if (playersList.getJSONObject(i).getBoolean("isRadiant") == false) {
            enemies.append(playersList.getJSONObject(i).getInt("hero_id")); 
        }

      }
    }
    
}
