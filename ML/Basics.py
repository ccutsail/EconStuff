import pandas as pd
import nba_py
from nba_py import player
import altair as plt
import pprint

#clips = team.TeamSummary(1610612746)
#ptDiff = clips.season_ranks()["PTS_PG"]-clips.season_ranks()["OPP_PTS_PG"]
# blake = team.TeamVsPlayer(1610612746,201933)
# pprint(blake.on_off_court()["W"]/blake.on_off_court()["GP"])

blakeCareer = nba_py.player.PlayerCareer(201933)

careerAvg = blakeCareer.regular_season_career_totals()

careerLog = nba_py.player.PlayerGameLogs(201933)

df = pd.read_json(careerLog.json)

list(df.columns)