SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblAttendanceTypeValues

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblAttendanceTypeValues]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Attendance_Type_ID], [Attendance_Type_Desc], [Appointment_Status_ID], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Lock_For_iNurse], [Clinician_Mandatory_ID]
						 FROM mrr_tbl.CNC_tblAttendanceTypeValues
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Attendance_Type_ID], [Attendance_Type_Desc], [Appointment_Status_ID], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Lock_For_iNurse], [Clinician_Mandatory_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAttendanceTypeValues])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Attendance_Type_ID], [Attendance_Type_Desc], [Appointment_Status_ID], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Lock_For_iNurse], [Clinician_Mandatory_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAttendanceTypeValues]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Attendance_Type_ID], [Attendance_Type_Desc], [Appointment_Status_ID], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Lock_For_iNurse], [Clinician_Mandatory_ID]
						 FROM mrr_tbl.CNC_tblAttendanceTypeValues))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblAttendanceTypeValues has discrepancies when compared to its source table.', 1;

				END;
				
GO
