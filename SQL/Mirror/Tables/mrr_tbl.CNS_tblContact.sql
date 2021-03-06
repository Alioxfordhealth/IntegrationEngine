SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblContact](
	[Contact_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Contact_Type_ID] [int] NULL,
	[Primary_Contact_ID] [int] NULL,
	[Permission_To_Contact_ID] [int] NULL,
	[No_Divulge_ID] [int] NULL,
	[Additional_Information_ID] [int] NULL,
	[Contact_Name] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Title_ID] [int] NULL,
	[Forename] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Middlename] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Salutation] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address1] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address2] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address3] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address4] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Address5] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Post_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Contact_DOB] [datetime] NULL,
	[Preferred_Method_Of_Contact_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[Relationship] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Gender_ID] [int] NULL,
	[First_Language_ID] [int] NULL,
	[Interpreter_ID] [int] NULL,
	[Home_Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Home_Telephone_Confidential_ID] [int] NULL,
	[Mobile_Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Mobile_Telephone_Confidential_ID] [int] NULL,
	[Work_Telephone] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Work_Telephone_Confidential_ID] [int] NULL,
	[Email_Address] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Contact_NHS_Num] [varchar](11) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Ethnicity_ID] [int] NULL,
	[Contact_Other_Ref] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Soc_Serv_Ref] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Contact_NINumber] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Registered_GP_ID] [int] NULL,
	[Refugee_Stateless_Person_ID] [int] NULL,
	[Contact_Date_Of_Death] [datetime] NULL,
	[Permission_To_Contact_GP_ID] [int] NULL,
	[School] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[School_Admin_Contact] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[School_Contact] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[School_Head_Teacher] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[School_Telephone] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[School_Fax] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Further_Information] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[Permission_To_Contact_School_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Family_Parental_Responsibility_ID] [int] NULL,
	[Family_Legal_Status_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
