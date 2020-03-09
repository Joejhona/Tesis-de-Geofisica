import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_total')

for entrie in entries:
    dfs = pd.read_csv(cwd+'/est_total/'+entrie)
    