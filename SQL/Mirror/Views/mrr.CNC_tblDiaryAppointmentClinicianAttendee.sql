SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblDiaryAppointmentClinicianAttendee] AS SELECT [Diary_Appointment_ID], [Clinician_Attendee_Staff_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblDiaryAppointmentClinicianAttendee];
GO
