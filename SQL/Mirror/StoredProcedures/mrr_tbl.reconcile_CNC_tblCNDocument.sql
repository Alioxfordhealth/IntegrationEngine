SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblCNDocument

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblCNDocument]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CN_Doc_ID], [Patient_ID], [Referral_ID], [Episode_ID], [CN_Object_ID], [Object_Type_ID], [Icon], [ViewDate], [ViewTime], [ViewDttm], [ViewText], [ViewForm], [CNV3_Universal_ID], [Is_Active], [Active_Period_End_Dttm], [Current_Indicator], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Service_ID]
						 FROM mrr_tbl.CNC_tblCNDocument
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CN_Doc_ID], [Patient_ID], [Referral_ID], [Episode_ID], [CN_Object_ID], [Object_Type_ID], [Icon], [ViewDate], [ViewTime], [ViewDttm], [ViewText], [ViewForm], [CNV3_Universal_ID], [Is_Active], [Active_Period_End_Dttm], [Current_Indicator], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Service_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblCNDocument])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CN_Doc_ID], [Patient_ID], [Referral_ID], [Episode_ID], [CN_Object_ID], [Object_Type_ID], [Icon], [ViewDate], [ViewTime], [ViewDttm], [ViewText], [ViewForm], [CNV3_Universal_ID], [Is_Active], [Active_Period_End_Dttm], [Current_Indicator], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Service_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblCNDocument]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CN_Doc_ID], [Patient_ID], [Referral_ID], [Episode_ID], [CN_Object_ID], [Object_Type_ID], [Icon], [ViewDate], [ViewTime], [ViewDttm], [ViewText], [ViewForm], [CNV3_Universal_ID], [Is_Active], [Active_Period_End_Dttm], [Current_Indicator], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Service_ID]
						 FROM mrr_tbl.CNC_tblCNDocument))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblCNDocument has discrepancies when compared to its source table.', 1;

				END;
				
GO
