select distinct map.un_masked_order_med_id "order_med_id"
  FROM [ACCM_Fackler_IRB00361235_Projection].[phi].[MedOrder_Mapping_Table] map
  join [ACCM_Fackler_IRB00361235_Scratch].dbo.target_cefepime_orders_test target on map.masked_order_med_id = target.order_med_id