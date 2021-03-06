SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [src].[vwPCMISBUCKS_Telephone]
AS

WITH  HomePatNo_OXONPCMIS AS 
(
	SELECT   PatientID 
         , NULL			AS NokContact_ID
		 , LEFT(REPLACE(REPLACE(SUBSTRING(TelHome, PatIndex('%[0-9]%', TelHome), len(TelHome)),' ',''),'-',''),11) AS Telephone_Number 
         , NULL AS PhoneTypeCode 
         , 'PRN'		AS UseCode          --PRN = PrimaryResidenceNumber'
         , 'Patient'	AS ContactRole
		 , NULL AS PhoneType 
         , CASE
               WHEN ISNULL(TelHome,'') <> '' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag  
    FROM [mrr].[PCMSBCKS_PatientDetails]
	WHERE ISNULL(TelHome,'') <> ''
	AND TelHome <> '00000000000' 
	AND ISNUMERIC(LEFT(REPLACE(REPLACE(SUBSTRING(TelHome, PatIndex('%[0-9]%', TelHome), len(TelHome)),' ',''),'-',''),11)) = 1
)
, MobilePatNo_OXONPCMIS AS 
(
	SELECT PatientID
         , NULL			AS NokContact_ID
         , LEFT(REPLACE(REPLACE(SUBSTRING(TelMobile, PatIndex('%[0-9]%', TelMobile), len(TelMobile)),' ',''),'-',''),11) AS Telephone_Number
         , NULL AS PhoneTypeCode 
         , 'PRS'		AS UseCode   -- PRS = Personal Phone
		 , 'Patient'	AS ContactRole
         , NULL AS PhoneType 
         , CASE
               WHEN ISNULL(TelHome,'') = '' AND ISNULL(TelMobile,'') <> '' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag
    FROM [mrr].[PCMSBCKS_PatientDetails]
	WHERE ISNULL(TelMobile,'') <> '' 
	AND TelMobile <> '00000000000' 
	AND ISNUMERIC(LEFT(REPLACE(REPLACE(SUBSTRING(TelMobile, PatIndex('%[0-9]%', TelMobile), len(TelMobile)),' ',''),'-',''),11)) = 1
)
, WorkPatNo_OXONPCMIS AS 
(
	SELECT PatientID
         , NULL			AS NokContact_ID
         , LEFT(REPLACE(REPLACE(SUBSTRING(TelWork, PatIndex('%[0-9]%', TelWork), len(TelWork)),' ',''),'-',''),11) AS Telephone_Number
         , CASE WHEN LEFT(LTRIM(TelWork),2) = '07' THEN 'CP' ELSE 'PH' END	AS PhoneTypeCode  
         , 'WPN'		AS UseCode   
		 , 'Patient'	AS ContactRole
         , 'Work'		AS PhoneType
         , NULL         AS Main_Number_Flag
    FROM [mrr].[PCMSBCKS_PatientDetails] 
	WHERE ISNULL(TelWork,'') <> '' 
	AND TelWork <> '00000000000' 
	AND ISNUMERIC(LEFT(REPLACE(REPLACE(SUBSTRING(TelWork, PatIndex('%[0-9]%', TelWork), len(TelWork)),' ',''),'-',''),11)) = 1
)
, AllNumbers AS 
(
	SELECT PatientID
		, NokContact_ID
		, Telephone_Number
		, CASE WHEN LEFT(LTRIM(Telephone_Number),2) = '07' THEN 'CP' ELSE 'PH' END	AS PhoneTypeCode 
		, UseCode
		, ContactRole
		, CASE WHEN LEFT(LTRIM(Telephone_Number),2) = '07' THEN 'Mobile' ELSE 'Home' END AS PhoneType 
		, Main_Number_Flag
    FROM HomePatNo_OXONPCMIS

    UNION ALL

    SELECT PatientID
		, NokContact_ID
		, Telephone_Number
		, CASE WHEN LEFT(LTRIM(Telephone_Number),2) = '07' THEN 'CP' ELSE 'PH' END	AS PhoneTypeCode 
		, UseCode
		, ContactRole
		, CASE WHEN LEFT(LTRIM(Telephone_Number),2) = '07' THEN 'Mobile' ELSE 'Home' END AS PhoneType 
		, Main_Number_Flag
    FROM MobilePatNo_OXONPCMIS	

	UNION ALL

    SELECT PatientID
		, NokContact_ID
		, Telephone_Number
		, PhoneTypeCode
		, UseCode
		, ContactRole
		, PhoneType
		, Main_Number_Flag
	FROM WorkPatNo_OXONPCMIS

)
SELECT *
FROM AllNumbers an
WHERE an.Telephone_Number NOT LIKE '%[a-z]%'
      AND an.Telephone_Number NOT LIKE '%/%'
      AND LEFT(an.Telephone_Number, 1) = '0'
      AND LEN(an.Telephone_Number) = 11;

GO
