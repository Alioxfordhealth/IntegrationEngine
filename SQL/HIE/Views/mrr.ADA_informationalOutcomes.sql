SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_informationalOutcomes] AS SELECT [InformationalOutcomeRef], [ParentRef], [ServiceRef], [Name], [Sort], [V2Import], [Obsolete], [Usage], [Selectable], [MandatoryComments] FROM [Mirror].[mrr_tbl].[ADA_informationalOutcomes];

GO
