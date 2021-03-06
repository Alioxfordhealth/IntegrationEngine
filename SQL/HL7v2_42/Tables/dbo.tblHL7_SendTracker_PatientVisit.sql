SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_SendTracker_PatientVisit](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[PV_ID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[SendResult] [varchar](250) COLLATE Latin1_General_CI_AS NULL,
	[SendDttm] [datetime] NULL
) ON [PRIMARY]

GO
