SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblAlert] AS SELECT [Alert_ID], [Patient_ID], [Start_Date], [Start_Time], [Start_Authorised_By_Staff_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Time], [End_Authorised_By_Staff_ID], [Alert_Type_ID], [Alert_Description], [Alert_Comment], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblAlert];

GO
