#from netCDF4 import Dataset
#import matplotlib.pyplot as plt
#from matplotlib.cm import get_cmap
#import cartopy.crs as crs
#from cartopy.feature import NaturalEarthFeature

from netCDF4 import Dataset
import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
from mpl_toolkits.basemap import Basemap

from wrf import (to_np, getvar, smooth2d, get_cartopy, cartopy_xlim,
                 cartopy_ylim, latlon_coords)

print('todo bien /data/users/jticse/WRFV4/wrfout/periodos ===> wrfout_d02_2018-02-17_00:00:00')