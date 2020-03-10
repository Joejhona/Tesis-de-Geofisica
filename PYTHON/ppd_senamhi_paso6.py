import os
import pandas as pd

cwd     = os.getcwd()
entries = os.listdir(cwd+'/est_sen_rain')

dfs1 = pd.read_csv('prueba1.csv')
dfs2 = pd.read_csv('prueba2.csv')
dfs3 = pd.read_csv('SENAMHI-HACK5.csv')

for entrie in entries:
    id1 = entrie.find('.csv')
    #cod = int(entrie[2:id1])
    for index, row in dfs1.iterrows():
        if entrie[2:id1].isdigit():
            if row['cod1']==int(entrie[2:id1]):
                dfsx = pd.read_csv(cwd+'/est_sen_rain/'+entrie)
                dfsx['lat'] = row['nnlat']
                dfsx['lon'] = row['nnlon']
                for index2, row2 in dfs3.iterrows():
                    if row2['cod1']==row['cod1']:
                        id2 = row2['alt'].find(' msnm')
                        dfsx['alt'] = int(float(row2['alt'][:id2]))
                dfsx['cod_cu'] = row['CODIGO']
                dfsx['cuenca'] = row['NOMBRE']
                dfsx['cod_es'] = row['cod1']
                dfsx['estacion'] = row['Estacion']
                #dfsx.index = dfsx.columns[0]
                #dfsx.set_index(dfsx.columns[1])
                dfsx.to_csv(cwd+'/est_sen_vnp/'+entrie[:id1]+'_'+row['NOMBRE']+'.csv',encoding='utf-8',index=False)
                del dfsx
    for index3, row3 in dfs2.iterrows():
        if row3['codigo']==entrie[2:id1]:
            dfsx = pd.read_csv(cwd+'/est_sen_rain/'+entrie)
            dfsx['lat'] = row3['coord_x']
            dfsx['lon'] = row3['coord_y']
            dfsx['alt'] = row3['coord_z']
            dfsx['cod_cu'] = row3['CODIGO_2']
            dfsx['cuenca'] = row3['NOMBRE']
            dfsx['cod_es'] = row3['codigo']
            dfsx['estacion'] = row3['name']
            #dfsx.index = dfsx.columns[0]
            #dfsx.set_index(dfsx.columns[1])
            dfsx.to_csv(cwd+'/est_sen_vnp/'+entrie[:id1]+'_'+row3['NOMBRE']+'.csv',encoding='utf-8',index=False)
            del dfsx