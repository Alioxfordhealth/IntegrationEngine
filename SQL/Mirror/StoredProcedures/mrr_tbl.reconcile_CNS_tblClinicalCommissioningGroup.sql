SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblClinicalCommissioningGroup

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblClinicalCommissioningGroup]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
						 FROM mrr_tbl.CNS_tblClinicalCommissioningGroup
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalCommissioningGroup])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalCommissioningGroup]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CCG_ID], [CCG_Identifier], [CCG_Name], [National_Grouping_Code], [High_Level_Health_Geography_Code], [Address_Line1], [Address_Line2], [Address_Line3], [Town], [County], [Post_Code], [Open_Date], [Close_Date], [Status], [Authorisation_Indicator], [Ammendment_Indicator], [Locally_Managed_Flag_ID], [Active_Flag_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Organisation_Sub_Type_Code], [Contact_Telephone_Number], [CCG_Record_Type_ID], [Organisation_Type_Code], [Country_Code]
						 FROM mrr_tbl.CNS_tblClinicalCommissioningGroup))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblClinicalCommissioningGroup has discrepancies when compared to its source table.', 1;

				END;
				
GO
