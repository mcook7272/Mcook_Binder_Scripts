# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 09:32:55 2023

@author: mcook49
"""
#import pywin32
from pathlib import Path
import win32com.client
#import pywin32 as win32com

#Output folder
output_dir = Path.cwd() / "Output"
output_dir.mkdir(parents = True, exist_ok = True)

#Connect to outlook
outlook = win32com.client.Dispatch("Outlook.Application").GetNamespace("MAPI")
