import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_sen_vnp')

frames1 = []
frames2 = []
i = 0
for entrie in entries:
    dfsx = pd.read_csv(cwd+'/est_sen_vnp/'+entrie)
    if dfsx.columns[0]=='H':
        frames1.append(dfsx)
    if dfsx.columns[0]=='D':
        frames2.append(dfsx)
    i = len(dfsx)+i
    print(i)
result1 = pd.concat(frames1)
result2 = pd.concat(frames2)
print(len(result1)+len(result2))
result1.to_csv('rain_sen_vnp_H.csv',encoding='utf-8',index=False)
result2.to_csv('rain_sen_vnp_D.csv',encoding='utf-8',index=False)
