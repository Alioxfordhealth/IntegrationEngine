SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [hl7].[usp_Populate_CNS_Attachment]
AS

/*
test Script:

EXEC [HL7].[usp_Populate_CNS_Attachment]


SELECT * FROM [dbo].[tblHL7_TableTracker]
WHERE TABLE_NAME = 'CNS_tblAttachment'

*/


IF OBJECT_ID('hl7.tblAttachments','U') IS NULL 
BEGIN
		CREATE TABLE [hl7].[tblAttachments](
			[Attachment_ID] [INT] NOT NULL,
			[Attachment_File_ID] [INT] NOT NULL,
			[UpdatedDate] [DATETIME] NULL,
			[sourceSystem] [VARCHAR](5) NOT NULL,
			[DocumentDate] [DATETIME] NOT NULL,
			[MsgSender] [VARCHAR](11) NOT NULL,
			[MsgRecipient] [VARCHAR](6) NOT NULL,
			[IdType] [VARCHAR](3) NOT NULL,
			[IdValue] [VARCHAR](11) NULL,
			[PersonNameType] [VARCHAR](2) NOT NULL,
			[Surname] [VARCHAR](50) NULL,
			[Forename] [VARCHAR](50) NULL,
			[Date_Of_Birth] [DATETIME] NULL,
			[Gender_ID] [INT] NULL,
			[RecpHcpCode] [VARCHAR](20) NULL,
			[RecpHcpDescription] [VARCHAR](201) NULL,
			[RecpPracticeCode] [VARCHAR](20) NULL,
			[RecpPracticeName] [VARCHAR](255) NULL,
			[SendHCPCode] [VARCHAR](50) NULL,
			[SendHCPDesc] [VARCHAR](255) NULL,
			[SendDepartment] [VARCHAR](255) NULL,
			[OrgCode] [VARCHAR](3) NOT NULL,
			[OrgName] [VARCHAR](13) NOT NULL,
			[DocumentID] [INT] NULL,
			[ReportType] [VARCHAR](255) NULL,
			[EventDate] [DATETIME] NULL,
			[EventDateEnd] [DATETIME] NULL,
			[DocCreationDate] [DATETIME] NOT NULL,
			[Attachment_File_Name] [VARCHAR](255) NULL,
			[Doc_Title] [VARCHAR](255) NOT NULL,
			[Attachment_File_Body] [IMAGE] NULL,
			[Docman_ID] [VARCHAR](20) NULL,
			[IntegratedDocumentID] [VARCHAR](54) NULL,
			[FileExtension] [VARCHAR](5) NULL,
		PRIMARY KEY CLUSTERED 
		(
			[Attachment_ID] ASC,
			[Attachment_File_ID] ASC,
			[sourceSystem] ASC
		)
		) 
END


BEGIN TRY

	BEGIN TRANSACTION;

		DECLARE @LoadId int = (SELECT MAX(LoadID) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNS_tblAttachment' AND SourceSystem = 'CNS')
		SET @LoadId = ISNULL(@LoadId,0) + 1

		-- Delete all Mental Health Attachments
		DELETE FROM att
		FROM [hl7].[tblAttachments] att
		WHERE att.[sourceSystem] = 'CNS'


		INSERT INTO [hl7].[tblAttachments](
				[Attachment_ID]
			  ,[Attachment_File_ID]
			  ,[UpdatedDate]
			  ,[sourceSystem]
			  ,[DocumentDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[Surname]
			  ,[Forename]
			  ,[Date_Of_Birth]
			  ,[Gender_ID]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[DocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[Attachment_File_Name]
			  ,[Doc_Title]
			  ,[Attachment_File_Body]
			  ,[IntegratedDocumentID]
			  ,[FileExtension]
		)
		SELECT [Attachment_ID]
			  ,[Attachment_File_ID]
			  ,[UpdatedDate]
			  ,[sourceSystem]
			  ,[DocumentDate]
			  ,[MsgSender]
			  ,[MsgRecipient]
			  ,[IdType]
			  ,[IdValue]
			  ,[PersonNameType]
			  ,[Surname]
			  ,[Forename]
			  ,[Date_Of_Birth]
			  ,[Gender_ID]
			  ,[RecpHcpCode]
			  ,[RecpHcpDescription]
			  ,[RecpPracticeCode]
			  ,[RecpPracticeName]
			  ,[SendHCPCode]
			  ,[SendHCPDesc]
			  ,[SendDepartment]
			  ,[OrgCode]
			  ,[OrgName]
			  ,[DocumentID]
			  ,[ReportType]
			  ,[EventDate]
			  ,[EventDateEnd]
			  ,[DocCreationDate]
			  ,[Attachment_File_Name]
			  ,[Doc_Title]
			  ,[Attachment_File_Body]
			  ,[IntegratedDocumentID]
			  ,[FileExtension]
		  FROM [hl7].[vw_CNS_Attachment] att
		  


		-- delete from Tracker table 
			DECLARE @NoOfRecords INT = @@ROWCOUNT

			IF @NoOfRecords > 0
			BEGIN 
				INSERT INTO [dbo].[tblHL7_TableTracker] 
					VALUES 
					(	  'CNS'
						, 'CNS_tblAttachment'
						, getdate() 
						, (ISNULL((SELECT MAX([UpdatedDate]) FROM [hl7].[tblAttachments]),'1 Jan 1900'))
						, @LoadId
						,@NoOfRecords
					)
			END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
