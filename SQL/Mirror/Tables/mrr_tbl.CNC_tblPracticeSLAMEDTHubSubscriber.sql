SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblPracticeSLAMEDTHubSubscriber](
	[Practice_SLAM_EDT_Hub_Subscriber_ID] [int] NOT NULL,
	[Practice_ID] [int] NULL,
	[Enable_EDT_Hub_ID] [int] NULL,
	[User_Created] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
