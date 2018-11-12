SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNC_tblGP] AS SELECT [GP_ID], [GP_Code], [First_Name], [Last_Name], [Admitting_GP_Flag_ID], [Active_ID], [Locally_Managed_ID], [FHSA_Code], [Email_Address], [Enable_Email_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [OHMirror].[Mirror].[mrr_tbl].[CNC_tblGP];
GO
