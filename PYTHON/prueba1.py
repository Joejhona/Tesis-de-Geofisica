from netCDF4 import Dataset
import matplotlib.pyplot as plt
from matplotlib.cm import get_cmap
import cartopy.crs as crs
#from cartopy.feature import NaturalEarthFeature

import cartopy.feature as cfeature

from wrf import (to_np, getvar, smooth2d, get_cartopy, cartopy_xlim,
                 cartopy_ylim, latlon_coords, extract_times, ALL_TIMES)

path        = "/data/users/jticse/WRFV4/wrfout/periodos/wrfout_d02_2018-02-17_00:00:00"
wrfnc       = Dataset(path)
rainc       = getvar(wrfnc,"RAINC",timeidx=ALL_TIMES)     #==> Lluvia convectiva
rainnc      = getvar(wrfnc,"RAINNC",timeidx=ALL_TIMES)    #==> Lluvia NO convectiva
#time        = extract_times(wrfnc,timeidx=ALL_TIMES)
dia_i       = "2018-02-19T00:00:00"
rainc_1     = rainc.loc[dia_i]
rainnc_1    = rainnc.loc[dia_i]
dia_f       = dia_i[:8]+str(int(dia_i[8:10])+1)+dia_i[10:]
rainc_2     = rainc.loc[dia_f]
rainnc_2    = rainnc.loc[dia_f]
rainc_f     = rainc_2-rainc_1
rainnc_f    = rainnc_2-rainnc_1
rain_f      = rainc_f+rainnc_f
#rainc2  = to_np(rainc)

lats, lons  = latlon_coords(rainc)   #==> Llamando lat y lon

#cart_proj = get_cartopy(rainc)      #==> llamando al objeto de mapeo
cart_proj   = get_cartopy(rain_f)

fig         = plt.figure(figsize=(24,12),dpi=300)    #==> Creando una figura

ax          = plt.axes(projection=cart_proj) #==> Set the GeoAxes to the projection used by WRF

#states = NaturalEarthFeature(category="cultural", scale="50m",
#                             facecolor="none",
#                             name="admin_1_states_provinces_shp")   #==> Descargando y adicionando los estados y costas
#ax.add_feature(states, linewidth=.5, edgecolor="black")
#ax.coastlines('50m', linewidth=0.8)

states_provinces = cfeature.NaturalEarthFeature(
    category='cultural',
    name='admin_1_states_provinces_lines',
    scale='50m',
    facecolor='none')

ax.add_feature(cfeature.LAND)
ax.add_feature(cfeature.COASTLINE)
ax.add_feature(states_provinces, edgecolor='gray')

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

plt.title("Prueba 2")

plt.savefig('/data/users/jticse/Tesis-Maestria/SALIDAS/figuras/foo2.png')

print('todo bien /data/users/jticse/WRFV4/wrfout/periodos ===> wrfout_d02_2018-02-17_00:00:00')