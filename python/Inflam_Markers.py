# -*- coding: utf-8 -*-
"""
Created on Tue Aug  2 10:44:53 2022

@author: mcook49
"""
names = ['LDH','IL6','WBC','LYMPHOABS','Platelets','INR','ProtCActiv','ProtSActiv','AT3Activ','VWFRIST','AntiXaHep','AntiXaLMWH']

for name in names:
    text = """LEFT JOIN """ +name+""" ON inflam.pat_id = """ +name+""".pat_id
   AND inflam.specimen_recv_time = """ +name+""".specimen_recv_time"""
    
    print(text)
    
    
    
    # text = """
    # , """ +name+"""
    # AS (
    #    SELECT lab.pat_id, lab.ord_value AS """ +name+"""_ord_value, lab.ord_num_value AS """ +name+"""_ord_num_value, 
    #       lab.result_flag AS """ +name+"""_rslt_flag, lab.specimen_recv_time
    #    FROM derived.lab_results lab
    #    INNER JOIN inflam ON lab.pat_id = inflam.pat_id
    #       AND inflam.specimen_recv_time = lab.specimen_recv_time
    #    WHERE lower(lab.component_base_name) IN ('"""+name.lower()+"""')
    #    )
    # """
    
    # text = """""" +name+""".""" +name+"""_ord_value, """ +name+""".""" +name+"""_ord_num_value, """ +name+""".""" +name+"""_rslt_flag,"""