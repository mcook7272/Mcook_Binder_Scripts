# -*- coding: utf-8 -*-
"""
Created on Tue Jun  9 08:39:11 2020

@author: mcook49
"""

import os, subprocess

#directory = os.fsencode('C:\\Users\\mcook49\\repos\\pmap-cookbook\\cookbook')
#os.system('cd C:\\Users\\mcook49\\repos\\pmap-cookbook\\cookbook')
#os.system('date')
#subprocess.call(['cd', 'C:\\Users\\mcook49\\repos\\pmap-cookbook\\cookbook'])
#subprocess.call(['jupyter', 'nbconvert', filename])

#for file in os.listdir(directory):
#     filename = os.fsdecode(file)
#     if filename.endswith(".ipynb"): 
#         cmd = 'jupyter nbconvert ' +filename
#         os.system(cmd)
#         continue
#     else:
#         continue
rootDir = 'C:\\Users\\mcook49\\repos\\pmap-cookbook'
for dirName, subdirList, fileList in os.walk(rootDir):
    print('Found directory: %s' % dirName)
    os.system('cd ' +dirName)
    for fname in fileList:
        if fname.endswith('.ipynb'):
            cmd = 'jupyter nbconvert ' +fname
            os.system(cmd)