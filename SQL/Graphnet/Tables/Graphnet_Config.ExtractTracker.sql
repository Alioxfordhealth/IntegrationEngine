SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [Graphnet_Config].[ExtractTracker](
	[ExtractID] [bigint] IDENTITY(1,1) NOT NULL,
	[LastExtracted] [datetime] NULL,
	[RolledBackToOn] [datetime] NULL
) ON [PRIMARY]

GO
