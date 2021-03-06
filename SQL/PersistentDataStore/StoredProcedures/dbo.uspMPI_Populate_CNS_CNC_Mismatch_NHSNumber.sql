SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspMPI_Populate_CNS_CNC_Mismatch_NHSNumber]

AS


IF OBJECT_ID('dbo.tmpMPI_CH_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_CH_Mismatch_NHSNo 


IF OBJECT_ID('dbo.tmpMPI_CNS_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_CNS_Mismatch_NHSNo 

BEGIN TRY

	BEGIN TRANSACTION;

			TRUNCATE TABLE [dbo].[tblCNS_CNC_DQ_Issues_Mismatch_NHSNumber]


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


			SELECT DISTINCT a.Patient_ID	Patient_ID 
			, SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Forename ,' ',''),'-',''),'''','') ,'x')) +SOUNDEX(ISNULL(REPLACE(REPLACE(REPLACE(a.Surname ,' ',''),'-',''),'''','') ,'x'))  + convert(varchar,a.Date_Of_Birth, 112) as Matching_ID
			, a.Forename
			, a.Surname
			, a.Date_Of_Birth
			, REPLACE(REPLACE(a.NHS_Number,' ',''),'-','') 	NHS_Number
			, ISNULL(REPLACE(REPLACE(a_Adrs.Post_Code,' ',''),'-',''),'yy')	Postcode
			, ISNULL(REPLACE(a_Adrs.Address1,' ',''),'yy') Address1
			, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Home,' ',''),'-',''),'yy') Tel_Home
			, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Mobile,' ',''),'-',''),'yy') Tel_Mobile
			, ISNULL(REPLACE(REPLACE(a_Adrs.Tel_Work,' ',''),'-',''),'yy') Tel_Work
			, ISNULL(aPrac.Practice_Code,'yy')  AS Practice_Code
			INTO dbo.tmpMPI_CNS_Mismatch_NHSNo
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


			CREATE NONCLUSTERED INDEX idx_tmpMPI_CNS_Mismatch_NHSNo_Matching_ID ON tmpMPI_CNS_Mismatch_NHSNo(Matching_ID)
			CREATE NONCLUSTERED INDEX idx_tmpMPI_CNS_Mismatch_NHSNo_NHS_Number ON tmpMPI_CNS_Mismatch_NHSNo(NHS_Number)


			INSERT INTO  [dbo].[tblCNS_CNC_DQ_Issues_Mismatch_NHSNumber]
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

				, CNS.Patient_ID MH_Patient_ID
				, CNS.Forename MH_Forename
				, CNS.Surname MH_Surname
				, CNS.Date_Of_Birth MH_DOB
				, CNS.NHS_Number MH_NHS_Number
				--, CNS.Sex CNS_Gender_ID
				, CNS.Address1   AS  MH_Address
				, CNS.Postcode  AS   MH_Postcode
				, CNS.Tel_Home  AS  MH_HomePhone
				, CNS.Tel_Mobile  AS   MH_Mobile
				, CNS.Tel_Work AS MH_Tel_Work

				, CASE WHEN ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Home  	OR ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Mobile		  OR ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Work	 	THEN 'Matching' ELSE '' END HomePhone_Matching 
				, CASE WHEN ISNULL(cnc.Tel_Mobile,'yy')  = CNS.Tel_Home 	OR ISNULL(cnc.Tel_Mobile,'yy')  =  CNS.Tel_Mobile  	OR ISNULL(cnc.Tel_Mobile,'yy')  = CNS.Tel_Work  	THEN 'Matching' ELSE '' END MobilePhone_Matching 
				, CASE WHEN ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Home 	OR ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Mobile	 	OR ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Work	 	THEN 'Matching' ELSE '' END WorkPhone_Matching 

				, CASE WHEN ISNULL(cnc.Address1,'yy')  = CNS.Address1  THEN 'Matching' ELSE '' END Address_Matching
				, CASE WHEN ISNULL(cnc.Postcode,'yy') = CNS.Postcode  THEN 'Matching' ELSE '' END PostCode_Matching
				--, CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cnc.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = CNS.Practice_Code  THEN 'Matching' ELSE '' END Practice_Matching
			--INTO [dbo].[tblCNS_CNC_DQ_Issues_Mismatch_NHSNumber]
			FROM tmpMPI_CH_Mismatch_NHSNo  cnc
			LEFT JOIN tmpMPI_CNS_Mismatch_NHSNo CNS 
			ON cnc.Matching_ID = CNS.Matching_ID  
			WHERE  cnc.NHS_Number <> CNS.NHS_Number 
			AND 
					(
						CASE WHEN ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Home		OR ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Mobile		OR ISNULL(cnc.Tel_Home,'yy')  = CNS.Tel_Work		THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'

						OR
            
						CASE WHEN ISNULL(cnc.Tel_Mobile,'yy')  = CNS.Tel_Home 	OR ISNULL(cnc.Tel_Mobile,'yy')  =  CNS.Tel_Mobile 	OR ISNULL(cnc.Tel_Mobile,'yy')  = CNS.Tel_Work 	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
						OR
			
						CASE WHEN ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Home		OR ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Mobile		OR ISNULL(cnc.Tel_Work,'yy')  = CNS.Tel_Work		THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
						OR
			
						CASE WHEN ISNULL(cnc.Address1,'yy')  = CNS.Address1  THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
						OR
			
						CASE WHEN ISNULL(cnc.Postcode,'yy')  = CNS.Postcode  THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
						--OR
						--CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cnc.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = CNS.Practice_Code  THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'
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


IF OBJECT_ID('dbo.tmpMPI_CNS_Mismatch_NHSNo','U') IS NOT NULL
DROP TABLE dbo.tmpMPI_CNS_Mismatch_NHSNo 

GO
