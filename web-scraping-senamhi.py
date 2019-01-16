import unicodecsv as csv
import urllib2, re
import pandas as pd
from bs4 import BeautifulSoup
from os import walk

#path1 = "https://www.senamhi.gob.pe/include_mapas/_dat_esta_tipo.php?estaciones="
#path2 = "https://www.senamhi.gob.pe/include_mapas/_dat_esta_tipo02.php?estaciones="
#web2 = "https://www.senamhi.gob.pe/mapas/mapa-estaciones/_dat_esta_tipo02.php?estaciones=000570&tipo=CON&CBOFiltro=197403&t_e=M"

path1 = "https://www.senamhi.gob.pe/mapas/mapa-estaciones/_dat_esta_tipo.php?estaciones="
path2 = "https://www.senamhi.gob.pe/mapas/mapa-estaciones/_dat_esta_tipo02.php?estaciones="
path3 = "&tipo="        #--> enlace con tipo
path4 = "&CBOFiltro="   #--> enlace con fecha
path5 = "&t_e="         #--> enlace con t_e
ruta  = "/home/usuario/Documentos/ticse/Tesis/Data/senamhi/"
#base    = pd.read_csv("/home/usuario/Documentos/ticse/senamhi/ppython/senamhi-17-18.csv")
base    = pd.read_csv("/home/usuario/Documentos/ticse/senamhi/ppython/senamhi-17-182.csv")
base    = base.loc[:,["codigo","t_e","tipo"]]

dates   = []
for x in range(2006,2017):
    enero   = str(x)+"01"
    dates.append(enero)
    febrero = str(x)+"02"
    dates.append(febrero)
    marzo   = str(x)+"03"
    dates.append(marzo)

for x in range(len(base)):
    web         = path1+base.loc[x].codigo
    conector    = urllib2.urlopen(web,timeout=15)
    html        = conector.read()
    soup        = BeautifulSoup(html, 'html.parser')
    fechas      = soup.find_all("option")
    frames      = []
    for fecha in fechas:
        selec = fecha["value"]
        for date in dates:
            if date == selec:
                web2        = path2+base.loc[x].codigo+path3+base.loc[x].tipo+path4+date+path5+base.loc[x].t_e
                print(web2)
                conector2   = urllib2.urlopen(web2,timeout=10)
                html2       = conector2.read()
                soup2       = BeautifulSoup(html2,'lxml')
                table2      = soup2.find('table', attrs={'class':'body01'})
                df_data_prev= pd.read_html(str(table2), encoding='utf-8')
                df_data     = df_data_prev[0]
                #### asignando nombre de columnas######
                index       = soup2.find('tr', attrs={'bgcolor':'#003366'})
                cols        = index.find_all('td')
                rows_name   = []
                for ele in cols:
                    eme = ele.get('colspan')
                    name = ele.text.strip()
                    if eme:
                        colu = ele['colspan']
                        for z in range(int(colu)):
                            rows_name.append(name)    
                    else:
                        rows_name.append(name)
                df_data.columns = rows_name
                del rows_name
                #########################################         
                frames.append(df_data[2:])
    print(len(frames))
    if len(frames) <> 0:
        result = pd.concat(frames)
        result.to_csv(ruta+base.loc[x].codigo+'.csv', encoding='utf-8', index=False)
        print(result)
        del result
    del frames
        
    


