SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ACCNC_Template] AS SELECT [Title], [Description], [Definition], [IsActive], [_idx], [_createdDate], [_expiredDate], [Id], [_version], [TemplateVersion] FROM [Mirror].[mrr_tbl].[ACCNC_Template];
GO
