import os
import pandas as pd

#data    = []
cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_senamhi')
#columns = ['Estacion','Departamento','Provincia','Distrito','Latitud','Longitud','Altitud','Codigo','Tipo','Enlace1','Enlace2','Periodo1','Periodo2']
#df      = pd.DataFrame(columns=columns)
#
#for entrie in entries:
#    if entrie.find('est_senamhi_')==0:
#        data_i = pd.read_csv(entrie, error_bad_lines=False)
#        df = pd.concat([df,data_i],ignore_index=True)
#        del data_i
path2   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/_dato_esta_tipo02.php?estaciones=105063&CBOFiltro=201701&t_e=M&estado=REAL&cod_old=&cate_esta=MAP&alt=24"
enlace1 = ["AUTOMATICA","REAL"]
tipo    = enlace1[1]
fechas  = ['2017-01','2017-02','2017-03','2018-01','2018-02','2018-03']
i = 0
data    = pd.read_csv('joelito.csv')
data    = data.dropna(subset=['PERIODO2'])
for index, row in data.iterrows():
    ini_list = row['PERIODO2']
    fechas   = ini_list.strip('][').split(', ')
    id_alt   = row['ALTITUD'].find(' msnm')
    altitud  = row['ALTITUD'][:id_alt]
    altitud  = float(altitud)
    altitud  = int(altitud)
    altitud  = str(altitud)
    if row['CODIGO'][0]=='4':
        tipo = enlace1[0]
    for fecha in fechas:
        guardado = 0
        for entrie in entries:
            if entrie.find(str(row['CODIGO'])+'_'+fecha)>0:
                guardado = 1
                print("Guardado")      
        if guardado==0: 
            path_x = path2[:84]+str(row['CODIGO'])+path2[90:101]+fecha[:4]+fecha[5:]+path2[107:121]+tipo+path2[125:153]+altitud
            dfs    = pd.read_html(path_x)
            if len(dfs[1])>1:
                data = dfs[1]
                i = i+1
                print("NUEVO "+str(i))
                data.to_csv('estacion_'+str(row['CODIGO'])+'_'+fecha+'.csv',encoding='utf-8',header=False,index=False)
            
