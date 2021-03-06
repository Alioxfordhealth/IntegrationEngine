SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CCH_ImmunisationOutcome](
	[Id] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[ExpiredDateTime] [datetime] NULL,
	[CareNotesUserId] [int] NULL,
	[ChildHealthClientVersion] [nvarchar](32) COLLATE Latin1_General_CI_AS NULL,
	[Description] [nvarchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ImmunisationOutcomeType] [int] NULL,
	[ConsultationTemplateType] [int] NULL,
	[SuspensionType] [int] NULL,
	[Code] [nvarchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DoNotReschedule] [bit] NULL,
	[ClinicOutcome] [int] NULL,
	[ClinicNextStep] [int] NULL
) ON [PRIMARY]

GO
