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
#enlace1 = ["AUTOMATICA","REAL"]
estado  = ["REAL","AUTOMATICA","DIFERIDO"]
cate    = ['MAP','EMA',"PLU"]
#tipo    = enlace1[1]
#fechas  = ['2017-01','2017-02','2017-03','2018-01','2018-02','2018-03']
i = 0
data    = pd.read_csv('SENAMHI-HACK3.csv')
data    = data.dropna(subset=['per2'])
for index, row in data.iterrows():
    ini_list = row['per2']
    fechas   = ini_list.strip('][').split(', ')
    for fecha in fechas:
        guardado = 0
        for entrie in entries:
            if entrie.find(str(row['cod1'])+'_'+fecha)>0:
                guardado = 1
                print("Guardado")      
        if guardado==0: 
            if row['estado']=='DIFERIDO':
                path_x = path2[:84]+str(row['cod1'])+path2[90:101]+fecha[:4]+fecha[5:]+path2[107:121]+row['estado']+path2[125:134]+str(int(float(row['cod2'])))+path2[134:145]+row['cate']+path2[148:153]
                print(path_x)
            else:                
                path_x = path2[:84]+str(row['cod1'])+path2[90:101]+fecha[:4]+fecha[5:]+path2[107:121]+row['estado']+path2[125:145]+row['cate']+path2[148:153]
                print(path_x)
            dfs    = pd.read_html(path_x)
            if len(dfs[1])>2:
                data2 = dfs[1]
                i = i+1
                print("NUEVO "+str(i))
                data2.to_csv('estacion_'+str(row['cod1'])+'_'+fecha+'.csv',encoding='utf-8',header=False,index=False)
            
