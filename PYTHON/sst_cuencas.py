#!/usr/bin/env python
# coding: utf-8

# In[6]:


from netCDF4 import Dataset
import pandas as pd
from datetime import datetime, timedelta


# In[3]:


pers17  = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",        
           "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25",
           "2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",        
           "2018-03-05","2018-03-17","2018-03-22"]
pcost   = pd.read_csv('/mnt/j/Gdrive/Tesis-Maestria/SALIDAS/csv/puntos_costa2.csv')


# In[28]:

for per in pers17:
    for x in range(0,3):
        per_i  = pd.to_datetime(per)+timedelta(days=x)
        per_i  = per_i.strftime('%Y_%m_%d')
        #print("rtg_sst_"+per_i.strftime('%Y_%m_%d')+".nc")
        ncfile = Dataset("rtg_sst_"+per_i+".nc")
        lon    = pd.DataFrame({'lon':ncfile.variables['lon'][:]})
        lon    = lon-360
        lat    = pd.DataFrame({'lat':ncfile.variables['lat'][:]})
        for index, row in pcost.iterrows():
            #lat_i = row['Y']
            #lon_i = row['X']
            id_lat = lat.iloc[(lat['lat']-row['Y']).abs().argsort()[:1]].index
            id_lon = lon.iloc[(lon['lon']-row['X']).abs().argsort()[:1]].index
            tsm    = ncfile.variables['t'][0,id_lat,id_lon].item()-273.15
            pcost.loc[index,per_i]=tsm
            print(tsm)
pcost.to_csv('datos_sst_cuencas.csv',encoding='utf-8',index=False)
