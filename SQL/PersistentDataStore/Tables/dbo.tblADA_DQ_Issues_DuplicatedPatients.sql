SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tblADA_DQ_Issues_DuplicatedPatients](
	[Matching_ID] [varchar](42) COLLATE Latin1_General_CI_AS NULL,
	[Patient_ID1] [uniqueidentifier] NULL,
	[Patient_ID2] [uniqueidentifier] NOT NULL,
	[P1_NHS_Number] [varchar](15) COLLATE Latin1_General_CI_AS NULL,
	[P2_NHS_Number] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](8000) COLLATE Latin1_General_CI_AS NULL,
	[P1_Practice] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[HomePhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[MobilePhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[OtherPhone_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[Address_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[PostCode_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL,
	[Practice_Matching] [varchar](8) COLLATE Latin1_General_CI_AS NOT NULL
) ON [PRIMARY]

GO
