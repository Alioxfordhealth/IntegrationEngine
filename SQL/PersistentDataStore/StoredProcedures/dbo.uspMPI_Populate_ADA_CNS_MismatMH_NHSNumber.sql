SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_ADA_CNS_MismatMH_NHSNumber]

AS


IF OBJECT_ID('dbo.tmpMPI_MH_MismatMH_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_MH_MismatMH_NHSNo 


IF OBJECT_ID('dbo.tmpMPI_ADA_MismatMH_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_ADA_MismatMH_NHSNo 

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [dbo].[tblADA_CNS_DQ_Issues_MismatMH_NHSNumber]


		SELECT DISTINCT a.Patient_ID	Patient_ID 
		, SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Forename ,' ',''),'-',''),'''','') ,'x')) +SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Surname ,' ',''),'-',''),'''','') ,'x'))  + convert(varchar,a.Date_Of_Birth, 112) as Matching_ID
		, a.Forename
		, a.Surname
		, a.Date_Of_Birth
		, REPLACE(REPLACE(a.NHS_Number,' ',''),'-','') 	NHS_Number
		, ISNULL(REPLACE(REPLACE(a_Adrs.Post_Code,' ',''),'-',''),'xx')	Postcode
		, ISNULL(REPLACE(a_Adrs.Address1,' ',''),'xx') Address1
		, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Home,' ',''),'-',''),'xx') Tel_Home
		, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Mobile,' ',''),'-',''),'xx') Tel_Mobile
		, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Work,' ',''),'-',''),'xx') Tel_Work
		, ISNULL(aPrac.Practice_Code,'xx')  AS Practice_Code
		INTO dbo.tmpMPI_MH_MismatMH_NHSNo
		FROM mrr.CNS_tblPatient  a
			LEFT JOIN mrr.CNS_tblAddress a_adrs
				ON a_adrs.Patient_ID = a.Patient_ID
			LEFT JOIN mrr.CNS_tblGPDetail apgd
				ON a.Patient_ID = apgd.Patient_ID
			LEFT JOIN mrr.CNS_tblPractice aPrac
				ON aPrac.Practice_ID = apgd.Practice_ID
		WHERE a.Surname NOT LIKE '%XX%TEST%'
		AND a.Surname NOT LIKE '%DO%NOT%USE%'
		AND LEN(a.NHS_Number) = 10

		CREATE NONCLUSTERED INDEX idx_tmpMPI_MH_MismatMH_NHSNo_Matching_ID ON tmpMPI_MH_MismatMH_NHSNo(Matching_ID)
		CREATE NONCLUSTERED INDEX idx_tmpMPI_MH_MismatMH_NHSNo_NHS_Number ON tmpMPI_MH_MismatMH_NHSNo(NHS_Number)


		;WITH NewAddress AS 
		(
			SELECT AddressRef
				, REPLACE(CASE WHEN CHARINDEX(' ', Building, 1) = 0 THEN Building +' '+Street ELSE Building END,' ','') AS NewAddress
				, REPLACE(REPLACE(Postcode,' ',''),'-','') AS Postcode
			FROM mrr.ADA_Address
		)
		--, LatestCase AS 
		--(
		--	 SELECT c.PatientRef, MAX(c.CaseNo) AS CaseNo
		--	 FROM [mrr].[ADA_Case] c
		--	 GROUP BY c.PatientRef
		--)
		--, ADA_latestCase123 AS 
		--(
		--	SELECT lc.PatientRef, c.NationalProviderGroupCode AS Practice_Code
		--	FROM LatestCase lc
		--	LEFT JOIN [mrr].[ADA_Case] c
		--	ON lc.CaseNo = c.CaseNo
		--)
		SELECT DISTINCT a.PatientRef	Patient_ID 
		, SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Forename ,' ',''),'-',''),'''','') ,'x')) + SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Surname ,' ',''),'-',''),'''','') ,'x'))  + convert(varchar,a.DOB, 112) as Matching_ID
		, a.Forename
		, a.Surname
		, a.DOB 
		, CASE WHEN a.NationalCode <> '' THEN REPLACE(REPLACE(a.NationalCode,' ',''),'-','') ELSE NULL END 	NHS_Number
		,  CASE WHEN a_Adrs.Postcode <> '' THEN a_Adrs.Postcode	 ELSE NULL END Postcode
		,  CASE WHEN a_Adrs.NewAddress <> '' THEN a_Adrs.NewAddress   ELSE NULL END Address1
		,  CASE WHEN a.HomePhone <> '' THEN REPLACE(REPLACE(a.HomePhone,' ',''),'-','')  ELSE NULL END Tel_Home
		,  CASE WHEN a.MobilePhone <> '' THEN REPLACE(REPLACE(a.MobilePhone,' ',''),'-','')  ELSE NULL END Tel_Mobile
		,  CASE WHEN a.OtherPhone <> '' THEN REPLACE(REPLACE(a.OtherPhone,' ',''),'-','')  ELSE NULL END Tel_Other
		, CAST(NULL AS VARCHAR(9)) AS Practice_Code  
		INTO dbo.tmpMPI_ADA_MismatMH_NHSNo
		FROM mrr.ADA_Patient a
			LEFT JOIN NewAddress a_adrs
				ON a_adrs.AddressRef = a.AddressRef
		 -- LEFT JOIN ADA_latestCase123 tmp
			--ON a.PatientRef = tmp.PatientRef
		WHERE a.Surname NOT LIKE '%XX%TEST%'
		AND a.Surname NOT LIKE '%DO%NOT%USE%'
		AND LEN(a.NationalCode) = 10


		CREATE NONCLUSTERED INDEX idx_tmpMPI_ADA_MismatMH_NHSNo_Matching_ID ON tmpMPI_ADA_MismatMH_NHSNo(Matching_ID)
		CREATE NONCLUSTERED INDEX idx_tmpMPI_ADA_MismatMH_NHSNo_NHS_Number ON tmpMPI_ADA_MismatMH_NHSNo(NHS_Number)


		INSERT INTO [dbo].[tblADA_CNS_DQ_Issues_MismatMH_NHSNumber]
		SELECT CNS.Matching_ID 
			, CNS.Patient_ID	AS MH_Patient_ID
			, CNS.Forename		MH_Forename
			, CNS.Surname		MH_Surname
			, CNS.Date_Of_Birth MH_DOB
			, CNS.NHS_Number	 MH_NHS_Number
			--, CNS.Gender_ID		MH_Gender_ID 
			, CNS.Postcode	MH_postcode
			, CNS.Address1  MH_Address1
			, CNS.Tel_Home   MH_Tel_Home
			, CNS.Tel_Mobile   MH_Tel_Mobile
			, CNS.Tel_Work   MH_Tel_Work

			, Ada.Patient_ID ada_Patient_ID
			, Ada.Forename ada_Forename
			, Ada.Surname ada_Surname
			, Ada.DOB ada_DOB
			, Ada.NHS_Number ada_NHS_Number
			--, Ada.Sex ada_Gender_ID
			, ada.Address1   AS  ada_Address
			, ada.Postcode  AS   ada_Postcode
			, Ada.Tel_Home  AS  ada_HomePhone
			, Ada.Tel_Mobile  AS   ada_Mobile
			, ada.Tel_Other

			, CASE WHEN ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Home  COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Mobile		 COLLATE  Latin1_General_CI_AS OR ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Other	 COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END HomePhone_Matching 
			, CASE WHEN ISNULL(CNS.Tel_Mobile,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Mobile,'yy')  =  ada.Tel_Mobile  COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Mobile,'yy')  = ada.Tel_Other  COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END MobilePhone_Matching 
			, CASE WHEN ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Mobile	 COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Other	 COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END WorkPhone_Matching 

			, CASE WHEN ISNULL(CNS.Address1,'yy')  = ada.Address1 COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE '' END Address_Matching
			, CASE WHEN ISNULL(CNS.Postcode,'yy') = ada.Postcode COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE '' END PostCode_Matching
			--, CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CNS.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = ada.Practice_Code  THEN 'Matching' ELSE '' END Practice_Matching
		--
		FROM tmpMPI_MH_MismatMH_NHSNo  CNS
		LEFT JOIN tmpMPI_ADA_MismatMH_NHSNo Ada 
		ON CNS.Matching_ID = ada.Matching_ID  COLLATE  Latin1_General_CI_AS
		WHERE  CNS.NHS_Number <> ada.NHS_Number COLLATE  Latin1_General_CI_AS
		AND 
				(
					CASE WHEN ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Home	COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Mobile	COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Home,'yy')  = ada.Tel_Other	COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'

					OR
            
					CASE WHEN ISNULL(CNS.Tel_Mobile,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Mobile,'yy')  =  ada.Tel_Mobile COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Mobile,'yy')  = ada.Tel_Other COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
					OR
			
					CASE WHEN ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Home	COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Mobile	COLLATE  Latin1_General_CI_AS	OR ISNULL(CNS.Tel_Work,'yy')  = ada.Tel_Other	COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
					OR
			
					CASE WHEN ISNULL(CNS.Address1,'yy')  = ada.Address1 COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
					OR
			
					CASE WHEN ISNULL(CNS.Postcode,'yy')  = ada.Postcode COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
					--OR
					--CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CNS.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = ada.Practice_Code  THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'
				)

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


IF OBJECT_ID('dbo.tmpMPI_MH_MismatMH_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_MH_MismatMH_NHSNo 


IF OBJECT_ID('dbo.tmpMPI_ADA_MismatMH_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_ADA_MismatMH_NHSNo 


GO
