SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ACCNC_TemplateSubmission] AS SELECT [PatientId], [TemplateId], [TemplateIdx], [EventTypeId], [EventDate], [Obsolete], [Numeric], [Text], [Date], [DateTime], [Time], [Checkbox], [Combobox], [Radio], [BloodPressure], [Bmi], [BmiInfant], [Administration], [_idx], [_createdDate], [_expiredDate], [Id], [_version], [RevisionTag] FROM [Mirror].[mrr_tbl].[ACCNC_TemplateSubmission];
GO
