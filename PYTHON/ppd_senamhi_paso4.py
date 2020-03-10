import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_total')

for entrie in entries:
    dfs = pd.read_csv(cwd+'/est_total/'+entrie)
    if dfs.columns[4]=='Unnamed: 4':
        dfs = dfs.rename(columns={dfs.columns[4]:dfs.columns[3],dfs.columns[3]:dfs.columns[2],dfs.columns[2]:dfs.columns[1],dfs.columns[0]:'D'})
        dfs.index = pd.to_datetime(dfs['D'])
    if dfs.columns[1]=='HORA':
        dfs['H']=dfs[dfs.columns[0]]+' '+dfs[dfs.columns[1]]
        dfs.index = pd.to_datetime(dfs['H'])
    if dfs.index.name=='D' or dfs.index.name=='H':
        mm_cols = [col for col in dfs.columns if 'mm' in col]
        dfs=dfs[mm_cols]
        dfs.to_csv(cwd+'/est_sen_rain/'+dfs.index.name+'_'+entrie[8:],encoding='utf-8')
    
    