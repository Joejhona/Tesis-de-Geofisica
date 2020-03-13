#!/usr/bin/env python
# coding: utf-8

# In[117]:


#import os
from netCDF4 import Dataset
from wrf import getvar, interpline, CoordPair, xy_to_ll, ll_to_xy, extract_times, ALL_TIMES
import pandas as pd
from datetime import datetime, timedelta


# In[118]:


pers17  = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25"]
pers18  = ["2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",        "2018-03-05","2018-03-17","2018-03-22"]
ssts    = ["-3sst","-2sst","-1sst","","+1sst","+2sst","+3sst"]


# In[162]:


pdf     = pd.read_csv('rain_sen_vnp_DT.csv')
pdf     = pdf[pdf['mm/d']>0]
pdf_es  = pdf.drop_duplicates(subset='estacion')
i = 0


# In[ ]:


for per in pers17:
    for sst in ssts:
        for day in [0,1,2]:
            ncfile  = Dataset("wrfout_d01_"+per+"_00:00:00"+sst)
            rainnc  = getvar(ncfile,'RAINNC',timeidx=ALL_TIMES)
            rainc   = getvar(ncfile,'RAINC',timeidx=ALL_TIMES)
            raint   = rainc+rainnc
            times   = extract_times(ncfile,timeidx=ALL_TIMES)
            times   = pd.Series(times)
            tr      = pd.Series(pd.to_datetime(per)+timedelta(days=day))
            ti      = tr+timedelta(hours=6)
            tf      = ti+timedelta(days=1)
            for index, row in pdf_es.iterrows():
                x_y = ll_to_xy(ncfile, row['lat'],row['lon'])
                raint_i = raint[times.isin(ti),x_y[1],x_y[0]]
                raint_f = raint[times.isin(tf),x_y[1],x_y[0]]
                raint_p = raint_f[0]-raint_i[0]
                wrf = 'wrf'+sst
                idf = pdf[(pdf['D']==tr.dt.strftime('%Y-%m-%d')[0])&(pdf['estacion']==row['estacion'])].index
                pdf.loc[idf,wrf]=raint_p.to_pandas()
                i = i + 1
                print(i)
pdf.to_csv('data_wrf_sen_sst.csv',encoding='utf-8',index=False)

