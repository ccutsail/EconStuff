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
TAB = np.array([0, 0])
for i in range(1, len(DAT)):
    if(DAT[i][2] is not None and DAT[i][1] is not None):
        appender = [int(DAT[i][2]), int(DAT[i][1])]
        TAB = np.vstack([TAB, appender])
# generate the ginicoefficient -- this isn't working yet
dull = g.ginicoefficient(TAB[:, [0]], TAB[:, [1]])

incvals = map(lambda a:int(DAT[a]),DAT)


county_color_dict = {}
i = 1
for fips in DAT:
    if DAT[i][1] is not None:
        color = sem.calculate_color(int(DAT[i][1]),min(TAB[:][1]),max(TAB[:][1]),10)
        county_color_dict[DAT[i][0]] = color
        i += 1
        if i == len(DAT):
            i -= 1
    else:
        i += 1

patches = dict(map(lambda color:(color,[]),county_color_dict.values()))

# Set the lower left and upper right limits of the bounding box:
lllon = -119
urlon = -64
lllat = 22.0
urlat = 50.5
# and calculate a centerpoint, needed for the projection:
centerlon = float(lllon + urlon) / 2.0
centerlat = float(lllat + urlat) / 2.0

m = Basemap(resolution='i',  # crude, low, intermediate, high, full
            llcrnrlon = lllon, urcrnrlon = urlon,
            lon_0 = centerlon,
            llcrnrlat = lllat, urcrnrlat = urlat,
            lat_0 = centerlat,
            projection='tmerc')


#Read county boundaries
shp_info = m.readshapefile('cb_2015_us_county_500k','counties',drawbounds=True)

###### This is where the current problem is
###### It doesn't 
for info, shape in zip(m.counties_info, m.counties):
    try:
        color=county_color_dict[info['GEOID'].zfill(5)]
        patches[color].append(Polygon(np.array(shape), True) )
    except Exception as e:
        print(e)
plt.title('US Counties')
# Get rid of some of the extraneous whitespace matplotlib loves to use.
plt.tight_layout(pad=0, w_pad=0, h_pad=0)
plt.show()