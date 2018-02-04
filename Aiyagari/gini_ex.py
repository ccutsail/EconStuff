''' This is an example of the Gini function using Census data
    currently troubleshooting the gini function --
    not 100% sure its returning the right value
'''
import json
import urllib
import pandas as pd
import numpy as np
import gini as g
with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)
TAB = np.array([0, 0])
for i in range(1, len(DAT)):
    if(DAT[i][2] is not None and DAT[i][1] is not None):
        appender = [int(DAT[i][2]), int(DAT[i][1])]
        TAB = np.vstack([TAB, appender])

print(g.ginicoefficient(TAB[:, [0]], TAB[:, [1]]))
