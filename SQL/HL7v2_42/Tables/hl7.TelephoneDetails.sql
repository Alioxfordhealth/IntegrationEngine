SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [hl7].[TelephoneDetails](
	[MPI_ID] [bigint] NOT NULL,
	[NokContact_ID] [bigint] NULL,
	[Telephone_Number] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[PhoneType] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[UseCode] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[ContactRole] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Main_Number_Flag] [int] NULL
) ON [PRIMARY]

GO
