SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblClinicalCommissioningGroup](
	[CCG_ID] [int] NOT NULL,
	[CCG_Identifier] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[CCG_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[National_Grouping_Code] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[High_Level_Health_Geography_Code] [varchar](3) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line1] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line2] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line3] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Town] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[County] [varchar](35) COLLATE Latin1_General_CI_AS NULL,
	[Post_Code] [varchar](8) COLLATE Latin1_General_CI_AS NULL,
	[Open_Date] [datetime] NULL,
	[Close_Date] [datetime] NULL,
	[Status] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Authorisation_Indicator] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Ammendment_Indicator] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Locally_Managed_Flag_ID] [int] NULL,
	[Active_Flag_ID] [int] NULL,
	[Comments] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Organisation_Sub_Type_Code] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Telephone_Number] [varchar](12) COLLATE Latin1_General_CI_AS NULL,
	[CCG_Record_Type_ID] [int] NULL,
	[Organisation_Type_Code] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Country_Code] [varchar](1) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
