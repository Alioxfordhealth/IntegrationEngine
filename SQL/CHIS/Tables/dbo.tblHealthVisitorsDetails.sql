SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHealthVisitorsDetails](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HV_Code] [varchar](30) COLLATE Latin1_General_CI_AS NOT NULL,
	[HV_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[HV_Email] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
