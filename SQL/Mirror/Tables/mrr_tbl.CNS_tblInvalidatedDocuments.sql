SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblInvalidatedDocuments](
	[CN_Doc_ID] [int] NOT NULL,
	[Set_Invalid_By_ID] [int] NULL,
	[Set_Invalid_Date] [datetime] NULL,
	[Invalid_Reason_ID] [int] NULL,
	[Invalid_Description] [text] COLLATE Latin1_General_CI_AS NULL,
	[User_Created] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
