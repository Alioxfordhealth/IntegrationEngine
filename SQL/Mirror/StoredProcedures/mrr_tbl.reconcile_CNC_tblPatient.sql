SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_tblPatient

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_tblPatient]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
						 FROM mrr_tbl.CNC_tblPatient
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblPatient])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblPatient]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Patient_ID], [Access_Restricted_ID], [NHS_Number], [Health_Card_Number1], [Health_Card_Number2], [DATIS_Key], [Title_ID], [Forename], [Middle_Name], [Surname], [Last_Name_At_Birth], [Patient_Name], [Date_Of_Birth], [Estimated_Year_Of_Birth], [Date_Of_Death], [Other_ID1], [Other_ID2], [Other_ID3], [Other_ID4], [Other_PJS_ID], [Cnv3_Unid], [Social_Service_ID], [National_Insurance_Number], [First_Year_Of_Care_Date], [First_Year_Of_Care_Text], [Accomodation_ID], [First_Language_ID], [Gender_ID], [Sexuality_ID], [Religion_ID], [Marital_Status_ID], [Lives_With_ID], [Ethnicity_ID], [Country_Of_Origin_ID], [Place_Of_Birth], [CAHMS_Care_Status_ID], [Copy_Letters_To_Client_ID], [Registered_Sex_Offender_ID], [NHS_Trace_Flag], [Employment_ID], [Welfare_Benefits_Client_ID], [Mobility_Problem_ID], [Hearing_Impairment_ID], [Visual_Impairment_ID], [DAT_Of_Residence_ID], [Housing_Status], [Is_Interpreter_Needed_ID], [Occupation_ID], [Overseas_Visitor_ID], [Asylum_Seeker_ID], [Has_A_Twin_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Patient_User_Field3_ID], [Patient_User_Field4_ID], [PDS_Patient_ID], [Withheld_Identity_Reason_ID], [NHS_Number_Verified_ID], [Preferred_Location_Of_Death_ID], [Soundex_Surname], [Soundex_Forename], [Risk_Unexpected_Death_ID], [Safeguarding_Vulnerability_Factors_ID], [Ex_British_Armed_Forces_ID], [Offence_History_Indication_ID]
						 FROM mrr_tbl.CNC_tblPatient))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_tblPatient has discrepancies when compared to its source table.', 1;

				END;
				
GO
