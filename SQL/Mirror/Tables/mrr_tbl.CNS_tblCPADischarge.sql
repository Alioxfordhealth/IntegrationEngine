SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [mrr_tbl].[CNS_tblCPADischarge](
	[CPA_Discharge_ID] [int] NOT NULL,
	[Patient_ID] [int] NULL,
	[CPA_Start_ID] [int] NULL,
	[CPA_Review_ID] [int] NULL,
	[CPA_Discharge_Date] [datetime] NULL,
	[CPA_Discharge_Time] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[CPA_Discharge_Dttm] [datetime] NULL,
	[Authorised_By_Staff_ID] [int] NULL,
	[CPA_Discharge_Type_ID] [int] NULL,
	[Moved_To] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Contact_Info] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[Responsibility_Of] [varchar](255) COLLATE Latin1_General_CI_AS NULL,
	[SW_Involved_ID] [int] NULL,
	[Day_Centre_Involved_ID] [int] NULL,
	[Sheltered_Work_Involved_ID] [int] NULL,
	[Non_NHS_Res_Accom_ID] [int] NULL,
	[Domicil_Care_Involved_ID] [int] NULL,
	[CPA_Employment_Status_ID] [int] NULL,
	[CPA_Weekly_Hours_Worked_ID] [int] NULL,
	[CPA_Accomodation_Status_ID] [int] NULL,
	[CPA_Settled_Accomodation_Indicator_ID] [int] NULL,
	[Receiving_Direct_Payments_ID] [int] NULL,
	[Individual_Budget_Agreed_ID] [int] NULL,
	[Other_Financial_Considerations_ID] [int] NULL,
	[Comments] [text] COLLATE Latin1_General_CI_AS NULL,
	[Accommodation_Status_Date] [datetime] NULL,
	[Employment_Status_Date] [datetime] NULL,
	[User_Created] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Create_Dttm] [datetime] NULL,
	[User_Updated] [varchar](100) COLLATE Latin1_General_CI_AS NULL,
	[Updated_Dttm] [datetime] NOT NULL,
	[Active_Period_End] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
