SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_RelationshipToCaller](
	[RelationshipRef] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[ServiceRef] [uniqueidentifier] NULL,
	[Obsolete] [bit] NULL,
	[Usage] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MandatoryContactNo] [bit] NULL
) ON [PRIMARY]

GO
