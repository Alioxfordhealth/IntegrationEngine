SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[CNC_tblSchool] AS SELECT [School_ID], [Active_ID], [School_Name], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Telephone], [Fax], [Email_Address], [Web_Site], [Head_Teacher_Name], [Administrative_Contact_Name], [SENCO_Name], [Education_Psychologist_Staff_ID], [National_School_Code], [School_Category_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm] FROM [Mirror].[mrr_tbl].[CNC_tblSchool];

GO
