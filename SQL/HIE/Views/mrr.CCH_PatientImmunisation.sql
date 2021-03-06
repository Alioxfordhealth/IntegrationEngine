SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_PatientImmunisation] AS SELECT [Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ImmunisationPartId], [CentreId], [ImmunisationOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [RemovalReasonId], [Provisional], [ConsultationId], [SuspensionReasonId], [SuspendUntilDate], [ConsultationIdx], [IsScheduledBySystem], [ResumeReasonId], [RequiredNumberOfReminders], [ConsultationRevisionTag] FROM [Mirror].[mrr_tbl].[CCH_PatientImmunisation];

GO
