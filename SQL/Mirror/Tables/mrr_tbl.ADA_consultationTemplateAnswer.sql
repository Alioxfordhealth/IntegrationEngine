SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_consultationTemplateAnswer](
	[ConsultationTemplateAnswerRef] [uniqueidentifier] NOT NULL,
	[Ref] [uniqueidentifier] NULL,
	[CaseRef] [uniqueidentifier] NULL,
	[PatientRef] [uniqueidentifier] NULL,
	[QuestionRef] [uniqueidentifier] NULL,
	[Code] [varchar](15) COLLATE SQL_Latin1_General_CP1_CS_AS NULL,
	[EntryDate] [datetime] NULL,
	[AnswerText] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AnswerValue] [decimal](10, 4) NULL,
	[AnswerDate] [datetime] NULL,
	[ServiceRef] [uniqueidentifier] NULL,
	[TemplateRef] [uniqueidentifier] NULL,
	[Obsolete] [bit] NULL,
	[EventRef] [uniqueidentifier] NULL,
	[SecondaryCode] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
