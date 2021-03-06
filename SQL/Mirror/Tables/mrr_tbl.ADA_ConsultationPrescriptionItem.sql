SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[ADA_ConsultationPrescriptionItem](
	[PrescriptionItemRef] [uniqueidentifier] NOT NULL,
	[ConsultationRef] [uniqueidentifier] NULL,
	[ProdID] [int] NULL,
	[FormID] [smallint] NULL,
	[DrugName] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Preparation] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Dosage] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Qty] [decimal](9, 2) NULL,
	[Sort] [int] NULL,
	[ItemType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClinicalCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Strength] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScriptIssueType] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StockItemRef] [uniqueidentifier] NULL,
	[CodedDirections] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PrescriptionNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NationalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FromFormulary] [bit] NULL,
	[OverrideDosage] [bit] NULL,
	[CourseDurationWarning] [bit] NULL,
	[Comments] [varchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UnitOfMeasureCode] [bigint] NULL,
	[SLSEndorsement] [bit] NULL,
	[ACBSEndorsement] [bit] NULL,
	[CDEndorsement] [bit] NULL,
	[ContraceptiveEndorsement] [bit] NULL,
	[WordsAndFiguresRequired] [bit] NULL,
	[ControlStatus] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ControlledScheduleNumber] [int] NULL
) ON [PRIMARY]

GO
