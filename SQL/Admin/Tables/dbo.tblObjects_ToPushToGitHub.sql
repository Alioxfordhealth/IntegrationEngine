SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblObjects_ToPushToGitHub](
	[Database] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[Schema] [varchar](50) COLLATE Latin1_General_CI_AS NOT NULL,
	[ObjectName] [varchar](150) COLLATE Latin1_General_CI_AS NOT NULL,
	[ObjectID] [varchar](150) COLLATE Latin1_General_CI_AS NOT NULL,
	[ObjectType] [varchar](150) COLLATE Latin1_General_CI_AS NOT NULL,
	[CreateDttm] [datetime] NULL,
	[ModifiedDttm] [datetime] NULL
) ON [PRIMARY]
 
GO
