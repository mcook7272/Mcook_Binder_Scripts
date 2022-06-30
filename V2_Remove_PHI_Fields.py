# -*- coding: utf-8 -*-
"""
Created on Fri Aug 27 10:30:20 2021

@author: mcook49
"""

cols = "tect,1,2,three".split(',')
phi = "phi,2".split(',')
#cols.extend(phi)
#list2 = list(dict.fromkeys(cols))
#new_list = list(set(cols).difference(phi))
#print(','.join(list(dict.fromkeys(cols))))
print(','.join([elem for elem in cols if elem not in phi]))