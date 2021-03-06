SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblICD10

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblICD10]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
						 FROM mrr_tbl.CNC_tblICD10
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblICD10])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblICD10]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[ICD10_ID], [Patient_ID], [Version_ID], [Diagnosis_Date], [RMO_GP_Flag_ID], [Diagnosis_By_ID], [RMO_Name_ID], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [RMO_Confirm_Date], [Prev_Psy_Episode_ID], [Primary_Diag], [Secondary_Diag_1], [Secondary_Diag_2], [Secondary_Diag_3], [Secondary_Diag_4], [Secondary_Diag_5], [Secondary_Diag_6], [Secondary_Diag_7], [Accept_Previous_Primary_Diag_ID], [Accept_Previous_Secondary_Diag1_ID], [Accept_Previous_Secondary_Diag2_ID], [Accept_Previous_Secondary_Diag3_ID], [Accept_Previous_Secondary_Diag4_ID], [Accept_Previous_Secondary_Diag5_ID], [Accept_Previous_Secondary_Diag6_ID], [End_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Status_Of_Diagnosis_ID]
						 FROM mrr_tbl.CNC_tblICD10))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblICD10 has discrepancies when compared to its source table.', 1;

				END;
				
GO
