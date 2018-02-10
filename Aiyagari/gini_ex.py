''' This is an example of the Gini function using Census data
    currently troubleshooting the gini function --
    not 100% sure its returning the right value
'''
import json
import urllib
import pandas as pd
import gini as g

with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)


pdData = pd.DataFrame(DAT)
pdData.columns = pdData.iloc[0]
pdData.reindex(pdData.index.drop(0))
pdData["K200001_001E"] = pd.to_numeric(pdData["K200001_001E"],errors='coerce')
pdData["K201901_001E"] = pd.to_numeric(pdData["K201901_001E"],errors='coerce')
pdData["INCPERCAPITA"] = pdData["K201901_001E"]/pdData["K200001_001E"]

print(g.ginicoefficient(pdData["K200001_001E"],pdData["INCPERCAPITA"]))
