SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblReferralSourceValues

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblReferralSourceValues]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Referral_Source_ID], [Referral_Source_Desc], [Referral_Source_Type_ID], [Scope], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblReferralSourceValues
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Referral_Source_ID], [Referral_Source_Desc], [Referral_Source_Type_ID], [Scope], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblReferralSourceValues])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Referral_Source_ID], [Referral_Source_Desc], [Referral_Source_Type_ID], [Scope], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblReferralSourceValues]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Referral_Source_ID], [Referral_Source_Desc], [Referral_Source_Type_ID], [Scope], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblReferralSourceValues))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblReferralSourceValues has discrepancies when compared to its source table.', 1;

				END;
				
GO
