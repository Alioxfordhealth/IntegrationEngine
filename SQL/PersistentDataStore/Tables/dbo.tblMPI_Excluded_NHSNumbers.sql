SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblMPI_Excluded_NHSNumbers](
	[NHSNumber] [varchar](10) COLLATE Latin1_General_CI_AS NOT NULL,
	[ExclusionReason] [varchar](1000) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
