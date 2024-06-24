# -*- coding: utf-8 -*-
"""
Created on Thu Feb 25 18:01:09 2021

@author: mcook49
"""

import pandas as pd, os, re
name = 'CROWNKim'
path = 'C:\\Users\\mcook49\\Documents\\Projections\\V2\\' +name +'Projection.csv'
output = 'C:\\Users\\mcook49\\Documents\\Projections\\V2\\' +name +'ProjectionReady.csv'
df=pd.read_csv(path)

#df['Command'] = """select * \ninto CROWNAvery_Scratch.dbo.""" +df['Table'] +"""_backup from CROWNAvery_Projection.dbo.""" +df['Table'] 

#df['Is_Derived'] = df.Table_Name.str.lower().str.contains("derived")
df['Table_Name'] = df['Table_Name'].str.lower()

df['First_Index'] = df['Table_Name'].str.index('_')

df['First_Half'] = [x[:y] for x , y in zip(df.Table_Name,df.First_Index) ]

df['Second_Half'] = [x[(y+1):] for x , y in zip(df.Table_Name,df.First_Index) ]

df['Command'] = """
val sourceTable = \"""" +df.First_Half +""".""" + df.Second_Half +""""
val destTable = \"""" +df.Table_Name  +"""" 

val columns = Utilities.getColsAsString(sourceTable)

val ldsOverrideCols = ""
val join = ""
val whereClause = \"""

\""".trim

updateTable(projID, sourceTable, columns, whereClause, destTable, cohortIDType, cohortName, ldsFlag, ldsOverrideCols, 
          removePatientIDColumn = true,
          dictionaryTable = false,
          useTempDestTable = true,
          printDDL = false, printSelect = false, verifyOnly = false, customJoin = join, filterSensitive = filterSensitive)
"""
df = df.sort_values(by = 'Table_Name')
df.to_csv(output, sep = ',', index = False)

#val join = "INNER JOIN ccda.CCDA####_PI_IRB####_adult_age_dates d on src.pat_id = d.pat_id"
#val whereClause = \"""
#src.contact_date >= d.adult_age_date
#\""".trim

#contact_date between '01-01-2019' AND '12-31-2019'