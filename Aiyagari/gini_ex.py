''' This is an example of the Gini function using Census data
    currently troubleshooting the gini function --
    not 100% sure its returning the right value
'''
import json
import urllib
import pandas as pd
import numpy as np
import gini as g
from mpl_toolkits.basemap import Basemap
import someoneelsesmaps as sem
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection

state_topo = r'us_states.topo.json'
county_topo = r'us_counties.topo.json'
with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)

pdData = pd.DataFrame(DAT)
pdData.columns = pdData.iloc[0]
pdData.reindex(pdData.index.drop(0))
pdData["FIPS"] = pdData["STATE"] + pdData["county"]
pdData = pdData[~pdData.astype(str).eq('None').any(1)]
pdData["K200001_001E"] = pd.to_numeric(pdData["K200001_001E"],errors='coerce')
pdData = pdData.dropna(axis=0, how='any')
# generate the ginicoefficient -- this isn't working yet
#dull = g.ginicoefficient(TAB[:, [0]], TAB[:, [1]])
#incvals = map(lambda a:int(pdDat[a]),pdDat)
pdData.to_csv(r"C:\\")
county_color_dict = {}
for index, row in pdData.iterrows():
    if row["K200001_001E"] is not None and index > 0:
        color = sem.calculate_color(int(row["K200001_001E"]),min(pdData["K200001_001E"]),max(pdData["K200001_001E"]),10)
        county_color_dict[row["FIPS"]] = color

patches = dict(map(lambda color:(color,[]),county_color_dict.values()))

# Set the lower left and upper right limits of the bounding box:
lllon = -119
urlon = -64
lllat = 22.0
urlat = 50.5
# and calculate a centerpoint, needed for the projection:
centerlon = float(lllon + urlon) / 2.0
centerlat = float(lllat + urlat) / 2.0

m = sem.draw_us_map()

###### This is where the current problem is
###### map doesn't have county info or counties stored
###### uses example shapefile -- need to review shapefile to figure out if that
###### is the problem

for info, shape in zip(m.counties_info, m.counties):
    try:
        color=county_color_dict[info['GEOID'].zfill(5)]
        patches[color].append(Polygon(np.array(shape), True) )
    except Exception as e:
        continue
plt.title('US Counties')
# Get rid of some of the extraneous whitespace matplotlib loves to use.
plt.tight_layout(pad=0, w_pad=0, h_pad=0)
plt.show()
'''
# This code imports as a numpy array. After a ton of debugging, it seems like it'd be easier to do
# what I'm trying to do with a pandas dataframe. If the pandas dataframe doesn't work out, I'll
# switch back to a numpy array bc this code is functional 
TAB = np.array([0, 0])
for i in range(1, len(DAT)):
    if(DAT[i][2] is not None and DAT[i][1] is not None):
        appender = [int(DAT[i][2]), int(DAT[i][1])]
        TAB = np.vstack([TAB, appender])
'''