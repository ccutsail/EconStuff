from sklearn import datasets
import pandas as pd
from nba_py import team

clips = team.TeamLineups(1610612746)

isBlakeGood = team.TeamVsPlayer(1610612746,201933)

print(isBlakeGood.shot_distance_off_court().head(10),isBlakeGood.shot_distance_on_court().head(10))