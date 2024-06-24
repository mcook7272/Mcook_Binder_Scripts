# -*- coding: utf-8 -*-
"""
Created on Mon Apr  4 11:16:59 2022

@author: mcook49
"""

import pandas as pd
#First, download and install the Microsoft Remote Server Administration Tools (RSAT) if you can, maybe?
#in powershell, run Import-Module ActiveDirectory
path = 'C:\\Users\\mcook49\\Documents\\CROWNTables.csv'
output = 'C:\\Users\\mcook49\\Documents\\CROWNTablesReady.csv' 
df=pd.read_csv(path)
df = df[["TableName"]]
df = df[df.TableName.str.contains("Projection")]
df["ADGroup"] = df.TableName.str.split("_", expand = True)[0] +"_IRB_Researchers"
df["Command"] = "Get-ADGroupMember -Identity \"" +df.ADGroup +"\" -Recursive | Get-ADUser -Properties Mail | Select-Object Mail"
df.to_csv(output, sep = ',', index = False)