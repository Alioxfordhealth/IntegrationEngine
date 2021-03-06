SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_CaseEvents](
	[EventRef] [uniqueidentifier] NOT NULL,
	[CaseRef] [uniqueidentifier] NULL,
	[EventType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntryDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Summary] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ref] [uniqueidentifier] NULL,
	[UserComments] [varchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserRef] [uniqueidentifier] NULL,
	[UserDescription] [varchar](48) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SyncRequired] [bit] NULL,
	[EventDescription] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MasterEventRef] [uniqueidentifier] NULL,
	[CaseStatus] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Obsolete] [bit] NULL,
	[ObsoleteByRef] [uniqueidentifier] NULL,
	[ObsoleteByDescription] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObsoleteDate] [datetime] NULL,
	[ObsoleteMasterEventRef] [uniqueidentifier] NULL,
	[CreationDate] [datetime] NULL,
	[LocationRef] [uniqueidentifier] NULL,
	[Editable] [bit] NULL,
	[CaseAuditRef] [uniqueidentifier] NULL,
	[BeforeCaseAuditRef] [uniqueidentifier] NULL,
	[AremoteDeviceRef] [uniqueidentifier] NULL,
	[SessionRef] [uniqueidentifier] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
