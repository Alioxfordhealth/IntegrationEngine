SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNC].[tblCNC_Alerts](
	[PatientNo] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[AlertOrder] [int] NOT NULL,
	[AlertCategory] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[AlertType] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[AlertTypeDescription] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[AlertSubType] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[AlertSubTypeDescription] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Severity] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [varchar](1000) COLLATE Latin1_General_CI_AS NULL,
	[StartDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[EndDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
