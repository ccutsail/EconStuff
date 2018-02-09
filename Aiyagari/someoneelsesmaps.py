from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt

def draw_us_map():
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
    
    return m


def calculate_color(countyval, minval, maxval, colorlevels):
    from math import ceil
    return 255-ceil(ceil((countyval-minval)*colorlevels/(maxval-minval))*255/colorlevels)