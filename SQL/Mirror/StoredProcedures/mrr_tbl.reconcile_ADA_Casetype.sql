SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_ADA_Casetype

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_ADA_Casetype]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CaseTypeRef], [ServiceRef], [Name], [Abbreviation], [Sort], [V2Import], [Obsolete], [Usage], [NationalCode], [Colour]
						 FROM mrr_tbl.ADA_Casetype
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CaseTypeRef], [ServiceRef], [Name], [Abbreviation], [Sort], [V2Import], [Obsolete], [Usage], [NationalCode], [Colour]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Casetype])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CaseTypeRef], [ServiceRef], [Name], [Abbreviation], [Sort], [V2Import], [Obsolete], [Usage], [NationalCode], [Colour]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Casetype]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CaseTypeRef], [ServiceRef], [Name], [Abbreviation], [Sort], [V2Import], [Obsolete], [Usage], [NationalCode], [Colour]
						 FROM mrr_tbl.ADA_Casetype))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.ADA_Casetype has discrepancies when compared to its source table.', 1;

				END;
				
GO
