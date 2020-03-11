import os
from netCDF4 import Dataset
from wrf import getvar, interpline, CoordPair, xy_to_ll, ll_to_xy
from wrf import extract_times, ALL_TIMES
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd)#+'/wrfout_d01_2017*')

pdf     = pd.read_csv('rain_sen_vnp_DT.csv')
pdf     = pdf[pdf['mm/d']>0]
pdf.index = pd.to_datetime(pdf['D'])
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
