from netCDF4 import Dataset
import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
import cartopy.crs as crs
from cartopy.feature import NaturalEarthFeature

from wrf import (to_np, getvar, smooth2d, get_cartopy, cartopy_xlim,
                 cartopy_ylim, latlon_coords, extract_times, ALL_TIMES)

path    = "/data/users/jticse/WRFV4/wrfout/periodos/wrfout_d02_2018-02-17_00:00:00"
wrfnc   = Dataset(path)
rainc   = getvar(wrfnc,"RAINC",timeidx=ALL_TIMES)     #==> Lluvia convectiva
#rainnc  = getvar(wrfnc,"RAINNC")    #==> Lluvia NO convectiva
#time    = extract_times(wrfnc,timeidx=ALL_TIMES)
dia_i   = "2018-02-19T00:00:00"
rainc_1 = rainc.loc[dia_i]
dia_f   = dia_i[:8]+str(int(dia_i[8:10])+1)+dia_i[10:]
rainc_2 = rainc.loc[dia_f]
rainc_f = rainc_2-rainc_1

#rainc2  = to_np(rainc)

lats, lons = latlon_coords(rainc)   #==> Llamando lat y lon

cart_proj = get_cartopy(rainc)      #==> llamando al objeto de mapeo

fig = plt.figure(figsize=(12,6))    #==> Creando una figura

ax = plt.axes(projection=cart_proj) #==> Set the GeoAxes to the projection used by WRF

#states = NaturalEarthFeature(category="cultural", scale="50m",
#                             facecolor="none",
#                             name="admin_1_states_provinces_shp")   #==> Descargando y adicionando los estados y costas
#ax.add_feature(states, linewidth=.5, edgecolor="black")
#ax.coastlines('50m', linewidth=0.8)

plt.contour(to_np(lons), to_np(lats), to_np(rainc_f), 10, colors="black",
            transform=crs.PlateCarree())
plt.contourf(to_np(lons), to_np(lats), to_np(rainc_f), 10,
             transform=crs.PlateCarree(),
             cmap=get_cmap("jet"))

# Add a color bar
plt.colorbar(ax=ax, shrink=.98)

# Set the map bounds
ax.set_xlim(cartopy_xlim(rainc))
ax.set_ylim(cartopy_ylim(rainc))

ax.gridlines(color="black", linestyle="dotted")

plt.title("Sea Level Pressure (hPa)")

plt.savefig('foo.png')

print('todo bien /data/users/jticse/WRFV4/wrfout/periodos ===> wrfout_d02_2018-02-17_00:00:00')