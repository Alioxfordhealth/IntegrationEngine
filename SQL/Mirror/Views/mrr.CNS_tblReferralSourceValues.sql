SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNS_tblReferralSourceValues] AS SELECT [Referral_Source_ID], [Referral_Source_Desc], [Referral_Source_Type_ID], [Scope], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblReferralSourceValues];
GO
