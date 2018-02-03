''' This is an example of the Gini function using Census data 
    Apparently Census data is trickier to use than I thought so this is a work in progress
    If anyone knows why the variable S0102_C01_074E exists in the variable list but throws
    an error below let
'''
import json
import urllib
import pandas as pd
import numpy as np
import gini as g
#with urllib.request.urlopen("https://api.census.gov/data/2015/acs/acs5?get=STATE,S0102_C01_074E&S0102_C01_074E&for=county:*&in=state:01") as url:
with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)

tab = np.column_stack((np.asarray([item[2] for item in DAT],int),np.asarray([item[1] for item in DAT],int)))
print(tab)
