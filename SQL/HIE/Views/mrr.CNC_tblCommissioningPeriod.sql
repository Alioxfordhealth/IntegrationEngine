SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblCommissioningPeriod] AS SELECT [CommissioningPeriod_ID], [Location_ID], [Commissioner_ID], [Start_Date], [End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblCommissioningPeriod];

GO
