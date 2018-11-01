CREATE TABLE [dbo].[tblHL70201TelecommunicationUseCode]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Code] [varchar] (4) COLLATE Latin1_General_CI_AS NULL,
[Description] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PicklistID] [int] NULL,
[SourceSystem] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[TableName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblHL70201TelecommunicationUseCode] ADD CONSTRAINT [PK__tblHL702__3214EC2707F9ADEC] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
