SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblRefODS_Consultants](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[GMCCode] [varchar](7) COLLATE Latin1_General_CI_AS NULL,
	[PractitionerCode] [varchar](8) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Initials] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Sex] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[SpecialityFunctionCode] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[PractitionerType] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[LocationOrganisationCode] [varchar](3) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
