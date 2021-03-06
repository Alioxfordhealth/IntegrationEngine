SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ACCNC_Template](
	[Title] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Definition] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[IsActive] [bit] NULL,
	[_idx] [int] NOT NULL,
	[_createdDate] [datetime2](7) NOT NULL,
	[_expiredDate] [datetime2](7) NULL,
	[Id] [uniqueidentifier] NULL,
	[_version] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[TemplateVersion] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
