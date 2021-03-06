SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblMHASection

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblMHASection]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHA_Section_ID], [Patient_ID], [MHA_Section_Definition_ID], [MHA_Nominated_Deputy], [Recommendation1_Staff_Name], [Recommendation1_Section_Approved_ID], [Recommendation2_Approver_ID], [Recommendation2_Section_Approved_ID], [Recommendation2_Staff_ID], [Recommendation2_GP_ID], [Recommendation2_Other], [Nurse_Name], [Social_Worker_Or_Nearest_Relative_ID], [Approved_Social_Worker_Staff_Name], [Nearest_Relative], [MHA_Mental_Category_ID], [Sub_MHA_Mental_Category_ID], [Admission_Type_ID], [Start_Date], [Start_Time], [Due_End_Date], [Due_End_Time], [New_Section], [Alert_Due_Date], [Alert_Due_Date2], [Alert_Send_To_Staff_ID], [End_Date], [End_Time], [MHA_Outcome_ID], [Outcome_Where_To], [Outcome_Where_From], [Date_Rights_Given_To_Patient], [Date_Letter_Sent_To_Social_Services], [Court_Name], [Court_Reference], [Home_Office_Warrant], [Social_Service_Contact_Name], [Social_Service_Contact_Date], [Assessment_Received_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Start_Reason_ID], [Transfer_Date]
						 FROM mrr_tbl.CNS_tblMHASection
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHA_Section_ID], [Patient_ID], [MHA_Section_Definition_ID], [MHA_Nominated_Deputy], [Recommendation1_Staff_Name], [Recommendation1_Section_Approved_ID], [Recommendation2_Approver_ID], [Recommendation2_Section_Approved_ID], [Recommendation2_Staff_ID], [Recommendation2_GP_ID], [Recommendation2_Other], [Nurse_Name], [Social_Worker_Or_Nearest_Relative_ID], [Approved_Social_Worker_Staff_Name], [Nearest_Relative], [MHA_Mental_Category_ID], [Sub_MHA_Mental_Category_ID], [Admission_Type_ID], [Start_Date], [Start_Time], [Due_End_Date], [Due_End_Time], [New_Section], [Alert_Due_Date], [Alert_Due_Date2], [Alert_Send_To_Staff_ID], [End_Date], [End_Time], [MHA_Outcome_ID], [Outcome_Where_To], [Outcome_Where_From], [Date_Rights_Given_To_Patient], [Date_Letter_Sent_To_Social_Services], [Court_Name], [Court_Reference], [Home_Office_Warrant], [Social_Service_Contact_Name], [Social_Service_Contact_Date], [Assessment_Received_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Start_Reason_ID], [Transfer_Date]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASection])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[MHA_Section_ID], [Patient_ID], [MHA_Section_Definition_ID], [MHA_Nominated_Deputy], [Recommendation1_Staff_Name], [Recommendation1_Section_Approved_ID], [Recommendation2_Approver_ID], [Recommendation2_Section_Approved_ID], [Recommendation2_Staff_ID], [Recommendation2_GP_ID], [Recommendation2_Other], [Nurse_Name], [Social_Worker_Or_Nearest_Relative_ID], [Approved_Social_Worker_Staff_Name], [Nearest_Relative], [MHA_Mental_Category_ID], [Sub_MHA_Mental_Category_ID], [Admission_Type_ID], [Start_Date], [Start_Time], [Due_End_Date], [Due_End_Time], [New_Section], [Alert_Due_Date], [Alert_Due_Date2], [Alert_Send_To_Staff_ID], [End_Date], [End_Time], [MHA_Outcome_ID], [Outcome_Where_To], [Outcome_Where_From], [Date_Rights_Given_To_Patient], [Date_Letter_Sent_To_Social_Services], [Court_Name], [Court_Reference], [Home_Office_Warrant], [Social_Service_Contact_Name], [Social_Service_Contact_Date], [Assessment_Received_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Start_Reason_ID], [Transfer_Date]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASection]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[MHA_Section_ID], [Patient_ID], [MHA_Section_Definition_ID], [MHA_Nominated_Deputy], [Recommendation1_Staff_Name], [Recommendation1_Section_Approved_ID], [Recommendation2_Approver_ID], [Recommendation2_Section_Approved_ID], [Recommendation2_Staff_ID], [Recommendation2_GP_ID], [Recommendation2_Other], [Nurse_Name], [Social_Worker_Or_Nearest_Relative_ID], [Approved_Social_Worker_Staff_Name], [Nearest_Relative], [MHA_Mental_Category_ID], [Sub_MHA_Mental_Category_ID], [Admission_Type_ID], [Start_Date], [Start_Time], [Due_End_Date], [Due_End_Time], [New_Section], [Alert_Due_Date], [Alert_Due_Date2], [Alert_Send_To_Staff_ID], [End_Date], [End_Time], [MHA_Outcome_ID], [Outcome_Where_To], [Outcome_Where_From], [Date_Rights_Given_To_Patient], [Date_Letter_Sent_To_Social_Services], [Court_Name], [Court_Reference], [Home_Office_Warrant], [Social_Service_Contact_Name], [Social_Service_Contact_Date], [Assessment_Received_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Start_Reason_ID], [Transfer_Date]
						 FROM mrr_tbl.CNS_tblMHASection))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblMHASection has discrepancies when compared to its source table.', 1;

				END;
				
GO
