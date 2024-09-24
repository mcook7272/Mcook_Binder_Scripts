
--Determine JH locations base don loc_id in CLARITY
when loc.LOC_ID like '1101%'  THEN 'Johns Hopkins Hospital'           --'JHH'
      when loc.LOC_ID like '1102%'  THEN 'Bayview'                          --'BMC'
      when loc.LOC_ID like '1103%'  THEN 'Howard County General'            --'HCG'    
      when loc.LOC_ID like '1104%'  THEN 'Sibly Memorial Hospital'          --'SMH'
      when loc.LOC_ID like '1105%'  THEN 'Suburban Hospital'                --'SUB'
      when loc.LOC_ID like '1107%'  THEN 'Kennedy Krieger Institute'        --'KKI'
      when loc.LOC_ID like '113001' THEN 'Greenspring'                      --'GSS'    
      when loc.LOC_ID like '113074' THEN 'SOM' 
	 WHEN LOC.LOC_NAME LIKE '%JHCP%' then 'JHCP';