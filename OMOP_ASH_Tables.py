# -*- coding: utf-8 -*-
"""
Created on Fri Mar 25 09:45:32 2022

@author: mcook49
"""

import pandas as pd, os, re
path = 'C:\\Users\\mcook49\\Documents\\ASH_Tables.csv'
output = 'C:\\Users\\mcook49\\Documents\\ASH_Tables_Ready.csv'
df=pd.read_csv(path)


df['TableName']= df['TableName'].str.lower()
df['Command'] = "writeFile(spark.table(\"LanzkronASHOMOP."+df.TableName +"\"), \"/mnt/extract-int/staged/test/OMOP-155-ASH-Subset/" +df.TableName +".csv\")"
df = df.sort_values(by = 'TableName')
df.to_csv(output, sep = ',', index = False)