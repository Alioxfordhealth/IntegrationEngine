SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblGenderValues] AS SELECT [Gender_ID], [Gender_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblGenderValues];
GO
