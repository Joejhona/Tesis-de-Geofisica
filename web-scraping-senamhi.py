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
#dates   = ['201801','201802','201803']

for x in range(len(base)):
    web  = base.loc[x].codigo
    text = re.search(r'[A-Z]',web)
    link = ''
    values  = []
    if not text:
        if int(web)<10:
            link = '00000'
        elif int(web)<1000:
            link = '000'
        elif int(web)<10000:
            link = '00'
    for date in dates:
        path_p  = path2+link+base.loc[x].codigo+path3+base.loc[x].tipo+path4+date+path5+base.loc[x].t_e
        print(path_p)
        dfs     = pd.read_html(path_p)
        df      = dfs[0]
        df.columns = df.iloc[[0,1]].apply('_'.join, axis=0)
        df      = df[2:]
        if df.any(axis=None):
            print('Existe Data'+date)
            new_columns = []
            for column in df.columns:
                j = column.find('_')
                if j != -1:
                    y = column[:j]
                    z = column[j+1:]
                    if y == z:
                        new_columns.append(y)
                    else:
                        new_columns.append(column)
            if new_columns:
                df.columns = new_columns
                del new_columns
            values.append(df)
    if values:
        values_concat = pd.concat(values)
        values_concat.to_excel('salidas/'+web+'.xlsx')
        values_concat.to_csv('salidas/'+web+'.csv', encoding='utf-8', index=False)
        del values
