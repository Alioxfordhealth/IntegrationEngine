SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_clinicalCodeHotlist](
	[ExaminationCategoryRef] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [varchar](15) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
	[Description] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Usage] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sort] [int] NULL,
	[CodingSystem] [int] NULL
) ON [PRIMARY]

GO
