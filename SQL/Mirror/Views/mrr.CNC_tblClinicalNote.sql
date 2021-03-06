SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblClinicalNote] AS SELECT [Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Clinical_Note_Text], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML] FROM [Mirror].[mrr_tbl].[CNC_tblClinicalNote];
GO
