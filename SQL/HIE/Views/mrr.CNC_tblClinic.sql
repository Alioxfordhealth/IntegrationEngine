SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblClinic] AS SELECT [Clinic_ID], [Clinic_Name], [Administrator_Staff_ID], [Clinic_Location_ID], [Clinic_Type_ID], [Active_Flag_ID], [External_Code1], [External_Code2], [Allow_First_Appointments_Flag_ID], [Start_Time], [End_Time], [Clinic_Schedule_Type_ID], [Number_Of_Weeks], [Clinic_Period_Start_Date], [Clinic_Period_End_Date], [Slot_Size_Minutes], [SMS_Appointment_Reminders_Flag_ID], [SMS_Message_Tail], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Colour_Code], [Clinic_Group_ID], [Referral_Required_Flag_ID], [Multi_Patient_Required_Flag_ID], [Auto_Generate_Overbook_Slots_ID] FROM [Mirror].[mrr_tbl].[CNC_tblClinic];

GO
