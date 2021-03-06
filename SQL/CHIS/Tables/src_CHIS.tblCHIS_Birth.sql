SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [src_CHIS].[tblCHIS_Birth](
	[NHS_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Date_of_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Sex] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Mothers_Forename] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Mothers_Surname] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Mothers_Date_of_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Mothers_NHS_Number] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line_1] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line_2] [varchar](150) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line_3] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Address_Line_4] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Postcode] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Number_Born] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Birth_Order] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Birth_State] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Place_of_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Birth_Weight] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Time_of_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Gestation_in_Weeks] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Congenital_Malformations_at_Birth] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Current_Practice] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Clinical_Commissioning_Group] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
