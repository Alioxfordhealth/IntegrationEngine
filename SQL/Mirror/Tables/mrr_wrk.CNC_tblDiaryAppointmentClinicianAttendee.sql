SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_wrk].[CNC_tblDiaryAppointmentClinicianAttendee](
	[Diary_Appointment_ID] [int] NOT NULL,
	[Clinician_Attendee_Staff_ID] [int] NOT NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
