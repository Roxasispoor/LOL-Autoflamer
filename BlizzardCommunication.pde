import java.awt.*;
public class BlizzardCommunication {

    private String apiKey="RGAPI-fb66faaf-5446-44a4-b5c6-0258c1f6e765";
    private String summonerName="Mixalich";
     private String summonerSteamId=;
    public static int totalrequest=0;
    public JSONObject match;
    public void FillSteamID()
    {
      xml = loadXML("https://steamcommunity.com/id/"+summonerName"?xml=1");
      XML[] children =xml.getChildren("steamID64") ;
      summonerSteamId=children[0] - 76561197960265728;
    
    }
    
    public void GetCurrentMatch()
    {
       https://api.opendota.com/api/players/{account_id}/recentMatches

Response samples


       match = parseJSONObject(data);
    if (json == null) {
    println("JSONObject could not be parsed");
  } 
  else {
    String players = match.getString("players");
    println(players);
  }
}
    }
}
