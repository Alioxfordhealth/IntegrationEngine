SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_OUH].[tblOUH_AntenatalPathway](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PersonNameFirst] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PersonNameLast] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DateOfBirth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[EDD] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PublicHealthAssessmentScore] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[GPPracticeCode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OrganisationName] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime2](7) NULL
) ON [PRIMARY]

GO
