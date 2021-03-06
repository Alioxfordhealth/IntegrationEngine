SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblPractice](
	[Practice_ID] [int] NOT NULL,
	[Practice_Code] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Active_ID] [int] NULL,
	[Locally_Managed_ID] [int] NULL,
	[Practice_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[PCT_ID] [int] NULL,
	[Fundholder_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Post_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Telephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Fax] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Email_Address] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Enable_Email_ID] [int] NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[CCG_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
