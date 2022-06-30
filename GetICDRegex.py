# -*- coding: utf-8 -*-
"""
Created on Mon Sep 27 14:55:57 2021

@author: mcook49
"""

import re
r1 = '[CD]\d\d.\d'
text  = """
Malignant neoplasm of trigone of bladder	C67.0
malignant neoplasm of dome of bladder	C67.1
Malignant neoplasm of lateral wall of bladder	C67.2
Malignant neoplasm of anterior wall of bladder	C67.3
Malignant neoplasm of posterior wall of bladder	C67.4
Malignant neoplasm of bladder neck	C67.5
Malignant neoplasm of ureteric orifice	C67.6
Malignant neoplasm of urachus	C67.7
Malignant neoplasm of overlapping sites of bladder	C67.8
Malignant neoplasm of bladder, unspecified	C67.9
Malignant neoplasm of right renal pelvis	C65.1
Malignant neoplasm of left renal pelvis	C65.2
Malignant neoplasm of unspecified renal pelvis	C65.9
Neoplasm of unspecified behavior of bladder	D49.4
Carcinoma in situ of bladder	D09.0
Malignant neoplasm of right ureter	C66.1
 Malignant neoplasm of left ureter	C66.2
 Malignant neoplasm of unspecified ureter	C66.9

"""
sde1 = re.findall(r1, text)
sde1.sort()
print(sde1)