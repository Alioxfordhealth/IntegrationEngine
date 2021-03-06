SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[PCMSBCKS_ReferralDetails](
	[CaseNumber] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PatientID] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateOfOnset] [smalldatetime] NULL,
	[PrimaryProb] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SecondaryProb] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PresentingProb] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrimaryDiagnosis] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SecondaryDiagnosis] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OtherProb] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referrer] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResponsibleCommissioner] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkerName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Profession] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Consent] [bit] NULL,
	[GPCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GPName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Custom1] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Custom2] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Custom3] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EndOfCareDate] [smalldatetime] NULL,
	[ReferralAccepted] [int] NULL,
	[OtherCaseNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceReqAccept] [bit] NULL,
	[PatientConsent2] [bit] NULL,
	[EndOfCareReason] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferredToService] [nvarchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]

GO
