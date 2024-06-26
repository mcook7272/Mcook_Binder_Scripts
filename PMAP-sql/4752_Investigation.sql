  select map.*
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  join [ACCM_Fackler_IRB00361235_Scratch].dbo.target_cefepime_orders target on map.masked_order_med_id = target.order_med_id
  --where target.cohort_id = 'ACB0p5zraptq03'

  select *
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  right join [ACCM_Fackler_IRB00361235_Scratch].dbo.target_cefepime_orders target on map.masked_order_med_id = target.order_med_id
  where map.masked_order_med_id is NULL

  select *
  FROM [ACCM_Fackler_IRB00361235_Projection].dbo.derived_med_orders map
  right join [ACCM_Fackler_IRB00361235_Scratch].dbo.target_cefepime_orders target on map.order_med_id = target.order_med_id
  where map.order_med_id is NULL

    select map.*
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  right join [ACCM_Fackler_IRB00361235_Projection].dbo.derived_med_orders target on map.masked_order_med_id = target.order_med_id
  where map.masked_order_med_id is NULL

  select *
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  right join [ACCM_Fackler_IRB00361235_Scratch].dbo.Cefepime_Orders target on map.masked_order_med_id = target.order_med_id
  where map.masked_order_med_id is NULL

  select distinct map.un_masked_order_med_id "order_med_id"
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  join [ACCM_Fackler_IRB00361235_Scratch].dbo.target_cefepime_orders_test target on map.masked_order_med_id = target.order_med_id

  select *
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  right join [ACCM_Fackler_IRB00361235_Scratch].[dbo].[CefepimeOrdersWithAttributes] target on map.masked_order_med_id = target.masked_order_med_id
  where map.masked_order_med_id is NULL

  select *
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table]
  WHERE masked_pat_enc_csn_id = '4145163329241310'
  --2882792983005660