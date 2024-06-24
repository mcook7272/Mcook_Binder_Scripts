# -*- coding: utf-8 -*-
"""
Created on Tue Jun  9 16:01:02 2020

@author: mcook49
"""

import glob, os, pandas as pd
path = 'C:\\Users\\mcook49\\Documents\\PMAP\\Missing_Fields\\*.csv'
output = 'C:\\Users\\mcook49\\Documents\\PMAP\\Missing_Fields\\CROWNMissingFields.csv'
#files = glob.glob('C:\\Users\\mcook49\\Documents\\Data_Dictionary\\PMAP_Missing_Fields\\*.csv')
#df = pd.read_csv(files[1])
#df = df[df['Description'].isnull()]
df2 = pd.DataFrame()
#df2 = df2.append(df)
names = []
for fname in glob.glob(path):
   names.append(fname)
   df=pd.read_csv(fname)
   df = df[df['Description'].isnull()]
   df2 = df2.append(df)
df2 = df2.drop(['Type', 'Description'], axis=1)
df2 = df2.sort_values(by = ['Database', 'Table'])
df2.to_csv(output, sep = ',', index = False)
