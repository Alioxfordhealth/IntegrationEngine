SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblAttachment

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblAttachment]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Attachment_ID], [Patient_ID], [Doc_Author_Staff_ID], [Doc_Date], [General_Document_Category_ID], [Doc_Title], [Attachment_Status_ID], [Attachment_Status_By_Staff_ID], [Attachment_Status_Date], [Version_Group], [Version_Number], [On_Behalf_Of_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Comments]
						 FROM mrr_tbl.CNS_tblAttachment
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Attachment_ID], [Patient_ID], [Doc_Author_Staff_ID], [Doc_Date], [General_Document_Category_ID], [Doc_Title], [Attachment_Status_ID], [Attachment_Status_By_Staff_ID], [Attachment_Status_Date], [Version_Group], [Version_Number], [On_Behalf_Of_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Comments]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAttachment])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Attachment_ID], [Patient_ID], [Doc_Author_Staff_ID], [Doc_Date], [General_Document_Category_ID], [Doc_Title], [Attachment_Status_ID], [Attachment_Status_By_Staff_ID], [Attachment_Status_Date], [Version_Group], [Version_Number], [On_Behalf_Of_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Comments]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblAttachment]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Attachment_ID], [Patient_ID], [Doc_Author_Staff_ID], [Doc_Date], [General_Document_Category_ID], [Doc_Title], [Attachment_Status_ID], [Attachment_Status_By_Staff_ID], [Attachment_Status_Date], [Version_Group], [Version_Number], [On_Behalf_Of_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Object_Type_ID], [Comments]
						 FROM mrr_tbl.CNS_tblAttachment))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblAttachment has discrepancies when compared to its source table.', 1;

				END;
				
GO
