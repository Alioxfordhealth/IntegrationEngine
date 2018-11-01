CREATE TABLE [hl7].[NextOfKin]
(
[MPI_ID] [bigint] NOT NULL,
[Forename] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Surname] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Title] [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
[Relationship] [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
[Address1] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Address2] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Address3] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Address4] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Postcode] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
