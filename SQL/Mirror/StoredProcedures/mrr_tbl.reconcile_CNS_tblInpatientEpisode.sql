SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblInpatientEpisode

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblInpatientEpisode]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
						 FROM mrr_tbl.CNS_tblInpatientEpisode
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblInpatientEpisode])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblInpatientEpisode]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
						 FROM mrr_tbl.CNS_tblInpatientEpisode))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblInpatientEpisode has discrepancies when compared to its source table.', 1;

				END;
				
GO
