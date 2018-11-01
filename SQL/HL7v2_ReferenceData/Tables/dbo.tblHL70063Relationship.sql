CREATE TABLE [dbo].[tblHL70063Relationship]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PicklistID] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SourceSystem] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TableName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHL70063Relationship] ADD CONSTRAINT [PK__tblHL700__3214EC2763C3FEE4] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
