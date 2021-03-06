SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_CNC_DuplicatedPatient]

AS 


DECLARE   @varpatid BIGINT		--   = 250318
, @varmatchid VARCHAR(50)	--   = 'A240-D450-19 Nov 2005'
, @varnhsno VARCHAR(15)	--   = ''
, @varpc VARCHAR(20)		--   = 'OX38QJ'
, @varAdrs  VARCHAR(20)	--   = '38MasonsRoad'
, @varHome VARCHAR(20)		--   = ''
, @varmobile VARCHAR(20)	--   = ''
, @varwork VARCHAR(20)		--   = ''
, @vargp VARCHAR(20)		--   = 'G3274394'
, @varPrac VARCHAR(20)		--   = 'K84044'


IF OBJECT_ID('dbo.tmpMPICursorCNC_Matchpatient','U') IS NOT NULL
DROP TABLE dbo.tmpMPICursorCNC_Matchpatient 

BEGIN TRY

	BEGIN TRANSACTION;

			SELECT DISTINCT a.Patient_ID	Patient_ID 
			, SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Forename ,' ',''),'-',''),'''','') ,'x')) +'-'+SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Surname ,' ',''),'-',''),'''','') ,'x'))  + '-' + convert(varchar,a.Date_Of_Birth, 106) + '-' + ISNULL(CAST(a.Gender_ID AS VARCHAR(1)), 'X') AS Matching_ID
			, REPLACE(REPLACE(a.NHS_Number,' ',''),'-','') 	NHS_Number
			, REPLACE(REPLACE(a_Adrs.Post_Code,' ',''),'-','')	Postcode
			, REPLACE(a_Adrs.Address1,' ','') Address1
			, REPLACE(REPLACE(a_Adrs.Tel_Home,' ',''),'-','') Tel_Home
			, REPLACE(REPLACE(a_Adrs.Tel_Mobile,' ',''),'-','') Tel_Mobile
			, REPLACE(REPLACE(a_Adrs.Tel_Work,' ',''),'-','') Tel_Work
			, agp.GP_Code 
			, aPrac.Practice_Code 
			INTO dbo.tmpMPICursorCNC_Matchpatient
			FROM mrr.CNC_tblPatient  a
				LEFT JOIN mrr.CNC_tblAddress a_adrs
					ON a_adrs.Patient_ID = a.Patient_ID
				LEFT JOIN mrr.CNC_tblGPDetail apgd
					ON a.Patient_ID = apgd.Patient_ID
				LEFT JOIN mrr.CNC_tblGP agp
					ON agp.GP_ID = apgd.GP_ID
				LEFT JOIN mrr.CNC_tblPractice aPrac
					ON aPrac.Practice_ID = apgd.Practice_ID
			WHERE a.Surname NOT LIKE '%XX%TEST%'
			AND a.Surname NOT LIKE '%DO%NOT%USE%'


			CREATE NONCLUSTERED INDEX idx_tmpMPICursorCNC_Matchpatient_Matching_ID ON tmpMPICursorCNC_Matchpatient(Matching_ID)
			CREATE NONCLUSTERED INDEX idx_tmpMPICursorCNC_Matchpatient_Patient_ID ON tmpMPICursorCNC_Matchpatient(Patient_ID)

			TRUNCATE TABLE dbo.tblCNC_DQ_Issues_DuplicatedPatients

			DECLARE CNC_DQ_Issues_Patients CURSOR FOR
  
			SELECT Patient_ID
				, Matching_ID
				, NHS_Number
				, Postcode
				, Address1
				, Tel_Home
				, Tel_Mobile
				, Tel_Work
				, REPLACE(REPLACE(REPLACE(GP_Code,' ',''),'-',''),'G9999998','x') GP
				, REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Practice_Code,' ',''),'-',''),'V81999','xx'),'999','xx'),'V81998','xx') Practice 
			FROM dbo.tmpMPICursorCNC_Matchpatient WITH (NOLOCK)




             
			OPEN CNC_DQ_Issues_Patients
 
			FETCH NEXT FROM CNC_DQ_Issues_Patients
			INTO @varpatid 	, @varmatchid 	, @varnhsno 	, @varpc 	, @varAdrs 	, @varHome  	, @varmobile 	, @varwork  	, @vargp  	, @varPrac 

			WHILE @@FETCH_STATUS = 0
			BEGIN 

				EXECUTE dbo.usp_MPI_CNC_PatientMatching  
					  @varpatid 
					, @varmatchid 
					, @varnhsno 
					, @varpc 
					, @varAdrs 
					, @varHome  
					, @varmobile 
					, @varwork  
					, @vargp  
					, @varPrac 
 
			FETCH NEXT FROM CNC_DQ_Issues_Patients
			INTO @varpatid 	, @varmatchid 	, @varnhsno 	, @varpc 	, @varAdrs 	, @varHome  	, @varmobile 	, @varwork  	, @vargp  	, @varPrac  
			END
			CLOSE CNC_DQ_Issues_Patients
			DEALLOCATE CNC_DQ_Issues_Patients


	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
IF OBJECT_ID('dbo.tmpMPICursorCNC_Matchpatient','U') IS NOT NULL
DROP TABLE dbo.tmpMPICursorCNC_Matchpatient 



GO
