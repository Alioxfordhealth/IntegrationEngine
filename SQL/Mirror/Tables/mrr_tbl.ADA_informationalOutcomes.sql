SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_informationalOutcomes](
	[InformationalOutcomeRef] [uniqueidentifier] NOT NULL,
	[ParentRef] [uniqueidentifier] NULL,
	[ServiceRef] [uniqueidentifier] NULL,
	[Name] [varchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[V2Import] [bit] NULL,
	[Obsolete] [bit] NULL,
	[Usage] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Selectable] [bit] NULL,
	[MandatoryComments] [bit] NULL
) ON [PRIMARY]

GO
