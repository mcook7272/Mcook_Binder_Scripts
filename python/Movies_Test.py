# -*- coding: utf-8 -*-
"""
Created on Fri Feb 16 11:27:37 2024

@author: mcook49
"""
import pandas as pd, os, re, numpy as np
import matplotlib.pyplot as plt
import scipy.stats as stats
path = 'C:\\Users\\mcook49\\Documents\\Movies_List.txt'

with open(path) as f:
    print("".join(line for line in f if not line.isspace()))

#df=pd.read_csv(path)