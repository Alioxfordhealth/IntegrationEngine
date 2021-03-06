SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_EventStockIssued] AS SELECT [EventStockIssuedRef], [IssueDate], [CaseRef], [PrescriptionChargeExemptionStatusRef], [PersonallyAdministered], [ImmediateTreatment], [Obsolete] FROM [Mirror].[mrr_tbl].[ADA_EventStockIssued];

GO
