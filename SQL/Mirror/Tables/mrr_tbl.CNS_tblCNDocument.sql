SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblCNDocument](
	[CN_Doc_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Referral_ID] [int] NULL,
	[Episode_ID] [int] NULL,
	[CN_Object_ID] [int] NULL,
	[Object_Type_ID] [int] NULL,
	[Icon] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[ViewDate] [datetime] NULL,
	[ViewTime] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[ViewDttm] [datetime] NULL,
	[ViewText] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[ViewForm] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[CNV3_Universal_ID] [varchar](32) COLLATE Latin1_General_CI_AS NULL,
	[Is_Active] [int] NULL,
	[Active_Period_End_Dttm] [datetime] NULL,
	[Current_Indicator] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Service_ID] [int] NULL
) ON [PRIMARY]

GO
