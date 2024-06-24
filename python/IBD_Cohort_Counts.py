# -*- coding: utf-8 -*-
"""
Created on Wed Sep  7 15:38:17 2022

@author: mcook49
"""
import pandas as pd, os, re
name = 'Garneau'
path1 = 'C:\\Users\\mcook49\\Downloads\\IBD_Cohort_Names.csv'
path2 = 'C:\\Users\\mcook49\\Downloads\\IBD_Cohort_Counts.csv'
output = 'C:\\Users\\mcook49\\Documents\\OMOP\\IBD_Cohort_Counts.csv'

df=pd.read_csv(path1)
df2 = pd.read_csv(path2)

seq = list(range(427,562))

dfs0 = pd.DataFrame.from_dict({'ID':  seq, 'Value': ['x']*len(seq)})
dfseq = pd.DataFrame.from_dict({'ID': range( min(seq), max(seq)+1 )}).merge(dfs0, on='ID', how='outer')

df3 = df.merge(dfseq, how = "inner", on = "ID")

df4 = df3.merge(df2, how = "left", left_on = "ID", right_on = "COHORT_DEFINITION_ID")[['ID','Name','row_count']]
df4['row_count'] = df4.row_count.fillna(0)
df4 = df4.sort_values(by = "ID", ascending = False)

#df['Command'] = """select * \ninto CROWNAvery_Scratch.dbo.""" +df['Table'] +"""_backup from CROWNAvery_Projection.dbo.""" +df['Table'] 

#df['DestTabName']= df['DestTabName'].str.lower()
#df['StoredProcedure'] = 'usp_populate_'+df['DestTabName']
#df['SchemaName'] = 'dbo'
#df = df.sort_values(by = 'DestTabName')
df4.to_csv(output, sep = ',', index = False)
