SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CNS_udfMHAssessmentV9

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CNS_udfMHAssessmentV9]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldSafeguardingStatusID], [fldDependentsID], [fldManagingNutritionID], [fldPersonalHygieneID], [fldToiletNeedsID], [fldAppropriateClothID], [fldAdultsHomeID], [fldHomeEnvironmentID], [fldOtherPersonalRelationshipsID], [fldAccessAndEngageID], [fldFacilitiesOrServicesID], [fldCaringResponsibilitiesID], [fldPsychoTherapiesNeededID], [fldAnnualHealthCheckID], [fldHospActionPlanID], [fldHospPassportID], [fldEyeTestID], [fldDentalCheckUpID], [fldHealthScreeningID], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldCurrentlyPregnantID], [fldDueDate], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldMedChangesID], [fldGPActionsID], [fldClinicalReviewID], [fldAdditionalPlansID], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
						 FROM mrr_tbl.CNS_udfMHAssessmentV9
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldSafeguardingStatusID], [fldDependentsID], [fldManagingNutritionID], [fldPersonalHygieneID], [fldToiletNeedsID], [fldAppropriateClothID], [fldAdultsHomeID], [fldHomeEnvironmentID], [fldOtherPersonalRelationshipsID], [fldAccessAndEngageID], [fldFacilitiesOrServicesID], [fldCaringResponsibilitiesID], [fldPsychoTherapiesNeededID], [fldAnnualHealthCheckID], [fldHospActionPlanID], [fldHospPassportID], [fldEyeTestID], [fldDentalCheckUpID], [fldHealthScreeningID], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldCurrentlyPregnantID], [fldDueDate], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldMedChangesID], [fldGPActionsID], [fldClinicalReviewID], [fldAdditionalPlansID], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHAssessmentV9])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldSafeguardingStatusID], [fldDependentsID], [fldManagingNutritionID], [fldPersonalHygieneID], [fldToiletNeedsID], [fldAppropriateClothID], [fldAdultsHomeID], [fldHomeEnvironmentID], [fldOtherPersonalRelationshipsID], [fldAccessAndEngageID], [fldFacilitiesOrServicesID], [fldCaringResponsibilitiesID], [fldPsychoTherapiesNeededID], [fldAnnualHealthCheckID], [fldHospActionPlanID], [fldHospPassportID], [fldEyeTestID], [fldDentalCheckUpID], [fldHealthScreeningID], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldCurrentlyPregnantID], [fldDueDate], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldMedChangesID], [fldGPActionsID], [fldClinicalReviewID], [fldAdditionalPlansID], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHAssessmentV9]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[MHAssessmentV9_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldServiceSettingID], [fldSafeguardingStatusID], [fldDependentsID], [fldManagingNutritionID], [fldPersonalHygieneID], [fldToiletNeedsID], [fldAppropriateClothID], [fldAdultsHomeID], [fldHomeEnvironmentID], [fldOtherPersonalRelationshipsID], [fldAccessAndEngageID], [fldFacilitiesOrServicesID], [fldCaringResponsibilitiesID], [fldPsychoTherapiesNeededID], [fldAnnualHealthCheckID], [fldHospActionPlanID], [fldHospPassportID], [fldEyeTestID], [fldDentalCheckUpID], [fldHealthScreeningID], [fldEpilepsyID], [fldChkPhysicalHealthID], [fldChkMentalHealthID], [fldChkForensicsID], [fldChkEpilepsyID], [fldChkChallengingBehaviourID], [fldChkDementiaID], [fldChkAutismID], [fldCurrentlyPregnantID], [fldDueDate], [fldChkPresentingID], [fldChkEstrangementID], [fldChkSuddenID], [fldChkPreviousID], [fldChkViolentID], [fldChkHarmID], [fldMedChangesID], [fldGPActionsID], [fldClinicalReviewID], [fldAdditionalPlansID], [fldContactedByResearchID], [fldAssessmentLetterID], [fldReceiveCopyID], [flgChkReplanned], [flgChkSaved], [flgExistingForm], [flgValidParent], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldChkAbsconsionID]
						 FROM mrr_tbl.CNS_udfMHAssessmentV9))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CNS_udfMHAssessmentV9 has discrepancies when compared to its source table.', 1;

				END;
				
GO
