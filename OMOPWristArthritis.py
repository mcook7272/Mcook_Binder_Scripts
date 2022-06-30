# -*- coding: utf-8 -*-
"""
Created on Wed May 25 13:47:30 2022

@author: mcook49
"""

import os
import zipfile

path = "C:\\Users\\mcook49\\Documents\\Atlas\\Wrist_Arthritis\\Zip\\"
output = "C:\\Users\\mcook49\\Documents\\Atlas\\Wrist_Arthritis\\Data\\"

for root, dirs, files in os.walk(path):
    for name in files:
        if ".zip" in name:
            with zipfile.ZipFile((root +'\\'+name), 'r') as zip_ref:
                zip_ref.extractall(output)

import pandas as pd
import glob
import os
import subprocess

source = 'C:\\Users\\mcook49\\Documents\\Atlas\\Wrist_Arthritis\\Data\\'
destination = 'C:\\Users\\mcook49\\Documents\\Atlas\\Wrist_Arthritis\\Data2\\'


for root, dirs, files in os.walk(source):
    for name in files:
        if "Export" in name:
            os.rename(root +'\\' + name, destination + name)