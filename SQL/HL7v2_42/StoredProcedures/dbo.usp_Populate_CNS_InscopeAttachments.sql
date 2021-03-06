SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE PROCEDURE [dbo].[usp_Populate_CNS_InscopeAttachments]
AS


IF OBJECT_ID('dbo.CNS_tblInscopeAttachments','U') IS NULL
BEGIN
		CREATE TABLE [dbo].[CNS_tblInscopeAttachments](
			[Attachment_ID] [INT] NOT NULL,
			[Attachment_File_ID] [INT] NULL,
			[SourceSystem] [VARCHAR](3) NOT NULL,
			[Patient_ID] [INT] NULL,
			[Practice_Code] [VARCHAR](20) NULL,
			[Practice_Name] VARCHAR(100),
			[GP_Code] VARCHAR(10),
			[GP_Name] varchar(100),
			[NHS_Number]	VARCHAR(11),
			[Surname] VARCHAR(50),
			[Forename] VARCHAR(50),
			[Date_Of_Birth]  DATE,
			[Gender_ID] INT
		) 
END


BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [dbo].[CNS_tblInscopeAttachments]

		INSERT INTO [dbo].[CNS_tblInscopeAttachments]
		SELECT [Attachment_ID]
			, [Attachment_File_ID]
			, [SourceSystem]
			, [Patient_ID]
			, [Practice_Code]
			, [Practice_Name] 
			, [GP_Code]
			, [GP_Name]
			, [NHS_Number] 
			, [Surname] 
			, [Forename] 
			, [Date_Of_Birth] 
			, [Gender_ID] 
		FROM [dbo].[vwCNS_InscopeAttachment]

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;

GO
