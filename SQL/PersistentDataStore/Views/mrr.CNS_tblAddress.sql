SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [mrr].[CNS_tblAddress] AS SELECT [Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID] FROM [OHMirror].[Mirror].[mrr_tbl].[CNS_tblAddress];
GO
