SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[ADA_adaEventTypes] AS SELECT [EventType], [Description], [CompletionEvent], [MajorEvent] FROM [Mirror].[mrr_tbl].[ADA_adaEventTypes];
GO
