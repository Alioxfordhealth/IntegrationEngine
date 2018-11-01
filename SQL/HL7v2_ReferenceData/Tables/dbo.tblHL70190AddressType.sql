CREATE TABLE [dbo].[tblHL70190AddressType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (4) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PicklistID] [int] NULL,
[SourceSystem] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TableName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHL70190AddressType] ADD CONSTRAINT [PK__tblHL701__3214EC27795FB2A3] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
