SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ChildHealthCentre](
	[Idx] [int] NOT NULL,
	[Id] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[Name] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[CarenotesTeamId] [int] NULL,
	[StartSchedulingDate] [datetime] NULL,
	[EndSchedulingDate] [datetime] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[LabCode] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[CarenotesPracticeId] [int] NULL,
	[CarenotesSchoolId] [int] NULL,
	[CarenotesClinicGroupId] [int] NULL,
	[ExcludeFromCarenotesTeamAutoAssign] [bit] NULL,
	[Removed] [bit] NULL
) ON [PRIMARY]

GO
