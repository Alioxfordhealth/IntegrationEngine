SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_ADA_CNC_Mismatch_NHSNumber]

AS


IF OBJECT_ID('dbo.tmpMPI_CH_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_CH_Mismatch_NHSNo 


IF OBJECT_ID('dbo.tmpMPI_ADA_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_ADA_Mismatch_NHSNo 

BEGIN TRY

	BEGIN TRANSACTION;

			TRUNCATE TABLE [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber]


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
			INTO dbo.tmpMPI_CH_Mismatch_NHSNo
			FROM mrr.CNC_tblPatient  a
				LEFT JOIN mrr.CNC_tblAddress a_adrs
					ON a_adrs.Patient_ID = a.Patient_ID
				LEFT JOIN mrr.CNC_tblGPDetail apgd
					ON a.Patient_ID = apgd.Patient_ID
				LEFT JOIN mrr.CNC_tblPractice aPrac
					ON aPrac.Practice_ID = apgd.Practice_ID
			WHERE a.Surname NOT LIKE '%XX%TEST%'
			AND a.Surname NOT LIKE '%DO%NOT%USE%'
			AND LEN(a.NHS_Number) = 10

			CREATE NONCLUSTERED INDEX idx_tmpMPI_CH_Mismatch_NHSNo_Matching_ID ON tmpMPI_CH_Mismatch_NHSNo(Matching_ID)
			CREATE NONCLUSTERED INDEX idx_tmpMPI_CH_Mismatch_NHSNo_NHS_Number ON tmpMPI_CH_Mismatch_NHSNo(NHS_Number)


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
			INTO dbo.tmpMPI_ADA_Mismatch_NHSNo
			FROM mrr.ADA_Patient a
				LEFT JOIN NewAddress a_adrs
					ON a_adrs.AddressRef = a.AddressRef
			 -- LEFT JOIN ADA_latestCase123 tmp
				--ON a.PatientRef = tmp.PatientRef
			WHERE a.Surname NOT LIKE '%XX%TEST%'
			AND a.Surname NOT LIKE '%DO%NOT%USE%'
			AND LEN(a.NationalCode) = 10


			CREATE NONCLUSTERED INDEX idx_tmpMPI_ADA_Mismatch_NHSNo_Matching_ID ON tmpMPI_ADA_Mismatch_NHSNo(Matching_ID)
			CREATE NONCLUSTERED INDEX idx_tmpMPI_ADA_Mismatch_NHSNo_NHS_Number ON tmpMPI_ADA_Mismatch_NHSNo(NHS_Number)


			INSERT INTO  [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber]
			SELECT cnc.Matching_ID 
				, cnc.Patient_ID	AS CH_Patient_ID
				, cnc.Forename		CH_Forename
				, cnc.Surname		CH_Surname
				, cnc.Date_Of_Birth CH_DOB
				, cnc.NHS_Number	 CH_NHS_Number
				--, cnc.Gender_ID		CH_Gender_ID 
				, cnc.Postcode	CH_postcode
				, cnc.Address1  CH_Address1
				, cnc.Tel_Home   CH_Tel_Home
				, cnc.Tel_Mobile   CH_Tel_Mobile
				, cnc.Tel_Work   CH_Tel_Work

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

				, CASE WHEN ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Home  COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Mobile		 COLLATE  Latin1_General_CI_AS OR ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Other	 COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END HomePhone_Matching 
				, CASE WHEN ISNULL(cnc.Tel_Mobile,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Mobile,'yy')  =  ada.Tel_Mobile  COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Mobile,'yy')  = ada.Tel_Other  COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END MobilePhone_Matching 
				, CASE WHEN ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Mobile	 COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Other	 COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE '' END WorkPhone_Matching 

				, CASE WHEN ISNULL(cnc.Address1,'yy')  = ada.Address1 COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE '' END Address_Matching
				, CASE WHEN ISNULL(cnc.Postcode,'yy') = ada.Postcode COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE '' END PostCode_Matching
				--, CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cnc.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = ada.Practice_Code  THEN 'Matching' ELSE '' END Practice_Matching
			--INTO [dbo].[tblADA_CNC_DQ_Issues_Mismatch_NHSNumber]
			FROM tmpMPI_CH_Mismatch_NHSNo  cnc
			LEFT JOIN tmpMPI_ADA_Mismatch_NHSNo Ada 
			ON cnc.Matching_ID = ada.Matching_ID  COLLATE  Latin1_General_CI_AS
			WHERE  cnc.NHS_Number <> ada.NHS_Number COLLATE  Latin1_General_CI_AS
			AND 
					(
						CASE WHEN ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Home	COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Mobile	COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Home,'yy')  = ada.Tel_Other	COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'

						OR
            
						CASE WHEN ISNULL(cnc.Tel_Mobile,'yy')  = ada.Tel_Home COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Mobile,'yy')  =  ada.Tel_Mobile COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Mobile,'yy')  = ada.Tel_Other COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
						OR
			
						CASE WHEN ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Home	COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Mobile	COLLATE  Latin1_General_CI_AS	OR ISNULL(cnc.Tel_Work,'yy')  = ada.Tel_Other	COLLATE  Latin1_General_CI_AS	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
						OR
			
						CASE WHEN ISNULL(cnc.Address1,'yy')  = ada.Address1 COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
						OR
			
						CASE WHEN ISNULL(cnc.Postcode,'yy')  = ada.Postcode COLLATE  Latin1_General_CI_AS THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
						--OR
						--CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cnc.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = ada.Practice_Code  THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'
					)


			COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


IF OBJECT_ID('dbo.tmpMPI_CH_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_CH_Mismatch_NHSNo 


IF OBJECT_ID('dbo.tmpMPI_ADA_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_ADA_Mismatch_NHSNo 

GO
