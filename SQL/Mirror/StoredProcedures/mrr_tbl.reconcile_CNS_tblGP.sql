SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblGP

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblGP]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[GP_ID], [GP_Code], [First_Name], [Last_Name], [Admitting_GP_Flag_ID], [Active_ID], [Locally_Managed_ID], [FHSA_Code], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblGP
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[GP_ID], [GP_Code], [First_Name], [Last_Name], [Admitting_GP_Flag_ID], [Active_ID], [Locally_Managed_ID], [FHSA_Code], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblGP])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[GP_ID], [GP_Code], [First_Name], [Last_Name], [Admitting_GP_Flag_ID], [Active_ID], [Locally_Managed_ID], [FHSA_Code], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblGP]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[GP_ID], [GP_Code], [First_Name], [Last_Name], [Admitting_GP_Flag_ID], [Active_ID], [Locally_Managed_ID], [FHSA_Code], [Email_Address], [Enable_Email_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNS_tblGP))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblGP has discrepancies when compared to its source table.', 1;

				END;
				
GO
