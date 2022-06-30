# -*- coding: utf-8 -*-
"""
Created on Wed Sep 16 12:08:18 2020

@author: mcook49
"""

import pandas as pd, os, re, openpyxl
path = 'C:\\Users\\mcook49\\Documents\\Projections\\MenezTables.csv'
output = 'C:\\Users\\mcook49\\Documents\\Projections\\MenezCommands.xlsx'
df=pd.read_csv(path, dtype = 'str')

#df['Command'] = """select * \ninto CROWNPermpalung_Scratch.dbo.""" +df['name'] +"""_01_10_2021 from CROWNPermpalung_Projection.dbo.""" +df['name'] +""";"""
#df['Command2'] = """sp_rename \'""" +df['name'] +"""\', \'""" +df['name'] +"""_11_20_2020\'"""
#df['Command'] = """SELECT *\ninto """ +df['DbName'] +""".dbo.""" +df['TableName'] +"""_backup\nfrom """ +df['DbName'] +""".dbo.""" +df['TableName'] +""";\ndrop table """ +df['DbName'] +""".dbo.""" +df['TableName']
#df['Command'] = """insert into project_CuratedTables(DestDBName, DestTabName, StoredProcedure, GroupName, ProjectCycle, NextRun)
#VALUES('""" +df['DestDBName'] +"""', 'derived_epic_vitals', 'usp_populate_derived_epic_vitals', 'CROWNHays', 7, '2020-10-19') """
#df['Command'] = """exec sp_rename '""" +df['name'] +"""', '""" +df['name']  +"""_10_16_2020'""" 
#df['DestTabName']= df['DestTabName'].str.lower()
#df['lda_group_meas_id'] = '\''+df['lda_group_meas_id'] +'\''
#print(df)
#df['Command'] = """select * \ninto CROWNMetkus_Scratch.dbo.""" +df['name'] +"""_Backup_11_05_2020 from CROWNAvery_Projection.dbo.""" +df['name']
#df['Command'] = """drop table if exists CROWNParikh_Projection.""" +df['TableName'] +""";"""
#df = df[df['TableName'].str.contains('dbo')]
#df['TableName'] = df
#df['Command'] = """SELECT * \nFROM PMAP_Staging.""" +df['TableName'] +"""_Parikh\nINTO CROWNParikh_Projection.""" +df['TableName'] +""";"""
#df['Command'] = """SELECT * \nINTO CROWNParikh_Projection.""" +df['TableName'] +"""\nFROM PMAP_Staging.""" +df['TableName'] +"""_Parikh;"""
#df['Command'] = """SELECT * \nINTO CROWNCharnaya_Scratch.dbo.""" +df['TableName'] +"""_backup_20210817""" +"""\nFROM CROWNCharnaya_Projection.dbo.""" +df['TableName'] +""";"""
df['Command'] = """SELECT id.patient_id \nINTO PMAP_Staging.dbo.""" +df['TableName'] +"""_masked""" +"""\nfrom PMAP_Staging.dbo.""" +df['TableName'] +""" pat\ninner join PMAP_Analytics.dbo.CCDA710_menez_osler_id_Mapping id on id.osler_id = pat.osler_id""" +""";"""
#df['Command'] = """DROP table if exists PMAP_Staging.dbo.""" +df['TableName'] +"""_masked;"""


df.to_excel(output, index = False)