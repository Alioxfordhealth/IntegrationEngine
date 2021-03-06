SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblClientLink] AS SELECT [Client_Link_ID], [Patient_ID], [Start_Date], [Start_Authorised_By_Staff_ID], [Relationship_ID], [Linked_Patient_ID], [Reciprocal_Client_Link_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Authorised_By_Staff_ID], [Comment], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID] FROM [Mirror].[mrr_tbl].[CNC_tblClientLink];
GO
