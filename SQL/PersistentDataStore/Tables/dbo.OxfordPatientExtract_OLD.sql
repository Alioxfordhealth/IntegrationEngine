SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OxfordPatientExtract_OLD](
	[PatientName] [nvarchar](150) COLLATE Latin1_General_CI_AS NULL,
	[EMISNHSNumber] [float] NULL,
	[PASNHSNumber] [nvarchar](1) COLLATE Latin1_General_CI_AS NULL,
	[EMISCaseNumber] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PASCaseNumber] [nvarchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DateofBirth] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[comments] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[FinalEMISNHSNumber] [varchar](10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
