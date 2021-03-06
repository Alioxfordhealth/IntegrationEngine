SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNC_udfCYPHVMaternalAntenatalAssessmentV2

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNC_udfCYPHVMaternalAntenatalAssessmentV2]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CYPHVMaternalAntenatalAssessmentV2_ID], [Patient_ID], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [StartDate], [fldHvMatAnAsmtEstDueDate], [fldHvMatAnAsmtAsmtScoreID], [fldHvMatAnAsmtLetterSentID], [fldHvMatAnAsmtPrgncyOngoingID], [fldHvMatAnAsmtAnVstAchievedID], [fldHvMatAnAsmtAnVstAchievedTextID], [fldHvMatAnAsmtFeedingID], [fldHvMatAnAsmtRoutineQuestID], [fldHvMatAnAsmtRoutineQuestTextID], [fldHvMatAnAsmtPromGuidesID], [fldHvMatAnAsmtIntervReqID], [fldHvMatAnAsmtIntervReqHomelessID], [fldHvMatAnAsmtIntervReqMHConcernsID], [fldHvMatAnAsmtIntervReqAddictionsID], [fldHvMatAnAsmtIntervReqTeenagePregID], [fldHvMatAnAsmtIntervReqHistOfSfgConcID], [fldHvMatAnAsmtIntervReqCurrentSfgConcID], [fldHvMatAnAsmtIntervReqPhysicalDisabilityID], [fldHvMatAnAsmtIntervReqTravelFamID], [fldHvMatAnAsmtIntervReqAsylumID], [fldHvMatAnAsmtHlthyChildID], [fldHvMatAnAsmtFurtherVstReqID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
						 FROM mrr_tbl.CNC_udfCYPHVMaternalAntenatalAssessmentV2
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CYPHVMaternalAntenatalAssessmentV2_ID], [Patient_ID], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [StartDate], [fldHvMatAnAsmtEstDueDate], [fldHvMatAnAsmtAsmtScoreID], [fldHvMatAnAsmtLetterSentID], [fldHvMatAnAsmtPrgncyOngoingID], [fldHvMatAnAsmtAnVstAchievedID], [fldHvMatAnAsmtAnVstAchievedTextID], [fldHvMatAnAsmtFeedingID], [fldHvMatAnAsmtRoutineQuestID], [fldHvMatAnAsmtRoutineQuestTextID], [fldHvMatAnAsmtPromGuidesID], [fldHvMatAnAsmtIntervReqID], [fldHvMatAnAsmtIntervReqHomelessID], [fldHvMatAnAsmtIntervReqMHConcernsID], [fldHvMatAnAsmtIntervReqAddictionsID], [fldHvMatAnAsmtIntervReqTeenagePregID], [fldHvMatAnAsmtIntervReqHistOfSfgConcID], [fldHvMatAnAsmtIntervReqCurrentSfgConcID], [fldHvMatAnAsmtIntervReqPhysicalDisabilityID], [fldHvMatAnAsmtIntervReqTravelFamID], [fldHvMatAnAsmtIntervReqAsylumID], [fldHvMatAnAsmtHlthyChildID], [fldHvMatAnAsmtFurtherVstReqID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[udfCYPHVMaternalAntenatalAssessmentV2])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CYPHVMaternalAntenatalAssessmentV2_ID], [Patient_ID], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [StartDate], [fldHvMatAnAsmtEstDueDate], [fldHvMatAnAsmtAsmtScoreID], [fldHvMatAnAsmtLetterSentID], [fldHvMatAnAsmtPrgncyOngoingID], [fldHvMatAnAsmtAnVstAchievedID], [fldHvMatAnAsmtAnVstAchievedTextID], [fldHvMatAnAsmtFeedingID], [fldHvMatAnAsmtRoutineQuestID], [fldHvMatAnAsmtRoutineQuestTextID], [fldHvMatAnAsmtPromGuidesID], [fldHvMatAnAsmtIntervReqID], [fldHvMatAnAsmtIntervReqHomelessID], [fldHvMatAnAsmtIntervReqMHConcernsID], [fldHvMatAnAsmtIntervReqAddictionsID], [fldHvMatAnAsmtIntervReqTeenagePregID], [fldHvMatAnAsmtIntervReqHistOfSfgConcID], [fldHvMatAnAsmtIntervReqCurrentSfgConcID], [fldHvMatAnAsmtIntervReqPhysicalDisabilityID], [fldHvMatAnAsmtIntervReqTravelFamID], [fldHvMatAnAsmtIntervReqAsylumID], [fldHvMatAnAsmtHlthyChildID], [fldHvMatAnAsmtFurtherVstReqID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[udfCYPHVMaternalAntenatalAssessmentV2]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CYPHVMaternalAntenatalAssessmentV2_ID], [Patient_ID], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [StartDate], [fldHvMatAnAsmtEstDueDate], [fldHvMatAnAsmtAsmtScoreID], [fldHvMatAnAsmtLetterSentID], [fldHvMatAnAsmtPrgncyOngoingID], [fldHvMatAnAsmtAnVstAchievedID], [fldHvMatAnAsmtAnVstAchievedTextID], [fldHvMatAnAsmtFeedingID], [fldHvMatAnAsmtRoutineQuestID], [fldHvMatAnAsmtRoutineQuestTextID], [fldHvMatAnAsmtPromGuidesID], [fldHvMatAnAsmtIntervReqID], [fldHvMatAnAsmtIntervReqHomelessID], [fldHvMatAnAsmtIntervReqMHConcernsID], [fldHvMatAnAsmtIntervReqAddictionsID], [fldHvMatAnAsmtIntervReqTeenagePregID], [fldHvMatAnAsmtIntervReqHistOfSfgConcID], [fldHvMatAnAsmtIntervReqCurrentSfgConcID], [fldHvMatAnAsmtIntervReqPhysicalDisabilityID], [fldHvMatAnAsmtIntervReqTravelFamID], [fldHvMatAnAsmtIntervReqAsylumID], [fldHvMatAnAsmtHlthyChildID], [fldHvMatAnAsmtFurtherVstReqID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
						 FROM mrr_tbl.CNC_udfCYPHVMaternalAntenatalAssessmentV2))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNC_udfCYPHVMaternalAntenatalAssessmentV2 has discrepancies when compared to its source table.', 1;

				END;
				
GO
