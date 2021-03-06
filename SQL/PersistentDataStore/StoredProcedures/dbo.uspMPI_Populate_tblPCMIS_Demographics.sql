SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_tblPCMIS_Demographics]

AS

BEGIN TRY

	BEGIN TRANSACTION;

		IF OBJECT_ID ('stg.tblPCMIS_Demographics','U')  IS NULL 
		BEGIN
			CREATE TABLE [stg].[tblPCMIS_Demographics](
				[Patient_ID] VARCHAR(20) NOT NULL,
				[CaseNumber] VARCHAR(20),
				[CaseStart_Dttm] DATETIME, 
				[Forename] [VARCHAR](50) NULL,
				[MiddleName] [VARCHAR](50) NULL,
				[Surname] [VARCHAR](50) NULL,
				[Patient_Name] [VARCHAR](255) NULL,
				[Title] VARCHAR(15) NULL,
				[Date_Of_Birth] [DATETIME] NULL,
				[NHS_Number] [VARCHAR](11) PRIMARY Key,
				[Gender_ID] INT  NULL,
				[Address1] [VARCHAR](255) NULL,
				[Address2] [VARCHAR](255) NULL,
				[Address3] [VARCHAR](255) NULL,
				[Address4] [VARCHAR](512) NULL,
				[Postcode] [VARCHAR](50) NULL,
				[AddressType] [INT] NULL,
				[DateOfDeath] [DATETIME] NULL,
				[PracticeCode] [VARCHAR](20) NULL,
				[MainLanguage] [VARCHAR](5) NULL,
				[MaritalStatus]  [VARCHAR](2)NULL,
				[Ethnicity]  [VARCHAR](2) NULL,
				[Religion]  [VARCHAR](2) NULL,
				[CreatedDate] [DATETIME] NULL,
				[UpdatedDate] [DATETIME] NULL,
				[ValidNHSNumber] [VARCHAR](1) NULL
			) 
		END
		ELSE
		BEGIN
			TRUNCATE TABLE [stg].[tblPCMIS_Demographics]
		END

		IF OBJECT_ID ('dbo.tmpPCMIS123','U')  IS NOT NULL 
		DROP TABLE dbo.tmpPCMIS123


		;WITH Dedup_Pats AS 
		(
			SELECT a.*, ROW_NUMBER() OVER(PARTITION BY NHSNumber ORDER BY [CaseStart_Dttm] desc) ordr FROM 
			(
				SELECT NHSNumber	 
					  ,[CaseNumber]
					  ,[CaseStart_Dttm]
					  ,'Bucks' src
				 FROM [src].[vwPCMIS_Bucks_Demographics]

				 UNION ALL 

				 SELECT NHSNumber	 
					  ,[CaseNumber]
					  ,[CaseStart_Dttm]
					  ,'Oxon' src
				 FROM [src].[vwPCMIS_Oxon_Demographics]
			) a
		)

		SELECT * 
		INTO dbo.tmpPCMIS123
		FROM Dedup_Pats
		WHERE Dedup_Pats.ordr = 1


		--===============================
		-- Load PCMIS - OXON date 
		--===============================
		INSERT INTO [stg].[tblPCMIS_Demographics](
			   [Patient_ID]
			  ,[CaseNumber]
			  ,[CaseStart_Dttm]
			  ,[Forename]
			  ,[MiddleName]
			  ,[Surname]
			  ,[Patient_Name]
			  ,[Title]
			  ,[Date_Of_Birth]
			  ,[NHS_Number]
			  ,[Gender_ID]
			  ,[Address1]
			  ,[Address2]
			  ,[Address3]
			  ,[Address4]
			  ,[Postcode]
			  ,[AddressType]
			  ,[DateOfDeath]
			  ,[PracticeCode]
			  ,[MainLanguage]
			  ,[MaritalStatus]
			  ,[Ethnicity]
			  ,[Religion]
			  ,[CreatedDate]
			  ,[UpdatedDate]
			  --,[ValidNHSNumber]
		)
		SELECT distinct ox.[PatientID]	AS [Patient_ID]
			  ,ox.[CaseNumber]
			  ,ox.[CaseStart_Dttm]
			  ,[FirstName]
			  ,ox.[MiddleName]
			  ,ox.[LastName] 
			  ,ox.[DisplayName]
			  ,ox.[Title]
			  ,ox.[DOB]
			  ,ox.[NHSNumber]
			  ,ox.[Gender_ID]
			  ,ox.[Address1]
			  ,ox.[Address2]
			  ,ox.[Address3]
			  ,ox.[Address4]
			  ,ox.[Postcode]
			  ,NULL AS [AddressType]
			  ,ox.[DateOfDeath]
			  ,ox.[PracticeCode]
			  ,ox.[MainLanguage]
			  ,ox.[MaritalStatus]
			  ,ox.[Ethnicity]
			  ,ox.[Religion]
			  ,ox.[CreatedDate]
			  ,ox.[UpdatedDate]
			  --, CASE WHEN dbo.udf_ValidateNHSNumber(ox.[NHSNumber]) = 0 THEN 'Y' ELSE 'N' END 
		  FROM [src].[vwPCMIS_Oxon_Demographics] ox
		  INNER JOIN dbo.tmpPCMIS123 tmp 
			ON ox.NHSNumber = tmp.NHSNumber 
			AND ox.CaseNumber = tmp.CaseNumber
			AND tmp.src = 'Oxon'
		 -- INNER JOIN [dbo].[tblOH_MPI] mpi 
			--ON ox.NHSNumber = mpi.NHS_Number
			--AND ox.UpdatedDate > mpi.UpdatedDttm
		  WHERE LEN(ox.[NHSNumber]) = 10 
		  AND ox.UpdatedDate >  ISNULL((SELECT MAX([MaxUpdateTime]) max_datetime FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'tblOH_MPI'),'1 Jan 1900')

  
		--===============================
		-- Load PCMIS - BUCKS date 
		--===============================
		INSERT INTO [stg].[tblPCMIS_Demographics](
			   [Patient_ID]
			  ,[CaseNumber]
			  ,[CaseStart_Dttm]
			  ,[Forename]
			  ,[MiddleName]
			  ,[Surname]
			  ,[Patient_Name]
			  ,[Title]
			  ,[Date_Of_Birth]
			  ,[NHS_Number]
			  ,[Gender_ID]
			  ,[Address1]
			  ,[Address2]
			  ,[Address3]
			  ,[Address4]
			  ,[Postcode]
			  ,[AddressType]
			  ,[DateOfDeath]
			  ,[PracticeCode]
			  ,[MainLanguage]
			  ,[MaritalStatus]
			  ,[Ethnicity]
			  ,[Religion]
			  ,[CreatedDate]
			  ,[UpdatedDate]
			  --,[ValidNHSNumber]
		)
		SELECT bucks.[PatientID]	AS [Patient_ID]
			  ,bucks.[CaseNumber]
			  ,bucks.[CaseStart_Dttm]
			  ,bucks.[FirstName]
			  ,bucks.[MiddleName]
			  ,bucks.[LastName] 
			  ,bucks.[DisplayName]
			  ,bucks.[Title]
			  ,bucks.[DOB]
			  ,bucks.[NHSNumber]
			  ,bucks.[Gender_ID]
			  ,bucks.[Address1]
			  ,bucks.[Address2]
			  ,bucks.[Address3]
			  ,bucks.[Address4]
			  ,bucks.[Postcode]
			  ,NULL AS [AddressType]
			  ,bucks.[DateOfDeath]
			  ,bucks.[PracticeCode]
			  ,bucks.[MainLanguage]
			  ,bucks.[MaritalStatus]
			  ,bucks.[Ethnicity]
			  ,bucks.[Religion]
			  ,bucks.[CreatedDate]
			  ,bucks.[UpdatedDate]
			  --, CASE WHEN dbo.udf_ValidateNHSNumber(bucks.[NHSNumber]) = 0 THEN 'Y' ELSE 'N' END 
		  FROM [src].[vwPCMIS_Bucks_Demographics] bucks
		   INNER JOIN dbo.tmpPCMIS123 tmp 
			ON bucks.NHSNumber = tmp.NHSNumber 
			AND bucks.CaseNumber = tmp.CaseNumber
			AND tmp.src = 'Bucks'
		 -- INNER JOIN [dbo].[tblOH_MPI] mpi 
			--ON bucks.NHSNumber = mpi.NHS_Number
			--AND bucks.UpdatedDate > mpi.UpdatedDttm
		  WHERE LEN(bucks.[NHSNumber]) = 10 
			AND bucks.UpdatedDate >  ISNULL((SELECT MAX([MaxUpdateTime]) max_datetime FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'tblOH_MPI'),'1 Jan 1900')



		UPDATE [stg].[tblPCMIS_Demographics]
		SET ValidNHSNumber = CASE WHEN dbo.udf_ValidateNHSNumber([NHS_Number]) = 0 THEN 'Y' ELSE 'N' END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


IF OBJECT_ID ('dbo.tmpPCMIS123','U')  IS NOT NULL 
DROP TABLE dbo.tmpPCMIS123
GO
