SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNS_tblPractice] AS SELECT [Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID] FROM [OHMirror].[Mirror].[mrr_tbl].[CNS_tblPractice];
GO
