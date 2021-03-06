SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblMedicine](
	[Medicine_ID] [int] NOT NULL,
	[Generic_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Guidance_Notes] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Active_Flag_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
