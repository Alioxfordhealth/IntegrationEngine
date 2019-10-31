SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_config].[SourceTargetMap](
	[SourceTableFullName] [nvarchar](512) COLLATE Latin1_General_CI_AS NOT NULL,
	[TargetTable] [nvarchar](128) COLLATE Latin1_General_CI_AS NOT NULL,
	[LastBuiltOn] [datetime2](7) NULL
) ON [PRIMARY]

GO
