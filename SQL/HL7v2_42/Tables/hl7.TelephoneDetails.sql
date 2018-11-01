CREATE TABLE [hl7].[TelephoneDetails]
(
[MPI_ID] [bigint] NOT NULL,
[HomeTelephone] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PhoneType] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[UseCode] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ContactRole] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
