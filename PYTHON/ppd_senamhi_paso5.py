# -*- coding: utf-8 -*-

import pandas as pd

dfs = pd.read_csv('SENAMHI-HACK5.csv')
lat = []
lon = []
for index, row in dfs.iterrows():
    idg = row['lat'].decode("utf8").find(u'\N{DEGREE SIGN}')
    #idg = row['lat'].find('°')
    idm = row['lat'].find('\'')
    ids = row['lat'].find('\'\'')
    g = float(row['lat'][0:idg])
    m = float(row['lat'][idg+2:idm])
    s = float(row['lat'][idm+1:ids])
    #row['nlat'] = g+m/60+s/360
    latn = g+m/60+s/360
    lat.append(latn)
    idg = row['lon'].decode("utf8").find(u'\N{DEGREE SIGN}')
    #idg = row['lon'].find('°')
    idm = row['lon'].find('\'')
    ids = row['lon'].find('\'\'')
    g = float(row['lon'][0:idg])
    m = float(row['lon'][idg+2:idm])
    s = float(row['lon'][idm+1:ids])
    #row['nlon'] = g+m/60+s/360
    lonn = g+m/60+s/360
    lon.append(lonn)
nlat = pd.Series(lat)
nlon = pd.Series(lon)
dfs['nlat'] = nlat
dfs['nlon'] = nlon

dfs.to_csv('SENAMHI-HACK6.csv',encoding='utf-8',index=False)
