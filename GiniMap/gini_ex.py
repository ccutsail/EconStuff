''' This is an example of the Gini function using Census data
    It pulls income and population for all US states, then restricts to 
'''
import json
import urllib
import pandas as pd
import gini as g
import numpy as np
import matplotlib.pyplot as plt

with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)



pdData = pd.DataFrame(DAT)
pdData.columns = pdData.iloc[0]
pdData.reindex(pdData.index.drop(0))
pdData["K200001_001E"] = pd.to_numeric(pdData["K200001_001E"],errors='coerce')
pdData["K201901_001E"] = pd.to_numeric(pdData["K201901_001E"],errors='coerce')
pdData["INCPERCAPITA"] = pdData["K201901_001E"]/pdData["K200001_001E"]
pdData = pdData[~pdData.astype(str).eq('None').any(1)]
pdData["K200001_001E"] = pd.to_numeric(pdData["K200001_001E"],errors='coerce')
pdData["K201901_001E"] = pd.to_numeric(pdData["K201901_001E"],errors='coerce')
# pdData["log_income"] = np.log(pdData["K201901_001E"])
pdData = pdData.dropna(axis=0,how='any')
pdData_PA = pdData.loc[pdData["STATE"]=='42']

print(g.ginicoefficient(pdData_PA["K200001_001E"],pdData_PA["K201901_001E"]))
