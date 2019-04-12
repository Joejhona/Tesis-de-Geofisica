import requests, re
import pandas as pd
from bs4 import BeautifulSoup

dir_b  = "/home/usuario/Documentos/ticse/Tesis/Data/Script/"
file_b = "est-senamhi.csv"
base   = pd.read_csv(dir_b+file_b)
base   = base.loc[:,["codigo","t_e","tipo"]]

path1 = "https://www.senamhi.gob.pe/mapas/mapa-estaciones/_dat_esta_tipo.php?estaciones="
path2 = "https://www.senamhi.gob.pe/mapas/mapa-estaciones/_dat_esta_tipo02.php?estaciones="
path3 = "&tipo="        #--> enlace con tipo
path4 = "&CBOFiltro="   #--> enlace con fecha
path5 = "&t_e="         #--> enlace con t_e

dates   = ['201901','201902','201903']


for x in range(len(base)):
    web  = base.loc[x].codigo
    text = re.search(r'[A-Z]',web)
    link = ''
    if not text:
        if int(web) <10:
            link = '00000'
        elif int(web) <1000:
            link = '000'
        elif int(web) <10000:
            link = '00'
    for date in dates:
        path_p = path2+link+base.loc[x].codigo+path3+base.loc[x].tipo+path4+date+path5+base.loc[x].t_e
        print(path_p)
    
    #path_p = path1+link+base.loc[x].codigo

    #path_p = path2+link+base.loc[x].codigo+path3+base.loc[x].tipo+path4+date+path5+base.loc[x].t_e

    #web2 = path2+base.loc[x].codigo+path3+base.loc[x].tipo+path4+date+path5+base.loc[x].t_e

    print(path_p)
    #if text:
    #    #path_p = path1+base.loc[x].codigo
    #    #print(path_p)
    #    link = ''
    #else:
    #if not text:
        #print('loco')
        #if int(web) <10:
        #    #path_p = path1+'00000'+base.loc[x].codigo
        #    #print(path_p)
        #    link = '00000'
        #elif int(web) <1000:
        #    #path_p = path1+'000'+base.loc[x].codigo
        #    #print(path_p)
        #    link = '000'
        #elif int(web) <10000:
        #    #path_p = path1+'00'+base.loc[x].codigo
        #    #print(path_p)
        #    link = '00'
        #else:   
        #    path_p = path1+base.loc[x].codigo
        #    print(path_p)
    
    #path_p = path1+link+base.loc[x].codigo
            #print(web)
            #print('loco')