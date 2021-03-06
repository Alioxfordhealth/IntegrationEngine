SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[PCMSOXON_CasesAll](
	[CaseNumber] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferralDate] [smalldatetime] NULL,
	[CreateDate] [smalldatetime] NULL,
	[WorkerName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseStatus] [int] NULL,
	[LocationCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CaseType] [int] NULL,
	[CurrentlyPaused] [bit] NULL,
	[PauseID] [int] NULL,
	[LastReassignedDate] [smalldatetime] NULL,
	[PathwayID] [int] NULL
) ON [PRIMARY]

GO
