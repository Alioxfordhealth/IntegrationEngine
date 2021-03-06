SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_MPI_ADA_PatientMatching]
(
   @patid UNIQUEIDENTIFIER		--   = 250318
,  @matchid VARCHAR(50)	--   = 'A240-D450-19 Nov 2005'
, @nhsno VARCHAR(15)	--   = ''
, @pc VARCHAR(20)		--   = 'OX38QJ'
, @Adrs  VARCHAR(20)	--   = '38MasonsRoad'
, @Home VARCHAR(20)		--   = ''
, @mobile VARCHAR(20)	--   = ''
, @TelOther VARCHAR(20)		--   = ''
, @Prac VARCHAR(20)		--   = 'K84044'
)
AS 


BEGIN TRY

	BEGIN TRANSACTION;

		INSERT INTO  [dbo].[tblADA_DQ_Issues_DuplicatedPatients]
		SELECT a.Matching_ID 
				, @patid	Patient_ID1
				, a.Patient_ID Patient_ID2
				, @nhsno	P1_NHS_Number
				, a.NHS_Number	P2_NHS_Number
				, Postcode	Postcode
				, a.Address1 
				, a.Practice_Code 
				, CASE WHEN ISNULL(a.Tel_Home,'yy')  = @Home	OR ISNULL(a.Tel_Home,'yy')  = @mobile		OR ISNULL( a.Tel_Home,'yy')  = @TelOther		THEN 'Matching' ELSE '' END HomePhone_Matching 
				, CASE WHEN ISNULL(a.Tel_Mobile,'yy')  = @Home	OR ISNULL(a.Tel_Mobile,'yy')  =  @mobile 	OR ISNULL(a.Tel_Mobile,'yy')  = @TelOther 	THEN 'Matching' ELSE '' END MobilePhone_Matching 
				, CASE WHEN ISNULL(a.Tel_Other,'yy')  = @Home	OR ISNULL(a.Tel_Other,'yy')  = @mobile		OR ISNULL(a.Tel_Other,'yy')  = @TelOther		THEN 'Matching' ELSE '' END WorkPhone_Matching 

				, CASE WHEN ISNULL(a.Address1,'yy')  = @Adrs THEN 'Matching' ELSE '' END Address_Matching
				, CASE WHEN ISNULL(a.Postcode,'yy') = @pc THEN 'Matching' ELSE '' END PostCode_Matching
				, CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(a.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = @Prac  THEN 'Matching' ELSE '' END Practice_Matching

				FROM dbo.tmpMPICursorADA_Matchpatient a
				WHERE a.Matching_ID = @matchid 
				AND a.Patient_ID <> @patid
				AND  NOT EXISTS (SELECT 1 FROM [dbo].[tblADA_DQ_Issues_DuplicatedPatients] b WHERE b.Patient_ID2 = @patid)
				AND 
				(
					CASE WHEN ISNULL(a.Tel_Home,'yy')  = @Home		OR ISNULL(a.Tel_Home,'yy')  = @mobile		OR ISNULL(a.Tel_Home,'yy')  = @TelOther		THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'

					OR
            
					CASE WHEN ISNULL(a.Tel_Mobile,'yy')  = @Home	OR ISNULL(a.Tel_Mobile,'yy')  =  @mobile 	OR ISNULL(a.Tel_Mobile,'yy')  = @TelOther 	THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
					OR
			
					CASE WHEN ISNULL(a.Tel_Other,'yy')  = @Home		OR ISNULL(a.Tel_Other,'yy')  = @mobile		OR ISNULL(a.Tel_Other,'yy')  = @TelOther		THEN 'Matching' ELSE 'NOT Matching' END  = 'Matching'
			
					OR
			
					CASE WHEN ISNULL(a.Address1,'yy')  = @Adrs THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
					OR
			
					CASE WHEN ISNULL(a.Postcode,'yy')  = @pc THEN 'Matching' ELSE 'NOT Matching' END ='Matching'
					OR
			
					CASE WHEN ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(a.Practice_Code,' ',''),'-',''),'V81999','yy'),'999','yy'),'V81998','yy'),'yy') = @Prac  THEN 'Matching' ELSE 'NOT Matching' END = 'Matching'
		
		
				)


	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
