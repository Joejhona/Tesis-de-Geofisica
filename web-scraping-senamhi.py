import unicodecsv as csv
import urllib2, re
import pandas as pd
from bs4 import BeautifulSoup
from os import walk

path2 = "https://www.senamhi.gob.pe/include_mapas/_dat_esta_tipo02.php?estaciones="
path3 = "&tipo="        #--> enlace con tipo
path4 = "&CBOFiltro="   #--> enlace con fecha
path5 = "&t_e="         #--> enlace con t_e

base    = pd.read_csv("/home/usuario/Documentos/ticse/senamhi/ppython/senamhi-17-18.csv")

base    = base.loc[:,["codigo","t_e","tipo"]]

dates   = []
for x in range(2006,2017):
    enero   = str(x)+"01"
    dates.append(enero)
    febrero = str(x)+"02"
    dates.append(febrero)
    marzo   = str(x)+"03"
    dates.append(marzo)

