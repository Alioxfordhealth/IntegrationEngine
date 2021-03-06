SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





CREATE VIEW [src].[vwCNS_Telephone]
AS
WITH AllPatNumber
AS ---selects most recently updated patient record from address table and brings all contact numbers, excluding Tel_SMS as this is identical to tel_mobile

(
SELECT *
FROM
(
    SELECT Patient_ID
         , Main_Phone_Number_Type_ID
         , Main_Telephone_Number
         , CASE
               WHEN Tel_Home_Confidential_Flag_ID = 0 THEN
                   REPLACE(REPLACE(REPLACE(REPLACE(Tel_Home, '.', ''), ' ', ''), '(', ''), ')', '')
               ELSE
                   ''
           END                                                                    AS 'Tel_home'
         , CASE
               WHEN Tel_Mobile_Confidential_Flag_ID = 0 THEN
                   REPLACE(REPLACE(REPLACE(REPLACE(Tel_Mobile, '.', ''), ' ', ''), '(', ''), ')', '')
               ELSE
                   ''
           END                                                                    AS 'Tel_mobile'
         , CASE
               WHEN Tel_Work_Confidential_Flag_ID = 0 THEN
                   REPLACE(REPLACE(REPLACE(REPLACE(Tel_Work, '.', ''), ' ', ''), '(', ''), ')', '')
               ELSE
                   ''
           END                                                                    AS 'Tel_work'
         , Updated_Dttm
         , ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY Updated_Dttm DESC) AS RN
         , CASE
               WHEN Tel_Mobile = Main_Telephone_Number THEN
                   'mobile'
               WHEN Tel_Home = Main_Telephone_Number THEN
                   'home'
               WHEN Tel_Work = Main_Telephone_Number THEN
                   'work'
           END                                                                    AS Main --patient main contact number

    --select top 10 *
    FROM [mrr].[CNS_tblAddress]
) allno
WHERE allno.RN = 1)

, HomePatNo AS 
(SELECT ap.Patient_ID
         , NULL        AS NokContact_ID
         , ap.Tel_home AS Telephone_Number
         , 'PH'        AS PhoneTypeCode        --PH='telephone'
         , 'PRN'       AS UseCode          --PRN = PrimaryResidenceNumber'
         , 'Patient'   AS ContactRole
		 , 'Home'        AS PhoneType
         , ap.Updated_Dttm
         , CASE
               WHEN ap.Main = 'home' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag --main patient contact number = 1

    FROM AllPatNumber ap)
   , MobilePatNo
AS (SELECT ap.Patient_ID
         , NULL          AS NokContact_ID
         , ap.Tel_mobile AS Telephone_Number
         , 'CP'          AS PhoneTypeCode -- CP = Cellular Phone
         , 'PRS'         AS UseCode   -- PRS = Personal Phone
		 , 'Patient'     AS ContactRole
         , 'Mobile'        AS PhoneType
         , ap.Updated_Dttm
         , CASE
               WHEN ap.Main = 'mobile' THEN
                   1
               ELSE
                   0
           END           AS Main_Number_Flag
    FROM AllPatNumber ap)
   , WorkPatNo
AS (SELECT ap.Patient_ID
         , NULL        AS NokContact_ID
         , ap.Tel_work AS Telephone_Number
         , CASE
               WHEN ap.Tel_work LIKE '07%' THEN
                   'CP'
               ELSE
                   'PH'
           END         AS PhoneTypeCode --no way to identify in carenotes if work phone is mobile or not
         , 'WPN'       AS UseCode   -- WPN = work phone
         , 'Patient'   AS ContactRole
          , 'Work'        AS PhoneType
         , ap.Updated_Dttm
         , CASE
               WHEN ap.Main = 'work' THEN
                   1
               ELSE
                   0
           END         AS Main_Number_Flag
    FROM AllPatNumber ap)
   , AllNoKNumber
