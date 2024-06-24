# -*- coding: utf-8 -*-
"""
Created on Wed Jan 11 11:51:38 2023

@author: mcook49
"""
#Find Folder

import os

path = "T:\EB\GP\CCDA\CCDA_Delivery_projects\CCDAExtractionServices\Production"

for root, dirs, files in os.walk(path):
    for name in files:
        if "target" in name or "target" in name:
            print(name)
            
            
            
            
            
            
            
            
#Generating SQL Joins
names = ['LDH','IL6','WBC','LYMPHOABS','Platelets','INR','ProtCActiv','ProtSActiv','AT3Activ','VWFRIST','AntiXaHep','AntiXaLMWH']

for name in names:
    text = """LEFT JOIN """ +name+""" ON inflam.pat_id = """ +name+""".pat_id
   AND inflam.specimen_recv_time = """ +name+""".specimen_recv_time"""
    
    print(text)
    
#Find date- first sunday of previous month
import calendar
from datetime import date
from dateutil.relativedelta import relativedelta

today = date.today()
#today = date.fromisoformat('2020-11-02')

past_date = (today - relativedelta(months=1)).replace(day=1)
amt = 6 - past_date.weekday()
new_date = past_date + relativedelta(days = amt)
date_str = str(new_date.year) + "-" +str(new_date.month) +"-" +str(new_date.day)
print(date_str)
