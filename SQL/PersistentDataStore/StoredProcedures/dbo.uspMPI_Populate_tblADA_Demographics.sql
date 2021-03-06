SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE  PROCEDURE [dbo].[uspMPI_Populate_tblADA_Demographics]

AS

BEGIN TRY

	BEGIN TRANSACTION;

		IF OBJECT_ID ('stg.tblADA_Demographics','U')  IS NULL 
		BEGIN
				CREATE TABLE [stg].[tblADA_Demographics](
					[Patient_ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
					LocalID BIGINT, 
					[Forename] [VARCHAR](50) NULL,
					[Surname] [VARCHAR](50) NULL,
					[Date_Of_Birth] [DATETIME] NULL,
					[NHS_Number] [VARCHAR](11) NULL,
					[Gender] VARCHAR(1) NULL,
					[Address1] [VARCHAR](255) NULL,
					[Address2] [VARCHAR](255) NULL,
					[Address3] [VARCHAR](255) NULL,
					[Address4] [VARCHAR](512) NULL,
					[Postcode] [VARCHAR](50) NULL,
					[AddressType] VARCHAR(20), 
					[Practice_Code] VARCHAR(10),
					[Date_Of_Death] [DATETIME] NULL,
					[PrimaryLanguage] [VARCHAR](255) NULL,
					[EthnicGroup] VARCHAR(5) NULL,
					[CreatedDate] [DATETIME] NULL,
					[UpdatedDate] [DATETIME] NULL,
					[ValidNHSNumber] VARCHAR(1)
				)
		END
		ELSE
		BEGIN
			TRUNCATE TABLE [stg].[tblADA_Demographics]
		END 


		 -- get PracyiceCode

		 IF OBJECT_ID ('dbo.tmpADA_latestCase123','U')  IS NOT NULL 
		 DROP TABLE dbo.tmpADA_latestCase123

		; WITH LatestCase AS 
		(
			 SELECT c.PatientRef, MAX(c.CaseNo) AS CaseNo
			 FROM [mrr].[ADA_Case] c
			 GROUP BY c.PatientRef
		)
		SELECT lc.PatientRef, c.NationalProviderGroupCode AS Practice_Code
		INTO  dbo.tmpADA_latestCase123
		FROM LatestCase lc
		LEFT JOIN [mrr].[ADA_Case] c
		ON lc.CaseNo = c.CaseNo



		INSERT INTO [stg].[tblADA_Demographics]
		(	  [Patient_ID]
			, [LocalID]
			, [Forename]
			, [Surname] 
			, [Date_Of_Birth] 
			, [NHS_Number] 
			, [Gender] 
			, [Address1]
			, [Address2]
			, [Address3] 
			, [Address4]
			, [Postcode] 
			, AddressType
			, [Practice_Code]
			, [Date_Of_Death]
			, [PrimaryLanguage] 
			, [EthnicGroup]
			, [CreatedDate] 
			, [UpdatedDate] 
			--,ValidNHSNumber
		)
		SELECT	  ada.[PatientRef]
				, ada.[LocalID]
				, ada.[Forename]
				, ada.[Surname]
				, ada.[DOB]
				, ada.[NHS_Number]
				, ada.[Sex]
				, ada.Address1
				, ada.Address2
				, ada.Address3
				, ada.Address4
				, ada.[Postcode]
				, ada.[AddressType]
				, LEFT(tmp.Practice_Code, 9) 
				, NULL as Date_of_Death
				, [MainLanguage]
				, ada.[EthnicGroup]
				, ada.[CreatedDate] 
				, ada.[EditDate]
				--,CASE WHEN dbo.udf_ValidateNHSNumber([NHS_Number]) = 0 THEN 'Y' ELSE 'N' END Valid_NHSNumber
		  FROM [src].[vwADA_Demographics] ada
		  LEFT JOIN dbo.tmpADA_latestCase123 tmp
			ON ada.PatientRef = tmp.PatientRef
		 -- inner join [dbo].[tblOH_MPI] mpi
			--on ada.NHS_Number = mpi.NHS_Number collate SQL_Latin1_General_CP1_CI_AS
			--and ada.EditDate > mpi.UpdatedDttm
		  WHERE LEN(ada.[NHS_Number]) = 10
		  AND ada.EditDate > ISNULL((SELECT MAX([MaxUpdateTime]) max_datetime FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'tblOH_MPI'),'1 Jan 1900')   


		-- populate [ValidNHSNumber] column
		  update [stg].[tblADA_Demographics]
		  set [ValidNHSNumber] = CASE WHEN dbo.udf_ValidateNHSNumber([NHS_Number]) = 0 THEN 'Y' ELSE 'N' END


  	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


IF OBJECT_ID ('dbo.tmpADA_latestCase123','U')  IS NOT NULL 
 DROP TABLE dbo.tmpADA_latestCase123
GO
