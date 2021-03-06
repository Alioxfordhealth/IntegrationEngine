SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblClientLink](
	[Client_Link_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[Start_Authorised_By_Staff_ID] [int] NULL,
	[Relationship_ID] [int] NULL,
	[Linked_Patient_ID] [int] NULL,
	[Reciprocal_Client_Link_ID] [int] NULL,
	[Review_Date] [datetime] NULL,
	[Responsibility_Of_Staff_ID] [int] NULL,
	[End_Date] [datetime] NULL,
	[End_Authorised_By_Staff_ID] [int] NULL,
	[Comment] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Family_Parental_Responsibility_ID] [int] NULL,
	[Family_Legal_Status_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
