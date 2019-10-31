SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNS_tblServiceValues] AS SELECT [Service_ID], [Service_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Specialist_CAMHS_ID], [Restricted_Access_ID] FROM [Mirror].[mrr_tbl].[CNS_tblServiceValues];
GO
