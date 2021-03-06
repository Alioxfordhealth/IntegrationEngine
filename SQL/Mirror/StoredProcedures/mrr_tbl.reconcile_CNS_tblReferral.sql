SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblReferral

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblReferral]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Referral_ID], [Patient_ID], [Spell_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Referral_Received_Time], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Referral_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Person_Present_ID], [Consent_Given_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Referred_To_Service_ID], [Referred_To_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Referral_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Spell_ID], [Discharge_Destination_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [Reason_For_Out_Of_Area_Referral_ID], [Rejection_Time]
						 FROM mrr_tbl.CNS_tblReferral
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Referral_ID], [Patient_ID], [Spell_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Referral_Received_Time], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Referral_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Person_Present_ID], [Consent_Given_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Referred_To_Service_ID], [Referred_To_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Referral_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Spell_ID], [Discharge_Destination_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [Reason_For_Out_Of_Area_Referral_ID], [Rejection_Time]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblReferral])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Referral_ID], [Patient_ID], [Spell_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Referral_Received_Time], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Referral_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Person_Present_ID], [Consent_Given_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Referred_To_Service_ID], [Referred_To_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Referral_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Spell_ID], [Discharge_Destination_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [Reason_For_Out_Of_Area_Referral_ID], [Rejection_Time]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblReferral]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Referral_ID], [Patient_ID], [Spell_ID], [Referral_Date], [Referral_Time], [Referral_Received_Date], [Referral_Received_Time], [Last_Contact_Date], [Referral_Source_ID], [Referral_Source_Type_ID], [Agency_ID], [Contact_Name], [Contact_Job_Title], [Contact_Telephone], [GP_ID], [Practice_ID], [GP_Code], [Practice_Code], [School_ID], [Contact_ID], [Staff_ID], [Referral_Priority_ID], [Referral_Reason_ID], [Presentation_Reason_ID], [Person_Present_ID], [Consent_Given_ID], [Referrer_Address1], [Referrer_Address2], [Referrer_Address3], [Referrer_Address4], [Referrer_Address5], [Referrer_Post_Code], [Referrer_Telephone], [Referrer_Fax], [Referrer_Email], [Referrer_PCT_Code], [Referrer_PCT_Name], [Referred_To_Service_ID], [Referred_To_Location_ID], [Referral_Format_ID], [Referral_Status_ID], [Referral_Admin_Status_ID], [Referral_Administrative_Category_ID], [Referral_Admin_Priority_ID], [Accepted_Date], [Accepted_By_Staff_ID], [Accepted_By_Staff_Name], [Wait_Weeks], [Open_Weeks], [Accommodation_ID], [Employment_ID], [Rejection_Date], [Rejection_Reason_ID], [Rejection_Detail], [Rejected_By_Staff_ID], [Rejected_By_Staff_Name], [Discharge_Date], [Discharge_Time], [Discharge_Method_Spell_ID], [Discharge_Destination_ID], [Discharge_Agreed_By_Staff_ID], [Discharge_Agreed_By_Staff_Name], [Discharge_Detail], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Referrer_CCG_Code], [Referrer_CCG_Name], [Agency_Staff_Category_ID], [Staff_Professional_Group_ID], [Discharge_Letter_Issued_Date], [Referral_Closure_Reason_ID], [Reason_For_Out_Of_Area_Referral_ID], [Rejection_Time]
						 FROM mrr_tbl.CNS_tblReferral))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblReferral has discrepancies when compared to its source table.', 1;

				END;
				
GO
