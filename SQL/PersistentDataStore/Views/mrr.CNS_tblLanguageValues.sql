SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNS_tblLanguageValues] AS SELECT [Language_ID], [Language_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [OHMirror].[Mirror].[mrr_tbl].[CNS_tblLanguageValues];
GO
