SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [CHIS].[tblCHIS_HV_U_Check_Antenatal](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Mother_NHS] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Mother_Forename] [varchar](55) COLLATE Latin1_General_CI_AS NULL,
	[Mother_Surname] [varchar](55) COLLATE Latin1_General_CI_AS NULL,
	[Mother_DOB] [date] NULL,
	[Date_of_contact] [date] NULL,
	[Venue_of_visit] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[Created_Dttm] [datetime] NULL,
	[Sent] [bit] NULL,
	[Sent_Dttm] [datetime2](7) NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
