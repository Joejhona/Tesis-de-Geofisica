import requests, re
import pandas as pd
from bs4 import BeautifulSoup

fechas  = ['2017-01','2017-02','2017-03','2018-01','2018-02','2018-03']
index   = ['Estacion','Departamento','Provincia','Distrito','Latitud','Longitud','Altitud','Codigo1','Codigo2','Estado','Cate','Periodo1','Periodo2']

path1   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/map_red_graf.php?cod=105063&estado=REAL&tipo_esta=M&cate=MAP&cod_old="
path3   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/map_red_graf.php?cod=111159&estado=DIFERIDO&tipo_esta=M&cate=PLU&cod_old=156133"
path3   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/map_red_graf.php?cod=113249&estado=AUTOMATICA&tipo_esta=M&cate=EMA&cod_old="

estado  = ["REAL","AUTOMATICA","DIFERIDO"]
cate    = ['MAP','EMA',"PLU"]
path2   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/_dato_esta_tipo02.php?estaciones=105063&CBOFiltro=201701&t_e=M&estado=REAL&cod_old=&cate_esta=MAP&alt=24"
path4   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/_dato_esta_tipo02.php?estaciones=111159&CBOFiltro=202001&t_e=M&estado=DIFERIDO&cod_old=156133&cate_esta=PLU&alt=2468"

df = pd.read_csv("est-senamhi.csv")

#inicio  = 119000
#fin     = 119250
#rango_x  = []113250:113500
rango1   = range(1,251,1)
rango2   = range(103000,119000,1000)
rango_x  = range(100000,100250,1)
for ran2 in rango2:
    for ran1 in rango1:
        rango_x.append(ran1+ran2)

#for x in range(inicio,fin,1):
#for x in df.codigo[523:]:
for x in rango_x:
    #path_x  = path1[:72]+str(x)+path1[78:86]+enlace1[1]+path1[90:]
    path_x  = path1[:72]+str(x)
    dfs     = pd.read_html(path_x)
    joe     = dfs[0] 
    est     = joe.iloc[1,0]
    #per2    = joe.iloc[2,6]
    print(x)
    datos   = []
    per1    = []
    if len(est)>12:     
        datos.append(est[12:]) #--> est
        datos.append(joe.iloc[2,1]) #--> dep  
        datos.append(joe.iloc[2,3]) #--> prov 
        datos.append(joe.iloc[2,5]) #--> dis  
        datos.append(joe.iloc[3,1]) #--> lat  
        datos.append(joe.iloc[3,3]) #--> lon  
        datos.append(joe.iloc[3,5]) #--> alt  
        datos.append(joe.iloc[4,3]) #--> cod1  
        path_x  = path1[:72]+str(x)+path1[78:]
        dfs     = pd.read_html(path_x)
        joe     = dfs[0] 
        per2    = joe.iloc[2,6]
        if per2.find("No hay Datos")==-1:
            datos.append('')        #--> cod2  
            datos.append(estado[0]) #--> estado  
            datos.append(cate[0])   #--> cate
            datos.append(per2[5:])  #--> periodos 1
            for fecha in fechas:
                if per2.find(fecha)>0:
                    per1.append(fecha)
                    print(fecha)
            if len(per1)>0:
                datos.append(per1)  #--> periodos 2
            else:
                datos.append('')    #--> periodos 2
        else:
            path_x  = path1[:72]+str(x)+path1[78:86]+estado[1]+path1[90:108]+cate[1]+path1[111:]
            dfs     = pd.read_html(path_x)
            joe     = dfs[0] 
            per2    = joe.iloc[2,6]
            if per2.find("No hay Datos")==-1:
                datos.append('')        #--> cod2  
                datos.append(estado[1]) #--> estado  
                datos.append(cate[1])   #--> cate
                datos.append(per2[5:])  #--> periodos 1
                for fecha in fechas:
                    if per2.find(fecha)>0:
                        per1.append(fecha)
                        print(fecha)
                if len(per1)>0:
                    datos.append(per1)  #--> periodos 2
                else:
                    datos.append('')    #--> periodos 2
            else:
                id_h    = joe.iloc[3,5].find(' msnm')
                id_lat  = joe.iloc[3,1].find(u'\N{DEGREE SIGN}')
                id_lon  = joe.iloc[3,3].find(u'\N{DEGREE SIGN}')
                for index, row in df.iterrows():
                    if row['coord_z']==float(joe.iloc[3,5][:id_h]):
                        if int(row['coord_x'])==int(joe.iloc[3,1][:id_lat])*-1:
                            if int(row['coord_y'])==int(joe.iloc[3,3][:id_lon])*-1:
                                path_x  = path1[:72]+str(x)+path1[78:86]+estado[2]+path1[90:108]+cate[2]+path1[111:]+row['codigo']
                                dfs     = pd.read_html(path_x)
                                joe     = dfs[0] 
                                per2    = joe.iloc[2,6]
                                if per2.find("No hay Datos")==-1:
                                    datos.append(row['codigo']) #--> cod2  
                                    datos.append(estado[2])     #--> estado  
                                    datos.append(cate[2])       #--> cate
                                    datos.append(per2[5:])      #--> periodos 1
                                    for fecha in fechas:
                                        if per2.find(fecha)>0:
                                            per1.append(fecha)
                                            print(fecha)
                                    if len(per1)>0:
                                        datos.append(per1)  #--> periodos 2
                                    else:
                                        datos.append('')    #--> periodos 2
        datos = pd.DataFrame(datos)            
        datos = datos.T
        datos.to_csv('SENAMHI-HACK.csv',mode='a',encoding='utf-8',header=False,index=False)
    del datos
    del per1