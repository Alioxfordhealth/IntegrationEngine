SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL7_SendTracker_InterimDischargeSummary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[IntegratedDocumentID] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[FailureReason] [varchar](2000) COLLATE Latin1_General_CI_AS NULL,
	[SendDttm] [datetime] NULL,
	[TargetSystemID] [varchar](50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
