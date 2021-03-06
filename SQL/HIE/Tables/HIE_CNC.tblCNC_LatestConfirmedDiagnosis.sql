SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_LatestConfirmedDiagnosis](
	[DiagnosisID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[DiagnosisDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[DiagnosisDescription] [varchar](500) COLLATE Latin1_General_CI_AS NOT NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NOT NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
