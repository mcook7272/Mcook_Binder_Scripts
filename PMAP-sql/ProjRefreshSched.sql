USE [PMAP_Analytics]
GO

UPDATE [dbo].[project_CuratedTables]
   SET ProjectCycle = CASE
							WHEN DestDBName = 'CROWNAlexander_Projection' THEN 7
							WHEN DestDBName = 'CROWNAtta_Projection' THEN 14
							WHEN DestDBName = 'CROWNAvery_Projection' THEN 30
							WHEN DestDBName = 'CROWNBarth_Projection' THEN 14
							WHEN DestDBName = 'CROWNBettegowda_Projection' THEN 7
							WHEN DestDBName = 'CROWNFabre_Projection' THEN 7
							WHEN DestDBName = 'CROWNHays_Projection' THEN 14
							WHEN DestDBName = 'CROWNLima_Projection' THEN 14
							WHEN DestDBName = 'CROWNMetkus_Projection' THEN 14
							WHEN DestDBName = 'CROWNNolley_Projection' THEN 7
							WHEN DestDBName = 'CROWNSarma_Projection' THEN 7
							WHEN DestDBName = 'CROWNSiddiqui_Projection' THEN 7
							WHEN DestDBName = 'CROWNSisson_Projection' THEN 7
							WHEN DestDBName = 'CROWNWoreta_Projection' THEN 7
							WHEN DestDBName = 'CROWNYu_Projection' THEN 7
						END
GO


