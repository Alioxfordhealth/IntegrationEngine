SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_aud].[CCH_ChildHealthRecord](
	[AuditID] [bigint] IDENTITY(1,1) NOT NULL,
	[LoadType] [nvarchar](1) COLLATE Latin1_General_CI_AS NULL,
	[RunByUser] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NOT NULL,
	[Duration]  AS (datediff(millisecond,[StartTime],[EndTime])),
	[Inserted] [int] NULL,
	[Updated] [int] NULL,
	[Deleted] [int] NULL
) ON [PRIMARY]

GO
