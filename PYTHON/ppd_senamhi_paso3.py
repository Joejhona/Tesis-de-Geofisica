import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_senamhi')

data    = pd.read_csv('SENAMHI-HACK4.csv')
#data    = pd.read_csv('SENAMHI-HACK3.csv')
#data    = data.dropna(subset=['per2'])
fechas  = ['2017-01','2017-02','2017-03','2018-01','2018-02','2018-03']
for index, row in data.iterrows():
    #ini_list = row['per2']
    #fechas   = ini_list.strip('][').split(', ')
    frames   = []
    for fecha in fechas:
        for entrie in entries:
            if entrie.find(str(row['cod1'])+'_'+fecha)>0:
                dfs = pd.read_csv(cwd+'/est_senamhi/estacion_'+str(row['cod1'])+'_'+fecha+'.csv')
                if dfs.iloc[0,0]=='MAX':
                    dfs = dfs[1:]
                frames.append(dfs)
    result = pd.concat(frames)
    result.to_csv(cwd+'/est_total/est_tot_'+str(row['cod1'])+'.csv',encoding='utf-8',index=False)
    del frames
    

