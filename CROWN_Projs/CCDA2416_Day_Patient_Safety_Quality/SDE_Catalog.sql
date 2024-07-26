%sql
WITH SDE AS 
(
   SELECT DISTINCT
      CON.CONCEPT_ID,
      CON.[NAME] "SDENAME",
      CON.PARENT_CONCEPT,
      CON.CONCEPT_TYPE_C,
      CON.INTERNAL_ID,
      CON.MASTER_FILE_ITEM,
      CON.MASTER_FILE_LINK,
      CON.CONCEPT_HIERARCHY 
   FROM
      CLARITY.CLARITY_CONCEPT CON 
   WHERE
      CON.CONCEPT_ID IN 
      (
         'EPIC#0377',
         'EPIC#1023',
         'EPIC#13146',
         'EPIC#13390',
         'EPIC#13523',
         'EPIC#18134',
         'EPIC#19428',
         'EPIC#21238',
         'EPIC#2412',
         'EPIC#31000004892',
         'EPIC#31000009346',
         'EPIC#31000020852',
         'EPIC#34189',
         'EPIC#34558',
         'EPIC#35458',
         'EPIC#39304',
         'EPIC#40656',
         'EPIC#40657',
         'EPIC#40659',
         'EPIC#40661',
         'EPIC#40663',
         'EPIC#40664',
         'EPIC#40668',
         'EPIC#40673',
         'EPIC#40674',
         'EPIC#40675',
         'EPIC#40677',
         'EPIC#40679',
         'EPIC#4099',
         'EPIC#4472',
         'EPIC#4652',
         'EPIC#4850',
         'EPIC#49835',
         'EPIC#53979',
         'EPIC#53981',
         'EPIC#66376',
         'EPIC#71703',
         'JHM#1509',
         'JHM#1510',
         'JHM#2006',
         'JHM#2007',
         'JHM#2020',
         'JHM#2021',
         'JHM#2147',
         'JHM#2326',
         'JHM#2330',
         'JHM#2333',
         'JHM#2337',
         'JHM#2338',
         'JHM#2355',
         'JHM#2356',
         'JHM#2357',
         'JHM#2358',
         'JHM#2359',
         'JHM#6340',
         'JHM#6341',
         'JHM#6342',
         'JHM#6343'
      )
)
SELECT DISTINCT
   CON.CONCEPT_ID,
   CON.NAME AS SDENAME,
   CON.PARENT_CONCEPT,
   ZC.NAME AS DATATYPE,
   CON.CONCEPT_TYPE_C,
   CAT.CATEGORIES,
   CAT.CATEGORY_NUMBER,
   CAT.LINE,
   CON.INTERNAL_ID,
   CON.MASTER_FILE_ITEM,
   CON.MASTER_FILE_LINK,
   CON.CONCEPT_HIERARCHY,
   FRM.FORM_ID,
   FRM.LINE 
FROM
   SDE 
   INNER JOIN
      CLARITY.ZC_DATA_TYPE ZC 
      ON SDE.DATA_TYPE_C = ZC.DATA_TYPE_C 
   INNER JOIN
      CLARITY.SMARTFORM_CONCEPT FRM 
      ON FRM.CONCEPT_ID = SDE.CONCEPT_ID 
   LEFT JOIN
      CLARITY.CONCEPT_CATEGORY CAT 
      ON SDE.CONCEPT_ID = CAT.CONCEPT_ID 
ORDER BY
   CON.CONCEPT_ID,
   CAT.CATEGORY_NUMBER