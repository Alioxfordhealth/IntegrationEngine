SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ORU_SRC].[tblORU_PatientResults](
	[Patient_ID] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Assigning_Authority] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Identifier_Type_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Message_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Message_Date] [varchar](26) COLLATE Latin1_General_CI_AS NULL,
	[Sending_Application] [varchar](180) COLLATE Latin1_General_CI_AS NULL,
	[Sending_Organisation] [varchar](180) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
