SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_adaEventTypes](
	[EventType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletionEvent] [bit] NULL,
	[MajorEvent] [bit] NULL
) ON [PRIMARY]

GO
