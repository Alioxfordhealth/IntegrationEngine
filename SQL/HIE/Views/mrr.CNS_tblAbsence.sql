SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [mrr].[CNS_tblAbsence] AS SELECT [Absence_ID], [Patient_ID], [Absence_Type_ID], [AWOL_End_Reason_ID], [Address_Type_ID], [Location_ID], [Absence_Status_ID], [Planned_Start_Date], [Planned_Start_Time], [Planned_Start_Dttm], [Planned_End_Date], [Planned_End_Time], [Planned_End_Dttm], [Cancellation_Reason], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Tel_Home], [Tel_Home_Confidential_ID], [Tel_Mobile], [Tel_Mob_Confidential_ID], [Tel_Work], [Tel_Work_Confidential_ID], [Actual_Start_Date], [Actual_Start_Time], [Actual_Start_Dttm], [Actual_End_Date], [Actual_End_Time], [Actual_End_Dttm], [Sleepover_Location_ID], [Supervised_Community_Treatment_Considered_ID], [Supervised_Community_Treatment_Not_Used_Reasons_ID], [How_Did_Period_End_ID], [Conditions], [MHA_Section_Definition_ID], [Absence_RMO_ID], [S17_End_Reason_ID], [Comments], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNS_tblAbsence];

GO
