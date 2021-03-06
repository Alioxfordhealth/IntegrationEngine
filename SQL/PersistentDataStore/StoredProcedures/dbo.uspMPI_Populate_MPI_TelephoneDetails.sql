SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE PROCEDURE [dbo].[uspMPI_Populate_MPI_TelephoneDetails]
AS


BEGIN TRY

	BEGIN TRANSACTION;

		IF OBJECT_ID('dbo.tblOH_MPI_TelephoneDetails','U') IS NULL
		BEGIN 
			CREATE TABLE [dbo].[tblOH_MPI_TelephoneDetails](
				[MPI_ID] [BIGINT] NOT NULL,
				[NokContact_ID] [BIGINT] NULL,
				[Telephone_Number] [VARCHAR](20) NULL,
				[PhoneTypeCode] [VARCHAR](10) NULL,
				[UseCode]	[VARCHAR](3) NULL,
				[ContactRole] [VARCHAR](10) NULL,
				[PhoneType] [VARCHAR](10) NULL,
				[Main_Number_Flag] [BIT] NULL,
				[Updated_Dttm] [DATETIME] NULL
			) 
		END 
		ELSE 
		BEGIN
			-- delete old data
			DELETE FROM dbo.tblOH_MPI_TelephoneDetails
			FROM dbo.tblOH_MPI_TelephoneDetails mpi
			INNER JOIN dbo.tmpmpiNewData123 tmp
			ON mpi.MPI_ID = tmp.MPI_ID
		END




		--=================
		-- Load from CNC
		--=================
		INSERT INTO dbo.tblOH_MPI_TelephoneDetails
		(
				[MPI_ID]
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole] 
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm] 
		)
		SELECT  tmp.MPI_ID
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole]
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm]
		  FROM  [src].[vwCNC_Telephone] tlfn
		  INNER JOIN dbo.tmpmpiNewData123 tmp
			ON tmp.CH_Patient_ID = tlfn.Patient_ID

		--=================
		-- Load from CNS
		--=================
	
		INSERT INTO dbo.tblOH_MPI_TelephoneDetails
		(
				[MPI_ID]
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole] 
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm] 
		)
		SELECT tmp.MPI_ID
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole]
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm]
		  FROM  [src].[vwCNS_Telephone] tlfn
		  INNER JOIN dbo.tmpmpiNewData123 tmp
			ON tmp.MH_Patient_ID = tlfn.Patient_ID


		--=====================
		-- Load from ADASTRA
		--=====================
	
		INSERT INTO dbo.tblOH_MPI_TelephoneDetails
		(
				[MPI_ID]
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole] 
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm] 
		)
		SELECT tmp.MPI_ID
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole]
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm]
		  FROM  [src].[vwADA_Telephone] tlfn
		  INNER JOIN dbo.tmpmpiNewData123 tmp
			ON tmp.Adastra_Patient_ID = tlfn.PatientRef

		--=====================
		-- Load from PCMIS - OXOXN 
		--=====================
	
		INSERT INTO dbo.tblOH_MPI_TelephoneDetails
		(
				[MPI_ID]
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole] 
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm] 
		)
		SELECT tmp.MPI_ID
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole]
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , NULL AS [Updated_Dttm]
		  FROM  [src].[vwPCMISOXON_Telephone] tlfn
		  INNER JOIN dbo.tmpmpiNewData123 tmp
			ON tmp.PCMIS_Patient_ID = tlfn.PatientID COLLATE Latin1_General_CI_AS

		--=========================
		-- Load from PCMIS - BUCKS 
		--=========================
	
		INSERT INTO dbo.tblOH_MPI_TelephoneDetails
		(
				[MPI_ID]
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole] 
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , [Updated_Dttm] 
		)
		SELECT tmp.MPI_ID
			  , [NokContact_ID]
			  , [Telephone_Number]
			  , [PhoneTypeCode]
			  , [UseCode]
			  , [ContactRole]
			  , [PhoneType]
			  , [Main_Number_Flag]
			  , NULL AS [Updated_Dttm]
		  FROM  [src].[vwPCMISBUCKS_Telephone] tlfn
		  INNER JOIN dbo.tmpmpiNewData123 tmp
			ON tmp.PCMIS_Patient_ID = tlfn.PatientID COLLATE Latin1_General_CI_AS

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


GO
