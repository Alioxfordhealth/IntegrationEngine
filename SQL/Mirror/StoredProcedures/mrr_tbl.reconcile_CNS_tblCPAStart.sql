SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblCPAStart

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblCPAStart]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CPA_Start_ID], [Patient_ID], [Start_Date], [Authorised_By_Staff_ID], [CPA_Tier_ID], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End], [Smoking_Status_ID]
						 FROM mrr_tbl.CNS_tblCPAStart
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CPA_Start_ID], [Patient_ID], [Start_Date], [Authorised_By_Staff_ID], [CPA_Tier_ID], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End], [Smoking_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAStart])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CPA_Start_ID], [Patient_ID], [Start_Date], [Authorised_By_Staff_ID], [CPA_Tier_ID], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End], [Smoking_Status_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAStart]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CPA_Start_ID], [Patient_ID], [Start_Date], [Authorised_By_Staff_ID], [CPA_Tier_ID], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End], [Smoking_Status_ID]
						 FROM mrr_tbl.CNS_tblCPAStart))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblCPAStart has discrepancies when compared to its source table.', 1;

				END;
				
GO
