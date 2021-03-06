SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblAlert

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblAlert]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Alert_ID], [Patient_ID], [Start_Date], [Start_Time], [Start_Authorised_By_Staff_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Time], [End_Authorised_By_Staff_ID], [Alert_Type_ID], [Alert_Description], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblAlert
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Alert_ID], [Patient_ID], [Start_Date], [Start_Time], [Start_Authorised_By_Staff_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Time], [End_Authorised_By_Staff_ID], [Alert_Type_ID], [Alert_Description], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAlert])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Alert_ID], [Patient_ID], [Start_Date], [Start_Time], [Start_Authorised_By_Staff_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Time], [End_Authorised_By_Staff_ID], [Alert_Type_ID], [Alert_Description], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAlert]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Alert_ID], [Patient_ID], [Start_Date], [Start_Time], [Start_Authorised_By_Staff_ID], [Review_Date], [Responsibility_Of_Staff_ID], [End_Date], [End_Time], [End_Authorised_By_Staff_ID], [Alert_Type_ID], [Alert_Description], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblAlert))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblAlert has discrepancies when compared to its source table.', 1;

				END;
				
GO
