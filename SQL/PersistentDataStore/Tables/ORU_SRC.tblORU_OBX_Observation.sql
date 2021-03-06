SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [ORU_SRC].[tblORU_OBX_Observation](
	[Message_ID] [varchar](50) COLLATE Latin1_General_CI_AS NULL,
	[OBR_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[OBX_ID] [varchar](4) COLLATE Latin1_General_CI_AS NULL,
	[Value_Type] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[Observation_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Text] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Observation_CodingSystem] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Alternate_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Alternate_Text] [varchar](200) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Sub_ID] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Value] [varchar](max) COLLATE Latin1_General_CI_AS NULL,
	[Units] [varchar](60) COLLATE Latin1_General_CI_AS NULL,
	[Reference_Range] [varchar](10) COLLATE Latin1_General_CI_AS NULL,
	[Abnormal_Flags] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Probability] [varchar](5) COLLATE Latin1_General_CI_AS NULL,
	[Nature_of_Abnormal_Test] [varchar](2) COLLATE Latin1_General_CI_AS NULL,
	[Observ_Result_Status] [varchar](1) COLLATE Latin1_General_CI_AS NULL,
	[Data_Last_Obs_Normal_Values] [varchar](26) COLLATE Latin1_General_CI_AS NULL,
	[User_Defined_Access_Checks] [varchar](20) COLLATE Latin1_General_CI_AS NULL,
	[DateTime_of_the_Observation] [varchar](26) COLLATE Latin1_General_CI_AS NULL,
	[Producers_ID] [varchar](60) COLLATE Latin1_General_CI_AS NULL,
	[Responsible_Observer] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[Observation_Method] [varchar](80) COLLATE Latin1_General_CI_AS NULL,
	[Load_Dttm] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
