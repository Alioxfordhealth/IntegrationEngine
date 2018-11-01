CREATE TABLE [dbo].[tblHL70002MaritalStatus]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (1) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PicklistID] [int] NULL,
[SourceSystem] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TableName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHL70002MaritalStatus] ADD CONSTRAINT [PK__tblHL700__3214EC274089A802] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
