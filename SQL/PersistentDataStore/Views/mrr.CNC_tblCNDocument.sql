SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [mrr].[CNC_tblCNDocument] AS SELECT [CN_Doc_ID], [Patient_ID], [Referral_ID], [Episode_ID], [CN_Object_ID], [Object_Type_ID], [Icon], [ViewDate], [ViewTime], [ViewDttm], [ViewText], [ViewForm], [CNV3_Universal_ID], [Is_Active], [Active_Period_End_Dttm], [Current_Indicator], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Service_ID] FROM [Mirror].[mrr_tbl].[CNC_tblCNDocument];

GO
