SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblClinicalNote

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblClinicalNote]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
						 FROM mrr_tbl.CNC_tblClinicalNote
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClinicalNote])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblClinicalNote]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
						 FROM mrr_tbl.CNC_tblClinicalNote))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblClinicalNote has discrepancies when compared to its source table.', 1;

				END;
				
GO
