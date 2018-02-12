''' This is a map of income by population for the state of Pennsylvania
    It functions, but is missing some data.
    Shapefile from here: https://catalog.data.gov/dataset/tiger-line-shapefile-2013-state-pennsylvania-current-county-subdivision-state-based
    Credit to here: http://www.zimlon.com/b/using-matplotlib-basemap-to-visualize-home-insurance-by-county-cm615
    and here: http://shallowsky.com/blog/programming/plotting-election-data-basemap.html
    some of the code from those sites is used verbatim or heavily adapted
'''
import json
import urllib
import pandas as pd
import numpy as np
import gini as g
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection
import shapefile
import math

def calculate_color(countyval, minval, maxval, colorlevels):
    from math import ceil
    level = ceil((countyval-minval)*colorlevels/(maxval-minval))
    color = 255-ceil(level*255/colorlevels)
    return color

with urllib.request.urlopen("https://api.census.gov/data/2016/acs/acsse?get=STATE,K200001_001E,K201901_001E&for=county:*&in=state:*") as url:
    DAT = json.load(url)

pdData = pd.DataFrame(DAT)
pdData.columns = pdData.iloc[0]
pdData.reindex(pdData.index.drop(0))
pdData["FIPS"] = "00" + pdData["county"]
pdData = pdData[~pdData.astype(str).eq('None').any(1)]
pdData["K200001_001E"] = pd.to_numeric(pdData["K200001_001E"],errors='coerce')
pdData["K201901_001E"] = pd.to_numeric(pdData["K201901_001E"],errors='coerce')
pdData["INCPERCAPITA"] = pdData["K201901_001E"]/pdData["K200001_001E"]
pdData = pdData.dropna(axis=0, how='any')

county_color_dict = {}
for index, row in pdData.iterrows():
    if row["INCPERCAPITA"] is not None and index > 0 and row["STATE"] == "42":
        color = calculate_color(int(row["INCPERCAPITA"]),min(pdData["INCPERCAPITA"]),max(pdData["INCPERCAPITA"]),1005)
        county_color_dict[row["FIPS"]] = color


patches = dict(map(lambda color:(color,[]),county_color_dict.values()))

ax = plt.subplot()

lllon = -80.519851
urlon = -74.689502
lllat = 39.719799
urlat = 42.516072

centerlon = float(lllon + urlon) / 2.0
centerlat = float(lllat + urlat) / 2.0

m = Basemap(resolution='i',  
            llcrnrlon = lllon, urcrnrlon = urlon,
            lon_0 = centerlon,
            llcrnrlat = lllat, urcrnrlat = urlat,
            lat_0 = centerlat,
            projection='tmerc')


m.readshapefile('tl_2013_42_cousub','counties',drawbounds=True)


for info, shape in zip(m.counties_info, m.counties):
    try:
        color=county_color_dict[info['COUNTYFP'].zfill(5)]
        patches[color].append(Polygon(np.array(shape), True) )
    except Exception as e:
        continue
for color in patches:
    htmlcolor = '#%02x%02x%02x' % (color, 165, 180)
    ax.add_collection(PatchCollection(patches[color],facecolor=htmlcolor , edgecolor='k', linewidths=1.0, zorder=2))

plt.title('Income Per Capita in Pennsylvania')
plt.tight_layout(pad=0, w_pad=0, h_pad=0)
plt.show()     

