SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW  [mrr].[CNS_tblStaff] AS SELECT [Staff_ID], [Staff_Name], [Forename], [MiddleInitial], [Surname], [Active], [Staff_Type_ID], [Job_Title], [Email], [Enable_Email_ID], [Mobile], [Enable_Mobile_ID], [Employee_Ref], [Staff_Loc_ID], [Professional_Group_ID], [Occupation_Code_ID], [Specialty_ID], [Consultant_GMC_Code], [Available_Appointment_1], [Available_Appointment_2], [Available_Appointment_3], [Available_Appointment_4], [Available_Appointment_5], [Available_Appointment_6], [Available_Appointment_7], [Available_Appointment_8], [Available_Appointment_9], [Available_Appointment_10], [Additional_Information], [RC_Type_ID], [Appointment_Notes], [Staff_Notes], [Prescriber_PIN], [Prescriber_Type_ID], [Job_Role_Code_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [SDS_ID], [Default_Role_Profile_Code_ID], [IAPT_Training_ID], [CYP_IAPT_Dataset_Profession_ID], [Treatment_Function_Code_ID], [Clinician_Type_ID], [Gender_ID], [Religion_ID], [Professional_Registration_Entry], [Professional_Body_ID] FROM [Mirror].[mrr_tbl].[CNS_tblStaff];

GO
