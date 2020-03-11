import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_sen_vnp_D')

frames1 = []
i = 0
for entrie in entries:
    dfsx = pd.read_csv(cwd+'/est_sen_vnp_D/'+entrie)
    frames1.append(dfsx)
    i = len(dfsx)+i
    print(i)
    del dfsx
result1 = pd.concat(frames1)
print(len(result1))
result1.to_csv('rain_sen_vnp_DT.csv',encoding='utf-8',index=False)
