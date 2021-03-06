SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblCommissioningPeriod](
	[CommissioningPeriod_ID] [int] NOT NULL,
	[Location_ID] [int] NULL,
	[Commissioner_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
