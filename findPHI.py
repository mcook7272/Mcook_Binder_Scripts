# -*- coding: utf-8 -*-
"""
Created on Wed Jul 29 10:27:18 2020

@author: mcook49
"""

import glob, os, pandas as pd
dbName = 'JH_CROWN'
path = 'C:\\Users\\mcook49\\Documents\\PHI_Fields\\' +dbName +'\\*.csv'
output = 'C:\\Users\\mcook49\\Documents\\PHI_Fields\\'+dbName +'_PHI_Fields.csv'
#files = glob.glob('C:\\Users\\mcook49\\Documents\\Data_Dictionary\\PMAP_Missing_Fields\\*.csv')
#df = pd.read_csv(files[1])
#df = df[df['Description'].isnull()]
df2 = pd.DataFrame()
#df2 = df2.append(df)
names = []
for fname in glob.glob(path):
   names.append(fname)
   df=pd.read_csv(fname)
   df = df[['Table','Database','Column']]
   df2 = df2.append(df)
df2 = df2.rename(columns={"Table": "table_name", "Database": "database_name", "Column": "field_name"})
df2.insert(0, 'ID', '')
df2.insert(3, 'schema', 'dbo')
df2 = df2.sort_values(by = ['field_name'])
#df2.iloc[df2.field_name.str.lower().argsort()]
df2.to_csv(output, sep = ',', index = False)
