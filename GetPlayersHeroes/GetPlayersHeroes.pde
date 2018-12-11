import processing.net.*;

long matchId;
IntList allies;
IntList enemies;
JSONObject matchData;
JSONArray playersList;

void GetPlayers()
{
  matchId = 4265956769L;
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
