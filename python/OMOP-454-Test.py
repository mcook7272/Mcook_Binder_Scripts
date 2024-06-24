# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 10:40:45 2023

@author: mcook49
"""
#Subset of notes_text. Update if needed
table = "derived.notes_text"
ptLists = ['Hamill_IRB00340016_Patients','test']
database = 'jhm_omop_source_tables_2023_07_06'
versionDateStr = '2023_07_06'
table_name = table.split(".")[1]
try:
    #print("Getting filtered {} version of {}".format(dbutils.widgets.get(SOURCE_DATA_DATE), table))
    text_long = """
      create table if not exists {}.{}
      using delta
      as 
      (SELECT DISTINCT txt.note_id
      FROM {} txt
      inner join {}.epic_notes_metadata notes on txt.note_id = notes.note_id
      INNER JOIN {}.id_map id ON notes.pat_id = id.altid AND id.altid_type = 'pat_id'
      INNER JOIN {}.patientlists l ON id.oslerid = l.member_id
        WHERE l.list_name in ({})
            AND notes.note_status_c = 2
            AND upper(notes.text_exists_yn) = 'Y'
            AND upper(notes.lists_resolved_yn) = 'Y'
            AND notes.ip_note_type_c IN ('1', '38', '2', '5', '6', '19', '8', '4', '35', '1600000002', '2100000001')
            AND notes.author_specialty IN ('Infectious Disease', 'Adolescent Medicine', 'Internal Medicine')
            AND notes.create_instant_dttm >= '2016-07-01'
      timestamp as of "{}")
      """.format(database, table_name, table, database, database, database, ptLists, versionDateStr)
    print(text_long)
except:
  print("no good")

print('\',\''.join(ptLists))
