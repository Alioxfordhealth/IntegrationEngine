SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblEventTypeOfContactValues](
	[Event_Type_Of_Contact_ID] [int] NOT NULL,
	[Event_Type_Of_Contact_Desc] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Active] [int] NULL,
	[Default_Flag] [int] NULL,
	[External_Code1] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[External_Code2] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Display_Order] [int] NULL,
	[Auto_Start_Episode_ID] [int] NULL,
	[User_Created] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[MHSDS_Relevant_Event_ID] [int] NULL
) ON [PRIMARY]

GO
