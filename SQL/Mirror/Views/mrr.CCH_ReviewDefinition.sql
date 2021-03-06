SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CCH_ReviewDefinition] AS SELECT [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [ShortName], [LongName], [ReviewType], [CarriedOutConsultationTemplateId], [NotCarriedOutConsultationTemplateId], [WarnIfMultipleInstances], [CohortId], [CoreProgramme], [IgnoreTreatmentStatus], [DaysScheduledInAdvance], [Code], [IsOutcomedByOptional], [IsTeamLocationOptional], [ForceOutcomeToId], [CyphsCode] FROM [Mirror].[mrr_tbl].[CCH_ReviewDefinition];
GO
