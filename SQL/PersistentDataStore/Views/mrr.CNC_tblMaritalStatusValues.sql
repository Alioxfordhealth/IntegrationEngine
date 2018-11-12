SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNC_tblMaritalStatusValues] AS SELECT [Marital_Status_ID], [Marital_Status_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [OHMirror].[Mirror].[mrr_tbl].[CNC_tblMaritalStatusValues];
GO
