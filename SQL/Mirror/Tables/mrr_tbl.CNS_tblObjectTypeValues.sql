SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblObjectTypeValues](
	[Object_Type_ID] [int] NOT NULL,
	[Object_Type_Desc] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Object_Type_GUID] [uniqueidentifier] NULL,
	[Form_Title] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Allow_Instances] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Tab_ID] [int] NULL,
	[Show_On_Summary_Tab_ID] [int] NULL,
	[Quick_Create_Link_ID] [int] NULL,
	[Virtual_Parent_Document_ID] [int] NULL,
	[Default_Icon] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Assembly_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Data_Class_Namespace] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Data_Class_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Form_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Key_Table_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Key_Field_Name] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Default_View_Form] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Auto_Close_Permitted_Flag_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL
) ON [PRIMARY]

GO
