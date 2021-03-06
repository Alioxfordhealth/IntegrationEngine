SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [HIE_CNS].[tblCNS_EIP](
	[EIPID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[PatientID] [varchar](20) COLLATE Latin1_General_CI_AS NOT NULL,
	[TenancyID] [int] NULL,
	[UpdatedDate] [varchar](23) COLLATE Latin1_General_CI_AS NOT NULL,
	[ActiveEIP] [int] NULL,
	[MainContact] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ContactNumber] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[EIPStartDate] [varchar](23) COLLATE Latin1_General_CI_AS NULL,
	[CarePlan] [int] NULL,
	[Deleted] [int] NULL,
	[ContainsInvalidChar] [bit] NULL,
	[LoadID] [int] NULL
) ON [PRIMARY]

GO
