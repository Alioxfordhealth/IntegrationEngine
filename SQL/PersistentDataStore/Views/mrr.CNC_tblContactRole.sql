SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[CNC_tblContactRole] AS SELECT [Contact_ID], [Contact_Role_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblContactRole];

GO
