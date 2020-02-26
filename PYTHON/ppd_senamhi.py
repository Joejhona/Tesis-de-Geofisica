import os
import pandas as pd

fechas  = ['2017-01','2017-02','2017-03','2018-01','2018-02','2018-03']
enlaces = ["REAL","AUTOMATICA","DIFERIDO"]
cates   = ['MAP',"PLU",'EMA']

rango1   = range(1,251,1)
rango2   = range(103000,119000,1000)
rango_x  = range(100000,100251,1)
for ran2 in rango2:
    for ran1 in rango1:
        rango_x.append(ran1+ran2)

path1   = "https://www.senamhi.gob.pe/mapas/mapa-estaciones-2/_dato_esta_tipo02.php?estaciones=111159&CBOFiltro=202001&t_e=M&estado=DIFERIDO&cod_old=156133&cate_esta=PLU&alt=2468"
vieja   = pd.read_csv("est-senamhi.csv")
vieja   = vieja[:523]

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_senamhi')

for x in rango_x:
    guardado = 0
    for entrie in entries:
        if entrie.find(str(x))>0:
            guardado = 1
            print("guardado")
    if guardado==0:
        for fecha in fechas:
            for enlace in enlaces[1:]:
                for cate in cates[1:]:
                    path_x = path1[:84]+str(x)+path1[90:101]+fecha[:4]+fecha[5:]+path1[107:121]+enlace+path1[129:138]+path1[144:155]+cate+path1[158:163]
