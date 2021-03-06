SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_Casetype](
	[CaseTypeRef] [uniqueidentifier] NOT NULL,
	[ServiceRef] [uniqueidentifier] NULL,
	[Name] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Abbreviation] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[V2Import] [bit] NULL,
	[Obsolete] [bit] NULL,
	[Usage] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalCode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Colour] [int] NULL
) ON [PRIMARY]

GO
