CREATE TABLE [dbo].[tblHL70202TelecommunicationEquipmentType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PicklistID] [int] NULL,
[SourceSystem] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TableName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHL70202TelecommunicationEquipmentType] ADD CONSTRAINT [PK__tblHL702__3214EC27997BD4ED] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
