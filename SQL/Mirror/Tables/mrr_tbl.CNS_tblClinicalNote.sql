SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblClinicalNote](
	[Clinical_Note_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Author_Staff_ID] [int] NULL,
	[Clinical_Note_Category_ID] [int] NULL,
	[Clinical_Note_Type_ID] [int] NULL,
	[Clinical_Note_Date] [datetime] NULL,
	[Clinical_Note_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Entry_Date] [datetime] NULL,
	[Entry_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Clinical_Note_Summary] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Clinical_Note_Text] [text] COLLATE Latin1_General_CI_AS NULL,
	[Confirm_Flag_ID] [int] NULL,
	[Confirm_Staff_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Confirm_Staff_Job_Title] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Confirm_Date] [datetime] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Clinical_Note_Text_HTML] [varchar](max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
