SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNS_tblExternalCodeMapping] AS SELECT [External_Code_Mapping_Data_Source_ID], [Internal_Data_Key], [External_Code], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblExternalCodeMapping];

GO
