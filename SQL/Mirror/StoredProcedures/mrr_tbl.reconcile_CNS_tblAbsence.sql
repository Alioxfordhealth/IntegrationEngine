SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblAbsence

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblAbsence]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblAbsence
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAbsence])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAbsence]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblAbsence))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblAbsence has discrepancies when compared to its source table.', 1;

				END;
				
GO
