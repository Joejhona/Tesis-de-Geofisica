#!/usr/bin/env python
# coding: utf-8

# In[99]:


import os
from netCDF4 import Dataset
from wrf import getvar, interpline, CoordPair, xy_to_ll, ll_to_xy, extract_times, ALL_TIMES
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta


# In[232]:


pers17  = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25"]
pers18  = ["2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",        "2018-03-05","2018-03-17","2018-03-22"]
ssts    = ["-3sst","-2sst","-1sst","","+1sst","+2sst","+3sst"]


# In[214]:


pdf     = pd.read_csv('rain_sen_vnp_DT.csv')
pdf     = pdf[pdf['mm/d']>0]
pdf.index = pd.to_datetime(pdf['D'])
pdf17   = pdf[pdf.index.isin(pers17)]
pdf18   = pdf[pdf.index.isin(pers18)]
pdf_cu  = pdf.drop_duplicates(subset='cuenca')
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
        tf      = tf+timedelta(days=1)
        raint_i = raint[times.isin(ti),:,:]
        raint_f = raint[times.isin(tf),:,:]
        raint_p = raint_f-raint_i
        for index, row in pdf_es_17.iterrow():
            x_y = ll_to_xy(ncfile, row['lat'],row['lon'])
            raint_e = raint_p[x_y[1],x_y[0]]
            wrf = 'wrf'+sst
            pdf17.loc[pd.to_datetime(per),wrf]=raint_e
pdf17.to_csv('data_wrf_sen_sst.csv',encoding='utf-8',index=False)


# In[228]:


ncfile  = Dataset("wrfout_d01_2017-03-13_00:00:00")
x_y     = ll_to_xy(ncfile, pdf.iloc[2,2], pdf.iloc[2,3])
rainnc  = getvar(ncfile,'RAINNC',timeidx=ALL_TIMES)
rainc   = getvar(ncfile,'RAINC',timeidx=ALL_TIMES)


# In[229]:


times   = extract_times(ncfile,timeidx=ALL_TIMES)
times   = pd.Series(times)


# In[254]:


#timei = datetime.strptime(pers17[0],'%Y-%m-%d')+timedelta(hours=6)
#ti = pers17[0]+' 06:00:00'
ti=pd.Series(pd.to_datetime(pers17[0])+timedelta(hours=6))


# In[259]:


tf=ti+timedelta(days=1)


# In[263]:


raint = rainnc+rainc
raint[15,:,:]-raint[19,:,:]


# In[14]:


pdf17[pdf17['cod_es']=='107016']


# In[15]:


pdf17[pdf17['cod_cu']==13774]


# In[30]:


cuencas.iloc[3,6]


# In[46]:


pdf17[pdf17['cod_es']=='107016']['mm/d']


# In[60]:


pdf17[pdf17['cod_es']=='107016']['mm/d'].plot.bar()


# In[88]:


timejoe=pdf17[pdf17['cod_es']=='107016'].index+timedelta(hours=6)


# In[102]:


dato1=rainnc[times.isin(timejoe),x_y[1],x_y[0]]


# In[207]:


pdf2=pdf17[pdf17['cod_es']=='107016']


# In[209]:


pdf2.loc[pd.to_datetime('2017-01-15'),'wrf']=15.5


# In[211]:


pdf2.sort_index()


# In[187]:


pdf2


# In[108]:


times[times.isin(timejoe)]


# In[169]:


pdf2.loc[:,['wrf','mm/d']]


# In[ ]:





# In[36]:


for index, row in pdf_cu.iterrows():
    pdf_es = pdf[pdf['cuenca']==row['cuenca']].drop_duplicates(subset='estacion')
    for index2, row2 in pdf_es.iterrows():
        pdf = pdf[pdf['estacion']==row2['estacion']]
            
    print(row['cuenca'])
    print(len(pdf_es))


# In[ ]:




