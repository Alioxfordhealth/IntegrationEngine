SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblOH_MPI_NextOfKin](
	[MPI_ID] [bigint] NOT NULL,
	[Contact_ID] [bigint] NULL,
	[Forename] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Title] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Gender] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[PrimaryLanguage] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Relationship] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Relationship_HL7] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
