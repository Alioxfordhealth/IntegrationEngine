SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ExtractTracker](
	[ExtractID] [bigint] IDENTITY(1,1) NOT NULL,
	[SourceSystem] [nvarchar](3) COLLATE Latin1_General_CI_AS NOT NULL,
	[LastExtracted] [datetime] NULL,
	[RolledBackToOn] [datetime] NULL
) ON [PRIMARY]

GO
