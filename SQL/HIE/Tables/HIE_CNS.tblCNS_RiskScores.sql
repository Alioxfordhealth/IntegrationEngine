SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNS].[tblCNS_RiskScores](
	[RiskScoreID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[RiskAssessmentID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[RiskDescription] [varchar](max) COLLATE Latin1_General_CI_AS NOT NULL,
	[RiskStatus] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL,
	[Order] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
