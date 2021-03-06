SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblPractice] AS SELECT [Practice_ID], [Practice_Code], [Active_ID], [Locally_Managed_ID], [Practice_Name], [PCT_ID], [Fundholder_Code], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Enable_Email_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID] FROM [Mirror].[mrr_tbl].[CNC_tblPractice];

GO
