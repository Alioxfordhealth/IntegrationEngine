SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblDiaryAppointmentClinicianAttendee

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblDiaryAppointmentClinicianAttendee]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Diary_Appointment_ID], [Clinician_Attendee_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblDiaryAppointmentClinicianAttendee
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Diary_Appointment_ID], [Clinician_Attendee_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblDiaryAppointmentClinicianAttendee])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Diary_Appointment_ID], [Clinician_Attendee_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblDiaryAppointmentClinicianAttendee]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Diary_Appointment_ID], [Clinician_Attendee_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
						 FROM mrr_tbl.CNC_tblDiaryAppointmentClinicianAttendee))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblDiaryAppointmentClinicianAttendee has discrepancies when compared to its source table.', 1;

				END;
				
GO
