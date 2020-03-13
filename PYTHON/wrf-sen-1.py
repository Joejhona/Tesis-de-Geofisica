#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os
from netCDF4 import Dataset
from wrf import getvar, interpline, CoordPair, xy_to_ll, ll_to_xy, extract_times, ALL_TIMES
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta


# In[2]:


pers17  = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25"]
pers18  = ["2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",        "2018-03-05","2018-03-17","2018-03-22"]
ssts    = ["-3sst","-2sst","-1sst","","+1sst","+2sst","+3sst"]


# In[107]:


pdf     = pd.read_csv('rain_sen_vnp_DT.csv')
pdf     = pdf[pdf['mm/d']>0]
pdf17   = pdf[pdf['D'].isin(pers17)]
#pdf18   = pdf[pdf['D'].isin(pers18)]
#pdf_cu  = pdf.drop_duplicates(subset='cuenca')
pdf_es_17 = pdf17.drop_duplicates(subset='estacion')


# In[ ]:


for per in pers17:
    for sst in ssts:
        ncfile  = Dataset("wrfout_d01_"+per+"_00:00:00"+sst)
        rainnc  = getvar(ncfile,'RAINNC',timeidx=ALL_TIMES)
        rainc   = getvar(ncfile,'RAINC',timeidx=ALL_TIMES)
        raint   = rainc+rainnc
        times   = extract_times(ncfile,timeidx=ALL_TIMES)
        times   = pd.Series(times)
        ti      = pd.Series(pd.to_datetime(per)+timedelta(hours=6))
        tf      = ti+timedelta(days=1)
        for index, row in pdf_es_17.iterrows():
            x_y = ll_to_xy(ncfile, row['lat'],row['lon'])
            raint_i = raint[times.isin(ti),x_y[1],x_y[0]]
            raint_f = raint[times.isin(tf),x_y[1],x_y[0]]
            raint_p = raint_f[0]-raint_i[0]
            wrf = 'wrf'+sst
            idf = pdf17[(pdf17['D']==per)&(pdf17['estacion']==row['estacion'])].index
            pdf17.loc[idf,wrf]=raint_p.to_pandas()
pdf17.to_csv('data_wrf_sen_sst.csv',encoding='utf-8',index=False)

