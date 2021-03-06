SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNC_tblTeamMember](
	[Team_Member_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[Staff_ID] [int] NULL,
	[Team_Member_Role_ID] [int] NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[Location_ID] [int] NULL,
	[Sub_Specialty_ID] [int] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Staff_Occupation_Code_ID] [int] NULL,
	[Mental_Health_Responsible_Clinician_ID] [int] NULL
) ON [PRIMARY]

GO
