SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_udpAVNotAchievedValues] AS SELECT [UDP_AVNotAchieved_ID], [UDP_AVNotAchieved_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_udpAVNotAchievedValues];
GO
