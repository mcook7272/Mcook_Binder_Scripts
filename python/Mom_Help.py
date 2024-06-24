# -*- coding: utf-8 -*-
"""
Created on Fri May 27 08:46:38 2022

@author: mcook49
"""

import pandas as pd
#First, download and install the Microsoft Remote Server Administration Tools (RSAT) if you can, maybe?
#in powershell, run Import-Module ActiveDirectory
path = 'C:\\Users\\mcook49\\Documents\\GP percent sort_sc_test_modified.csv'
output = 'C:\\Users\\mcook49\\Documents\\GP_percent_sort_sc_test_ready.xlsx' 
df=pd.read_csv(path)
for_con = df['Contract_Number']
df = df[['Contract_Number2','USD_Period_GP_pct']].drop_duplicates().reset_index(drop = True)
df = df.merge(for_con, left_on = 'Contract_Number2', right_on = 'Contract_Number' )
df = df[['Contract_Number','USD_Period_GP_pct']].drop_duplicates().reset_index(drop = True)
grp = df.groupby(by = ['Contract_Number']).USD_Period_GP_pct.count().reset_index(name='count').sort_values(['count'], ascending=False)
df_final = df.merge(grp, on = "Contract_Number").sort_values(['count','Contract_Number','USD_Period_GP_pct'], ascending=False)

df_final['idx'] = df_final.groupby('Contract_Number').cumcount() + 1

#df_final['pct_idx'] = 'pct_' + df_final.idx.astype(str)
#df_final['prc_idx'] = 'price_' + df_final.idx.astype(str)

pcts = df_final.pivot(index='Contract_Number',columns='idx',values='USD_Period_GP_pct')
pcts = pcts.reset_index().merge(grp)
#prc = df_final.pivot(index='Salesman',columns='prc_idx',values='price')

#pcts['count'] = df_final.set_index('Contract_Number')['count'].drop_duplicates()

fin = pcts.sort_values(['count','Contract_Number'], ascending = False)
fin = fin.drop('count', axis = 1).reset_index(drop = True)
#fin = fin.rename({"Contract_Number2":"Contract_Number"})
fin.to_excel(output, index = False)
#fin.to_csv(output, index = False)
