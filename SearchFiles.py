# -*- coding: utf-8 -*-
"""
Created on Tue May  3 16:16:54 2022

@author: mcook49
"""
import os

path = "T:\EB\GP\CCDA\CCDA_Delivery_projects\CCDAExtractionServices\Production"

for root, dirs, files in os.walk(path):
    for name in files:
        if "Antar" in name or "antar" in name:
            print(name)