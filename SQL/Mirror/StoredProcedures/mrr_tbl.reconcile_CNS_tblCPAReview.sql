SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_tblCPAReview

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_tblCPAReview]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
						 FROM mrr_tbl.CNS_tblCPAReview
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAReview])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPAReview]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CPA_Review_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_Status_ID], [Plan_Month_ID], [Plan_Year_ID], [CPA_Review_Type_ID], [Sch_For_Staff_ID], [Sch_Date], [Sch_Start_Time], [Sch_End_Time], [Sch_Location_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Act_Date], [Act_Start_Time], [Act_End_Time], [Act_Location_ID], [Act_Attended_By_Staff_ID], [Client_Given_Plan_ID], [Care_Plan_Reviewed_ID], [Risk_Assessment_Completed_ID], [HoNOS_Completed_ID], [Section_117_Status_Reviewed_ID], [Social_Worker_Involved_ID], [Child_Assessment_Requested_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [Level_Change_ID], [New_Level_ID], [Care_Coord_Change_ID], [Next_Meeting_Date], [Next_Step_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [Moved_To_Accepted_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Accommodation_Status_Date], [Employment_Status_Date], [Abuse_Question_Asked_ID], [Attendance_Type_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Smoking_Status_ID], [Patient_Proxy_Attended_ID], [Patient_Proxy_Invited_ID], [Earliest_Reasonable_Offer_Date], [Earliest_Clinically_Appropriate_Date], [Replacement_Appointment_Date_Offered], [Replacement_Appointment_Booked_Date], [EROD_Override_Reason_ID]
						 FROM mrr_tbl.CNS_tblCPAReview))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_tblCPAReview has discrepancies when compared to its source table.', 1;

				END;
				
GO
