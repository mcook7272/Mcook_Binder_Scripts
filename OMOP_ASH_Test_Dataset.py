# -*- coding: utf-8 -*-
"""
Created on Thu Feb 17 12:58:24 2022

@author: mcook49
"""

import pandas as pd
#https://github.com/prometheusresearch/rex_deliver_dataset
#Run rex_deliver_dataset --config=jhu_rdd_tes_creds.yaml C:\Users\mcook49\Documents\OMOP_ASH\Test_Data
path = 'C:\\Users\\mcook49\\Documents\\OMOP_ASH\\TEST_Data\\person.csv'
output = 'C:\\Users\\mcook49\\Documents\\OMOP_ASH\\TEST_Data\\person2.csv' #In future, output should be OMOP_Table_Name.csv (ex: person.csv, visit_occurrence.csv, etc)
df=pd.read_csv(path,skipinitialspace=True)
df["birth_datetime"] = df.birth_datetime.str.replace(' 00:00:00.0000000', 'T00:00:00.0000000')
df.to_csv(output, sep = ',', index = False)
