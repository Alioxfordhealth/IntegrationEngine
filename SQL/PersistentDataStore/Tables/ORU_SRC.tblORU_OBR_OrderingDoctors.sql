SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ORU_SRC].[tblORU_OBR_OrderingDoctors](
	[Message_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OBR_ID] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Doctor_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Family_Name] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Given_Name] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Other_Given_Names] [varchar](30) COLLATE Latin1_General_CI_AS NULL,
	[Suffix] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Prefix] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Degree] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Source_Table] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Assigning_Authority] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Name_Type_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Identifier_Check_Digit] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Check_Digit_Scheme] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Identifier_Type_Code] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Assigning_Facility] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY]

GO
