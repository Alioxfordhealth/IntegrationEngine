SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_CCH_PatientImmunisation

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_CCH_PatientImmunisation]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ImmunisationPartId], [CentreId], [ImmunisationOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [RemovalReasonId], [Provisional], [ConsultationId], [SuspensionReasonId], [SuspendUntilDate], [ConsultationIdx], [IsScheduledBySystem], [ResumeReasonId], [RequiredNumberOfReminders], [ConsultationRevisionTag]
						 FROM mrr_tbl.CCH_PatientImmunisation
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ImmunisationPartId], [CentreId], [ImmunisationOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [RemovalReasonId], [Provisional], [ConsultationId], [SuspensionReasonId], [SuspendUntilDate], [ConsultationIdx], [IsScheduledBySystem], [ResumeReasonId], [RequiredNumberOfReminders], [ConsultationRevisionTag]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].[dbo].[PatientImmunisation])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ImmunisationPartId], [CentreId], [ImmunisationOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [RemovalReasonId], [Provisional], [ConsultationId], [SuspensionReasonId], [SuspendUntilDate], [ConsultationIdx], [IsScheduledBySystem], [ResumeReasonId], [RequiredNumberOfReminders], [ConsultationRevisionTag]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].[dbo].[PatientImmunisation]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ImmunisationPartId], [CentreId], [ImmunisationOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [RemovalReasonId], [Provisional], [ConsultationId], [SuspensionReasonId], [SuspendUntilDate], [ConsultationIdx], [IsScheduledBySystem], [ResumeReasonId], [RequiredNumberOfReminders], [ConsultationRevisionTag]
						 FROM mrr_tbl.CCH_PatientImmunisation))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.CCH_PatientImmunisation has discrepancies when compared to its source table.', 1;

				END;
				
GO
