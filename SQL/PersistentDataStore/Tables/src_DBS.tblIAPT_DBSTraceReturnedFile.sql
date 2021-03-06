SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_DBS].[tblIAPT_DBSTraceReturnedFile](
	[RecordType] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LocalPID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[NoMultipleMatches] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[TraceNHS] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DOB] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[DoD] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OldNHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[NewNHSNumber] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[AltSurname] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Sex] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevAddress5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PrevPostcode] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[GP] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[GPPract] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Match_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
