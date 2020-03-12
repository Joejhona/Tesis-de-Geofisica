import os
from netCDF4 import Dataset
from wrf import getvar, interpline, CoordPair, xy_to_ll, ll_to_xy, extract_times, ALL_TIMES
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd)#+'/wrfout_d01_2017*')

per17   = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",\
        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25"]
per18   = ["2018-01-10","2018-01-16","2018-01-21","2018-02-14","2018-02-17",\
        "2018-03-05","2018-03-17","2018-03-22"]

pdf     = pd.read_csv('rain_sen_vnp_DT.csv')
pdf     = pdf[pdf['mm/d']>0]
pdf.index = pd.to_datetime(pdf['D'])
pdf17   = pdf[pdf.index.isin(per17)]
pdf18   = pdf[pdf.index.isin(per18)]
cuencas = pdf.drop_duplicates(subset='cuenca')
for index, row in cuencas.iterrows():
    


ncfile  = Dataset("wrfout_d01_2017-03-13_00:00:00")
x_y     = ll_to_xy(ncfile, pdf.iloc[2,2], pdf.iloc[2,3])
rainnc  = getvar(ncfile,'RAINNC',timeidx=ALL_TIMES)

rainnc_line = interpline(rainnc, start_point=x_y, end_point=x_y, latlon=True)
times   = extract_times(ncfile,timeidx=ALL_TIMES)
times   = pd.Series(times)
times   = times.isin(['2017-03-13 6:00:00','2017-03-14 6:00:00','2017-03-15 6:00:00','2017-03-16 6:00:00'])
rainnc[times,x_y[1],x_y[0]]
