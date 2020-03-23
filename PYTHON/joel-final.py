#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import matplotlib.pyplot as plt


# In[2]:


pdf = pd.read_csv('data_wrf_sen_sst.csv')
pdf = pdf.dropna(subset=['wrf'])
#pdf_es  = pdf.drop_duplicates(subset='estacion')
pdf_cu  = pdf.drop_duplicates(subset='cuenca')


# In[3]:


ssts    = ["-3sst","-2sst","-1sst","","+1sst","+2sst","+3sst"]
ssts2   = ["-3sst","-2sst","-1sst","N","+1sst","+2sst","+3sst"]
pers17  = ["2017-01-14","2017-01-21","2017-01-24","2017-01-30","2017-02-02",        "2017-02-25","2017-03-08","2017-03-13","2017-03-21","2017-03-25"]
difs    = []
wrfs    = []
xs      = [-3,-2,-1,0,1,2,3]
colors  = ['b','royalblue','cornflowerblue','black','indianred','firebrick','r']


# In[4]:


for sst in ssts:
    dif = 'dif'+sst
    difs.append(dif)
    wrf = 'wrf'+sst
    wrfs.append(wrf)
    pdf[dif]=pdf[wrf]-pdf['mm/d']


# In[7]:


pdf_cu


# In[69]:


for index, row in pdf_cu.iterrows():
    pdf_es = pdf[pdf['cuenca']==row['cuenca']].drop_duplicates(subset='estacion')
    pdf_es = pdf_es.sort_values(by=['alt'],ascending=False)
    n_est  = len(pdf_es)
    fig, axs = plt.subplots(figsize=(18,3*n_est),nrows=n_est,ncols=len(pers17),gridspec_kw={'hspace': 0, 'wspace': 0},sharex='col', sharey='row')
    j  = 0
    ls = []
    for index2, row2 in pdf_es.iterrows():
        pdf_x = pdf[pdf['estacion']==row2['estacion']]
        #ymm   = pdf_x[pdf_x['D'].isin(pers17)]   # 24 hrs
        #ymax  = ymm.loc[:,wrfs].max().max()+5
        #ymin  = ymm.loc[:,wrfs].min().min()-5
        i=0
        #print('['+str(j)+'],['+str(i)+']')
        for per in pers17:
            i_pdf = pdf_x[pdf_x['D']==per].index
            #print('['+str(j)+'],['+str(i)+']')
            ax    = axs[j,i]   
            #handles, labels = ax.get_legend_handles_labels()
            if i==0:
                ax.set_ylabel(row2['estacion']+' ('+str(int(row2['alt']))+' msnm.)\n \n mm/d')
                #ax.yaxis.set_label_position("right")
                #ax.yaxis.tick_right()
            i = i+1   
            if len(i_pdf)>0:
                for k in range(0,7):
                    y     = pdf_x.loc[i_pdf,'mm/d']
                    yerr  = pdf_x.loc[i_pdf,difs[k]]
                    tf    = False
                #i_pdf = pdf_x[pdf_x['D']==pers17[k]].index
                #print(i_pdf)
                #print(y)
                #print(yerr.item())
                #y     = pdf_x.loc[i_pdf,'mm/d']
                #yerr  = pdf_x.loc[i_pdf,difs[k]]
                #ax    = axs[i]
                #tf    = False
                    if yerr.item()>0:
                        tf = True
                #print(tf)
                    li = ax.errorbar(xs[k],y,yerr=abs(yerr),fmt='s',uplims=not tf,lolims=tf,ecolor=colors[k],mfc=colors[k],mec=colors[k])[0]
                    ls.append(li)
            if j==0:
                ax.set_title(per)
            ax.get_xaxis().set_visible(False)
        j = j+1
    
    #plt.legend(handler_map={line1: HandlerLine2D(numpoints=4)},bbox_to_anchor=(0., 1.02, 1., .102), loc='lower left',ncol=2, mode="expand", borderaxespad=0.)
    fig.legend(ls,labels=ssts2,loc=8,borderaxespad=0.1,ncol=7,fontsize='x-large')#,title="Legend Title")#['jj'],loc='lower right')
    fig.suptitle('This is a somewhat long figure title', fontsize=16)
    plt.subplots_adjust(bottom = 0.04,top = 0.92)
    plt.savefig('foo.png',bbox_inches='tight')
