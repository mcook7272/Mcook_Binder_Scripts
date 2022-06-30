# -*- coding: utf-8 -*-
"""
Created on Mon Jul 13 12:22:35 2020

@author: mcook49
"""

text = """
  ,[order_proc_id]
      ,[pat_enc_csn_id]
      ,[order_status_c]
      ,[order_status]
      ,[order_type_c]
      ,[order_type]
      ,[order_class_c]
      ,[order_class]
      ,[lab_status_c]
      ,[future_or_stand]
      ,[ordering_mode]
      ,[parent_order_id]
      ,[or_csn_num]
      ,[or_csn_type]
      ,[proc_id]
      ,[proc_code]
      ,[proc_name]
      ,[proc_cat_id]
      ,[proc_cat_name]
      ,[proc_group_id]
      ,[proc_group_name]
      ,[eap_type_of_ser_c]
      ,[eap_type_of_service]
      ,[order_time]
      ,[instantiated_time]
      ,[result_time]
      ,[is_pending_ord_yn]
      ,[proc_date]
      ,[proc_start_time]
      ,[proc_ending_time]
      ,[ord_creatr_user_id]
      ,[instntor_user_id]
      ,[proc_perf_prov_id]
      ,[billing_prov_id]
      ,[authrzing_prov_id]
      ,[referring_prov_id]
      ,[cosigner_id]
      ,[reason_for_canc_c]
      ,[reason_for_cancel]
      ,[effective_dept_id]
      ,[department_name]
      ,[facility]
      ,[serv_area_id]
      ,[sensitive_yn]"""
      
#print(text)
text2 = text.replace('\n', '')
text2 = text2.replace('[', '')
text2 = text2.replace(']', '')
text3 = text2.replace(' ', '')
print(text3)
