SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ImmunisationDefinition](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[ShortName] [nvarchar](50) COLLATE Latin1_General_CI_AS NULL,
	[LongName] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Parts] [int] NULL,
	[Priority] [bit] NULL,
	[CoreProgramme] [bit] NULL,
	[IgnoreTreatmentStatus] [bit] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[GpiusCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
