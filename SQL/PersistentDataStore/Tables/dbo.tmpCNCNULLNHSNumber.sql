SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tmpCNCNULLNHSNumber](
	[Patient_ID] [int] NOT NULL,
	[Forename] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[Surname] [varchar](8000) COLLATE Latin1_General_CI_AS NOT NULL,
	[Patient_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Title_ID] [int] NULL,
	[Date_Of_Birth] [datetime] NULL,
	[NHS_Number] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[Gender_ID] [int] NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](512) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[AddressType] [int] NULL,
	[Date_Of_Death] [datetime] NULL,
	[PracticeName] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PracticeCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GPCode] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GPName] [varchar](201) COLLATE Latin1_General_CI_AS NULL,
	[GPPrefix] [int] NULL,
	[PrimaryLanguage] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[MaritalStatus] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[EthnicGroup] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Religion] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
