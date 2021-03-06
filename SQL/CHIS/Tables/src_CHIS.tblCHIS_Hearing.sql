SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_CHIS].[tblCHIS_Hearing](
	[NHS_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_of_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Examination_Date] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OutcomeCode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_Screening_Outcome_Set] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
