SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE  PROCEDURE [dbo].[uspMPI_Populate_ADA_DuplicatedPatient]

AS 


DECLARE   @varpatid UNIQUEIDENTIFIER		--   = 250318
, @varmatchid VARCHAR(50)	--   = 'A240-D450-19 Nov 2005'
, @varnhsno VARCHAR(15)	--   = ''
, @varpc VARCHAR(20)		--   = 'OX38QJ'
, @varAdrs  VARCHAR(20)	--   = '38MasonsRoad'
, @varHome VARCHAR(20)		--   = ''
, @varmobile VARCHAR(20)	--   = ''
, @TelOther VARCHAR(20)		--   = ''
, @varPrac VARCHAR(20)		--   = 'K84044'


IF OBJECT_ID('dbo.tmpMPICursorADA_Matchpatient','U') IS NOT NULL
DROP TABLE dbo.tmpMPICursorADA_Matchpatient 

BEGIN TRY

	BEGIN TRANSACTION;

		;WITH NewAddress AS 
		(
			SELECT AddressRef
				, REPLACE(CASE WHEN CHARINDEX(' ', Building, 1) = 0 THEN Building +' '+Street ELSE Building END,' ','') AS NewAddress
				, REPLACE(REPLACE(Postcode,' ',''),'-','') AS Postcode
			FROM mrr.ADA_Address
		)
		, LatestCase AS 
		(
			 SELECT c.PatientRef, MAX(c.CaseNo) AS CaseNo
			 FROM [mrr].[ADA_Case] c
			 GROUP BY c.PatientRef
		)
		, ADA_latestCase123 AS 
		(
			SELECT lc.PatientRef, c.NationalProviderGroupCode AS Practice_Code
			FROM LatestCase lc
			LEFT JOIN [mrr].[ADA_Case] c
			ON lc.CaseNo = c.CaseNo
		)
		SELECT DISTINCT a.PatientRef	Patient_ID 
		, SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Forename ,' ',''),'-',''),'''','') ,'x')) +'-'+SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Surname ,' ',''),'-',''),'''','') ,'x'))  + '-' + convert(varchar,a.DOB, 106) + '-' + ISNULL(a.Sex,'x') AS Matching_ID 
		, CASE WHEN a.NationalCode <> '' THEN REPLACE(REPLACE(a.NationalCode,' ',''),'-','') ELSE NULL END 	NHS_Number
		,  CASE WHEN a_Adrs.Postcode <> '' THEN a_Adrs.Postcode	 ELSE NULL END Postcode
		,  CASE WHEN a_Adrs.NewAddress <> '' THEN a_Adrs.NewAddress   ELSE NULL END Address1
		,  CASE WHEN a.HomePhone <> '' THEN REPLACE(REPLACE(a.HomePhone,' ',''),'-','')  ELSE NULL END Tel_Home
		,  CASE WHEN a.MobilePhone <> '' THEN REPLACE(REPLACE(a.MobilePhone,' ',''),'-','')  ELSE NULL END Tel_Mobile
		,  CASE WHEN a.OtherPhone <> '' THEN REPLACE(REPLACE(a.OtherPhone,' ',''),'-','')  ELSE NULL END Tel_Other
		, tmp.Practice_Code  
		INTO dbo.tmpMPICursorADA_Matchpatient
		FROM mrr.ADA_Patient a
			LEFT JOIN NewAddress a_adrs
				ON a_adrs.AddressRef = a.AddressRef
		  LEFT JOIN ADA_latestCase123 tmp
			ON a.PatientRef = tmp.PatientRef
		WHERE a.Obsolete = 0
		AND a.Surname NOT LIKE '%XX%TEST%'
		AND a.Surname NOT LIKE '%DO%NOT%USE%'

		CREATE NONCLUSTERED INDEX idx_tmpMPICursorADA_Matchpatient_Matching_ID ON tmpMPICursorADA_Matchpatient(Matching_ID)
		CREATE NONCLUSTERED INDEX idx_tmpMPICursorADA_Matchpatient_Patient_ID ON tmpMPICursorADA_Matchpatient(Patient_ID)


		TRUNCATE TABLE dbo.tblADA_DQ_Issues_DuplicatedPatients

		DECLARE ADA_DQ_Issues_Patients CURSOR FOR
  
		SELECT Patient_ID
			, Matching_ID
			, NHS_Number
			, isnull(Postcode,'xx')
			, isnull(Address1,'xx')
			, isnull(Tel_Home,'xx')
			, isnull(Tel_Mobile,'xx')
			, isnull(Tel_Other,'xx')
			, ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Practice_Code,' ',''),'-',''),'V81999','xx'),'999','xx'),'V81998','xx'),'xx') Practice 
		FROM dbo.tmpMPICursorADA_Matchpatient WITH (NOLOCK)


            
		OPEN ADA_DQ_Issues_Patients
 
		FETCH NEXT FROM ADA_DQ_Issues_Patients
		INTO @varpatid 	, @varmatchid 	, @varnhsno 	, @varpc 	, @varAdrs 	, @varHome  	, @varmobile 	, @TelOther  	, @varPrac 

		WHILE @@FETCH_STATUS = 0
		BEGIN 

			EXECUTE dbo.usp_MPI_ADA_PatientMatching  
				  @varpatid 
				, @varmatchid 
				, @varnhsno 
				, @varpc 
				, @varAdrs 
				, @varHome  
				, @varmobile 
				, @TelOther   
				, @varPrac 
 
		FETCH NEXT FROM ADA_DQ_Issues_Patients
		INTO @varpatid 	, @varmatchid 	, @varnhsno 	, @varpc 	, @varAdrs 	, @varHome  	, @varmobile 	, @TelOther  	, @varPrac  
		END
		CLOSE ADA_DQ_Issues_Patients
		DEALLOCATE ADA_DQ_Issues_Patients

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


IF OBJECT_ID('dbo.tmpMPICursorADA_Matchpatient','U') IS NOT NULL
DROP TABLE dbo.tmpMPICursorADA_Matchpatient 



GO
