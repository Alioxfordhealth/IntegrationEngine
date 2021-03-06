SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblObjectTypeValues

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblObjectTypeValues]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Object_Type_ID], [Object_Type_Desc], [Object_Type_GUID], [Form_Title], [Allow_Instances], [Tab_ID], [Show_On_Summary_Tab_ID], [Quick_Create_Link_ID], [Virtual_Parent_Document_ID], [Default_Icon], [Assembly_Name], [Data_Class_Namespace], [Data_Class_Name], [Form_Name], [Key_Table_Name], [Key_Field_Name], [Default_View_Form], [Auto_Close_Permitted_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblObjectTypeValues
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Object_Type_ID], [Object_Type_Desc], [Object_Type_GUID], [Form_Title], [Allow_Instances], [Tab_ID], [Show_On_Summary_Tab_ID], [Quick_Create_Link_ID], [Virtual_Parent_Document_ID], [Default_Icon], [Assembly_Name], [Data_Class_Namespace], [Data_Class_Name], [Form_Name], [Key_Table_Name], [Key_Field_Name], [Default_View_Form], [Auto_Close_Permitted_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblObjectTypeValues])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Object_Type_ID], [Object_Type_Desc], [Object_Type_GUID], [Form_Title], [Allow_Instances], [Tab_ID], [Show_On_Summary_Tab_ID], [Quick_Create_Link_ID], [Virtual_Parent_Document_ID], [Default_Icon], [Assembly_Name], [Data_Class_Namespace], [Data_Class_Name], [Form_Name], [Key_Table_Name], [Key_Field_Name], [Default_View_Form], [Auto_Close_Permitted_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblObjectTypeValues]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Object_Type_ID], [Object_Type_Desc], [Object_Type_GUID], [Form_Title], [Allow_Instances], [Tab_ID], [Show_On_Summary_Tab_ID], [Quick_Create_Link_ID], [Virtual_Parent_Document_ID], [Default_Icon], [Assembly_Name], [Data_Class_Namespace], [Data_Class_Name], [Form_Name], [Key_Table_Name], [Key_Field_Name], [Default_View_Form], [Auto_Close_Permitted_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblObjectTypeValues))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblObjectTypeValues has discrepancies when compared to its source table.', 1;

				END;
				
GO
