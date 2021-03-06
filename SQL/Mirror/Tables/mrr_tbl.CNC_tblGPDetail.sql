SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblGPDetail](
	[GP_Detail_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Permission_To_Contact_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[GP_ID] [int] NULL,
	[Practice_ID] [int] NULL,
	[Contact_GP_ID] [int] NULL,
	[Further_Information] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[CCG_ID] [int] NULL,
	[Assumed_GP_ID] [int] NULL,
	[PDS_ID] [varchar](14) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
