SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AscribePatients_List_20190904](
	[PatID] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[Title] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[Initials] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](128) COLLATE Latin1_General_CI_AS NULL,
	[DOB] [datetime] NULL,
	[CaseNumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[NHSNumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[NHSNumberValid] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[Sex] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[HealthCareNumber] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[HealthCareNumberValid] [bit] NULL,
	[BoxNumber] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[DoorNumber] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Building] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Street] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Town] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LocalAuthority] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[District] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[PostCode] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Province] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Country] [varchar](50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
