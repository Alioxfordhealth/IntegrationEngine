SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_RelationshipToCaller] AS SELECT [RelationshipRef], [Name], [Sort], [ServiceRef], [Obsolete], [Usage], [MandatoryContactNo] FROM [Mirror].[mrr_tbl].[ADA_RelationshipToCaller];

GO
