SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CCH_ChildHealthRecord] AS SELECT [Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ImmunisationCentreId], [ExaminationCentreId], [CarenotesPatientId], [LookedAfterChildrenStatusConsultationId], [RegisterMessageSent] FROM [Mirror].[mrr_tbl].[CCH_ChildHealthRecord];

GO
