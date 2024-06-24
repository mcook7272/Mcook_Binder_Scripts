# -*- coding: utf-8 -*-
"""
Created on Tue Oct 27 12:50:50 2020

@author: mcook49
"""

#Libraries needed
import sqlalchemy
import urllib.parse
import pandas as pd
import getpass
import pyodbc
#from SciServer import Authentication
myUserName = 'mcook49'
passwd = getpass.getpass('Password for ' + myUserName + ': ')
user = "win\\" + myUserName
#SQL Driver
driver="FreeTDS"
tds_ver="8.0"
# Database
host_ip="ESMPMDBPR4.WIN.AD.JHU.EDU" # Update this accordingly
db_port="1433"
db="COVID_Projection" # Update this accordingly
# Create Connection String
conn_str=("DRIVER={};Server={};PORT={};DATABASE={};UID={};PWD={};TDS_VERSION={}"
.format(driver, host_ip, db_port, db, user, passwd, tds_ver)
)
# Create Engine
engine = sqlalchemy.create_engine('mssql+pyodbc:///?odbc_connect=' +
urllib.parse.quote(conn_str)
)
notes = pd.read_csv("Note_IDs.txt", header = None)
query = "SELECT note_id, osler_id, pat_enc_csn_id, create_instant_dttm FROM [COVID_Projection].[dbo].[derived_epic_notes_metadata]"
df = pd.read_sql_query(query, engine)
#df