AS (SELECT *
    FROM
    (
        SELECT c.Patient_ID
             , c.Contact_ID                                                               AS NoKContact_ID
             , CASE
                   WHEN Home_Telephone_Confidential_ID = 0 THEN
                       REPLACE(REPLACE(REPLACE(REPLACE(c.Home_Telephone, '.', ''), ' ', ''), '(', ''), ')', '')
                   ELSE
                       ''
               END                                                                        AS 'Tel_home'
             , CASE
                   WHEN Mobile_Telephone_Confidential_ID = 0 THEN
                       REPLACE(REPLACE(REPLACE(REPLACE(c.Mobile_Telephone, '.', ''), ' ', ''), '(', ''), ')', '')
                   ELSE
                       ''
               END                                                                        AS 'Tel_mobile'
             , CASE
                   WHEN Work_Telephone_Confidential_ID = 0 THEN
                       REPLACE(REPLACE(REPLACE(REPLACE(c.Work_Telephone, '.', ''), ' ', ''), '(', ''), ')', '')
                   ELSE
                       ''
               END                                                                        AS 'Tel_work'
             , c.Updated_Dttm
             , ROW_NUMBER() OVER (PARTITION BY c.Contact_ID ORDER BY c.Updated_Dttm DESC) AS RN
        FROM [mrr].[CNS_tblContact]               c
            INNER JOIN [mrr].[CNS_tblContactRole] r
                ON c.Contact_ID = r.Contact_ID
                   AND r.Contact_Role_ID IN ( 25, 26 ) -- next of kin only
        WHERE c.Contact_Type_ID = 2 -- contacttype = 'contact' rather than client or GP
              AND c.Permission_To_Contact_ID IN ( 2, 0 ) -- excludes those with no permission to contact, includes those with permission and the unknowns which is the default
    ) AllNo
    WHERE AllNo.RN = 1)
   , HomeNoKNo
AS (SELECT anok.Patient_ID
         , anok.NoKContact_ID
         , anok.Tel_home AS Telephone_Number
         , 'PH'          AS PhoneTypeCode
         , 'PRN'         AS UseCode
         , 'NextOfKin'   AS ContactRole
         , 'Home'        AS PhoneType
         , anok.Updated_Dttm
         , NULL          AS Main_Flag
    FROM AllNoKNumber anok)
   , MobileNoKNo
AS (SELECT anok.Patient_ID
         , anok.NoKContact_ID
         , anok.Tel_mobile AS Telephone_Number
         , 'CP'            AS PhoneTypeCode
         , 'PRS'           AS UseCode
         , 'NextOfKin'     AS ContactRole
         , 'Mobile'        AS PhoneType
         , anok.Updated_Dttm
         , NULL            AS Main_Flag
    FROM AllNoKNumber anok)
   , WorkNoKNo
AS (SELECT anok.Patient_ID
         , anok.NoKContact_ID
         , anok.Tel_work AS Telephone_Number
         , CASE
               WHEN anok.Tel_work LIKE '07%' THEN
                   'CP'
               ELSE
                   'PH'
           END           AS PhoneTypeCode --PhoneTypeCode not specified in carenotes for work numbers
         , 'WPN'         AS UseCode
         , 'NextOfKin'   AS ContactRole
         , 'Work'        AS PhoneType
         , anok.Updated_Dttm
         , NULL          AS Main_Flag
    FROM AllNoKNumber anok)
   , AllNumbers
AS (SELECT *
    FROM HomePatNo
    UNION ALL
    SELECT *
    FROM MobilePatNo
    UNION ALL
    SELECT *
    FROM WorkPatNo
    UNION ALL
    SELECT *
    FROM HomeNoKNo
    UNION ALL
    SELECT *
    FROM MobileNoKNo
    UNION ALL
    SELECT *
    FROM WorkNoKNo)
SELECT *
FROM AllNumbers an
WHERE an.Telephone_Number IS NOT NULL
      AND an.Telephone_Number NOT LIKE '%[a-z]%'
      AND an.Telephone_Number NOT LIKE '%/%'
      AND LEFT(an.Telephone_Number, 1) = '0'
      AND LEN(an.Telephone_Number) = 11;

GO
