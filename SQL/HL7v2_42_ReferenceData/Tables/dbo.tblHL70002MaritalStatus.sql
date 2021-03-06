SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblHL70002MaritalStatus](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Description] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[PicklistID] [int] NULL,
	[SourceSystem] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[TableName] [varchar](100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]

GO
