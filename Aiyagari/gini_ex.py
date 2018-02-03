''' This is an example of the Gini function using Census data 
    Apparently Census data is trickier to use than I thought so this is a work in progress
    If anyone knows why the variable S0102_C01_074E exists in the variable list but throws
    an error below let me know
'''
import json
import urllib
import pandas as pd
with urllib.request.urlopen("https://api.census.gov/data/2013/acs1?get=NAME,S0102_C01_074E&for=county:*&in=state:*") as url:
    DAT = json.load(url)
print(DAT)