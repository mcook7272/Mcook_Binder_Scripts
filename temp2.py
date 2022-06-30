# -*- coding: utf-8 -*-
"""
Created on Fri Aug 14 15:40:41 2020

@author: mcook49
"""

import pandas as pd, os, re
path = 'C:\\Users\\mcook49\\Documents\\Projections\\ParikhProjection.csv'
output = 'C:\\Users\\mcook49\\Documents\\Projections\\ParikhProjectionReady.csv'
df=pd.read_csv(path)

#df['Command'] = """select * \ninto CROWNAvery_Scratch.dbo.""" +df['Table'] +"""_backup from CROWNAvery_Projection.dbo.""" +df['Table'] 

df['DestTabName']= df['DestTabName'].str.lower()
df['StoredProcedure'] = 'usp_populate_'+df['DestTabName']
df.to_csv(output, sep = ',', index = False)