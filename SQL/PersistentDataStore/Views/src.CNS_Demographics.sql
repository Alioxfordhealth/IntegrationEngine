SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [src].[CNS_Demographics]
AS
WITH Ad
AS (
   SELECT ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY Updated_Dttm DESC) AS rn
        , Patient_ID
        , Address1
        , Address2
        , Address3
        , Address4
        , Address5
        , Post_Code
        , Address_Type_ID
        , Updated_Dttm
   FROM mrr.CNS_tblAddress
   WHERE Address_Confidential_Flag_ID = 0)
SELECT p.Forename
     , p.Surname
     , p.Title_ID
     , p.Date_Of_Birth
     , p.NHS_Number
     , p.Gender_ID
     , a.Address1                                                                              AS Address1
     , a.Address2                                                                              AS Address2
     , a.Address3                                                                              AS Address3
     , CASE
           WHEN a.Address4 IS NULL
                AND a.Address5 IS NULL THEN
               NULL
           WHEN a.Address4 IS NULL
                AND a.Address5 IS NOT NULL THEN
               a.Address5
           WHEN a.Address4 IS NOT NULL
                AND a.Address5 IS NULL THEN
               a.Address4
           ELSE
               a.Address4 + ', ' + a.Address5
       END                                                                                     AS Address4
     , a.Post_Code                                                                             AS Postcode
     , a.Address_Type_ID                                                                       AS AddressType
     , p.Date_Of_Death
     , pr.Practice_Name                                                                        AS PracticeName
     , pr.Practice_Code                                                                        AS PracticeCode
     , gp.GP_Code                                                                              AS GPCode
     , IIF(COALESCE(gp.First_Name, '') = '', gp.Last_Name, gp.First_Name + ' ' + gp.Last_Name) AS GPName
     , NULL                                                                                    AS GPPrefix
     , lv.Language_Desc                                                                        AS PrimaryLanguage
     , msv.Marital_Status_ID
     , ev.Ethnicity_ID
     , p.Religion_ID
     , p.Create_Dttm                                                                           AS CreatedDate
     , (
           SELECT MAX(Updated_Dttm)
           FROM
           (
               VALUES
                   (p.Updated_Dttm)
                 , (gpd.Updated_Dttm)
                 , (gp.Updated_Dttm)
                 , (pr.Updated_Dttm)
                 , (a.Updated_Dttm)
           ) AS alldates (Updated_Dttm)
       )                                                                                       AS UpdatedDate
FROM mrr.CNS_tblPatient                            p
    LEFT OUTER JOIN Ad                             a
        ON a.Patient_ID = p.Patient_ID
           AND a.rn = 1
    LEFT OUTER JOIN mrr.CNS_tblGPDetail            gpd
        ON gpd.Patient_ID = p.Patient_ID
           AND gpd.End_Date IS NULL
    LEFT OUTER JOIN mrr.CNS_tblGP                  gp
        ON gp.GP_ID = gpd.GP_ID
    LEFT OUTER JOIN mrr.CNS_tblPractice            pr
        ON pr.Practice_ID = gpd.Practice_ID
    LEFT OUTER JOIN mrr.CNS_tblLanguageValues      lv
        ON lv.Language_ID = p.First_Language_ID
    LEFT OUTER JOIN mrr.CNS_tblEthnicityValues     ev
        ON ev.Ethnicity_ID = p.Ethnicity_ID
    LEFT OUTER JOIN mrr.CNS_tblMaritalStatusValues msv
        ON msv.Marital_Status_ID = p.Marital_Status_ID;



GO
