SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW dbo.vwCNS_DBSExtract 

AS

WITH Adrs1 AS
		(
		SELECT Patient_ID, Post_Code,ROW_NUMBER() OVER(PARTITION BY Patient_ID ORDER BY Start_Date desc) rn
		 FROM Mirror.mrr.CNS_tbladdress 
		 WHERE Address_Type_ID = 0
		 AND End_Date IS NULL
		)
		, Adrs2 AS 
		(

		SELECT Patient_ID, Post_Code,ROW_NUMBER() OVER(PARTITION BY Patient_ID ORDER BY Start_Date desc) rn
		 FROM Mirror.mrr.CNS_tbladdress 
		 WHERE End_Date IS NULL
		 AND Address_Type_ID = 1

		)
		SELECT   10 AS RecordType
			, pat.Patient_ID
			, ISNULL(CONVERT(VARCHAR,pat.date_of_Birth,112),'') AS DOB
			, ISNULL(CONVERT(VARCHAR,pat.Date_Of_Death,112),'') AS DOD
			, '' AS OldNHSNumber
			, ISNULL(NHS_Number,'') NHS_Number
			, LTRIM(RTRIM(REPLACE(CASE WHEN pat.Surname LIKE '%,%' THEN SUBSTRING(pat.Surname,0,CHARINDEX(',',pat.Surname)) 
						   WHEN pat.Surname LIKE '%(%' THEN SUBSTRING(pat.Surname,0,CHARINDEX('(',pat.Surname)) 
							ELSE pat.Surname 
					  END,'"',''))) AS Surname
			, ISNULL(LTRIM(RTRIM(REPLACE(CASE WHEN pat.Surname LIKE '%,%' THEN SUBSTRING(pat.Surname,CHARINDEX(',',pat.Surname)+1,50) END,'"',''))),'') AS AltSurname
			, LTRIM(RTRIM(REPLACE(CASE WHEN pat.Forename LIKE '%,%' THEN SUBSTRING(pat.Forename,0,CHARINDEX(',',pat.Forename)) 
						   WHEN pat.Forename LIKE '%(%' THEN SUBSTRING(pat.Forename,0,CHARINDEX('(',pat.Forename)) 
							ELSE pat.Forename 
					  END,'"','')))  AS Forename
			, '' AS AltForename
			, CASE WHEN pat.Gender_ID = 2 THEN '2'
					WHEN pat.Gender_ID = 3 THEN '1'
					WHEN pat.Gender_ID = 1 THEN '9'
					ELSE '0'
			  END   AS Gender
			, ''  AS Address1
			, ''  AS Address2
			, ''  AS Address3
			, ''  AS Address4
			, ''  AS Address5
			, LTRIM(RTRIM(REPLACE(COALESCE(adrs1.Post_Code,adrs2.Post_Code,''),'  ',' '))) AS Postcode

		FROM Mirror.mrr.CNS_tblPatient pat
		LEFT JOIN adrs1
			ON pat.Patient_ID = adrs1.Patient_ID
			AND adrs1.rn = 1
		LEFT JOIN adrs2
			ON pat.Patient_ID = adrs2.Patient_ID
			AND adrs2.rn = 1
GO
