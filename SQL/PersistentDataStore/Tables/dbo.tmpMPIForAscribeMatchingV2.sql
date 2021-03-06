SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tmpMPIForAscribeMatchingV2](
	[NHS_Number] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[ForenameSurname] [varchar](101) COLLATE Latin1_General_CI_AS NULL,
	[ForenameSurnameNoSpace] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Patient_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Date_Of_Birth] [datetime] NULL,
	[Gender_ID] [int] NULL
) ON [PRIMARY]

GO
