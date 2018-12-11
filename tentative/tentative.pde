import java.awt.*;

class Tentative {
    private JSONObject _matchData;
    private ArrayList<JSONArray> playersList;
    private long _playerId;
    private int injureNumber = 2;
    int ourTeam;

    public Tentative (JSONObject matchData, int playerId) {
        _playerId = playerId;
        _matchData = matchData;
        JSONArray temp = matchData.getJSONArray("players");
        playersList = new ArrayList<JSONArray>();   
        playersList.add(new JSONArray());
        playersList.add(new JSONArray());
        for(int i = 0; i < temp.size(); i++) {
            if (temp.getJSONObject(i).getBoolean("isRadiant") == true) {
                playersList.get(0).append(temp.getJSONObject(i));
                if(temp.getJSONObject(i).getInt("account_id") == playerId) ourTeam = 0;
            }
            else if (temp.getJSONObject(i).getBoolean("isRadiant") == false) {
                playersList.get(1).append(temp.getJSONObject(i));
                if(temp.getJSONObject(i).getInt("account_id") == playerId) ourTeam = 0;
            }
        }
    }

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
    
    public String injureOurTeam() {
      String result = "";
      int seed = (int)(Math.random() * (injureNumber + 1));
      switch(seed) {
        case 0 :
          result = "Stop suiciding you " + getMinKDA(ourTeam).getString("personaname") + " !!!!!!!";
          break;
        case 1 :
          result = "F***, " + getMinXP(ourTeam).getString("personaname") + ", try to pex !!!!!!!";
          break;
        default: break;
      }
      
      return result;
    }
    
    public String injureOtherTeam() {
      String result = "";
      int seed = (int)(Math.random() * (injureNumber + 1));
      switch(seed) {
        case 0 :
          result = "" + getMaxKDA((ourTeam + 1) % 2).getString("personaname") + " FOCUS !!!!!!!";
          break;
        case 1 :
          result = "F***, " + getMaxXP((ourTeam + 1) % 2).getString("personaname") + ", cheater !!!!!!!";
          break;
        default: break;
      }
      
      return result;
    }
}
 
