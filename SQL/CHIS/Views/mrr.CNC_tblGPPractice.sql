SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblGPPractice] AS SELECT [GP_ID], [Practice_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM  [Mirror].[mrr_tbl].[CNC_tblGPPractice];

GO
