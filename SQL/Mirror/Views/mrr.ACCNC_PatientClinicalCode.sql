SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ACCNC_PatientClinicalCode] AS SELECT [PatientId], [EventId], [TemplateSubmissionIdx], [SnomedCode], [SnomedValue], [EventDate], [_idx], [_createdDate], [_expiredDate], [Id], [_version], [EventTypeId], [GroupId], [Numeric], [Unit], [SectionGroupId] FROM [Mirror].[mrr_tbl].[ACCNC_PatientClinicalCode];
GO
