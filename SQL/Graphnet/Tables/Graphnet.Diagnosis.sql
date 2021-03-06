SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [Graphnet].[Diagnosis](
	[DiagnosisID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[TenancyID] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[LinkID] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[DiagnosisDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[ICD10Code] [varchar](7) COLLATE Latin1_General_CI_AS NULL,
	[SnomedCTCode] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[DiagnosisDescription] [varchar](500) COLLATE Latin1_General_CI_AS NOT NULL,
	[ConfirmedBy] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NOT NULL
) ON [PRIMARY]

GO
