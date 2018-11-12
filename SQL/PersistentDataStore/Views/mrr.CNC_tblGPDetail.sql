SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNC_tblGPDetail] AS SELECT [GP_Detail_ID], [Patient_ID], [Permission_To_Contact_ID], [Start_Date], [End_Date], [GP_ID], [Practice_ID], [Contact_GP_ID], [Further_Information], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [CCG_ID], [Assumed_GP_ID] FROM [OHMirror].[Mirror].[mrr_tbl].[CNC_tblGPDetail];
GO
