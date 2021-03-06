SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblAttachment](
	[Attachment_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Doc_Author_Staff_ID] [int] NULL,
	[Doc_Date] [datetime] NULL,
	[General_Document_Category_ID] [int] NULL,
	[Doc_Title] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Attachment_Status_ID] [int] NULL,
	[Attachment_Status_By_Staff_ID] [int] NULL,
	[Attachment_Status_Date] [datetime] NULL,
	[Version_Group] [int] NULL,
	[Version_Number] [int] NULL,
	[On_Behalf_Of_Staff_ID] [int] NULL,
	[User_Created] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Object_Type_ID] [int] NULL,
	[Comments] [varchar](max) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
