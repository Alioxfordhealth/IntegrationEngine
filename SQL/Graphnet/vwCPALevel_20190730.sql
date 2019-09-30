USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwCPALevel]    Script Date: 30/07/2019 13:06:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









alter VIEW [Graphnet].[vwCPALevel]
AS
WITH CPA AS 
	(
	SELECT cpas_cnD.CN_Doc_ID, cpas.Patient_ID,  cpas.CPA_Start_ID, IIF(cpas_id.CN_Doc_ID IS NULL, 0, 1) AS Deleted,  MAX(cpar.CPA_Review_ID) AS CPA_Review_ID
	FROM mrr.CNS_tblCPAStart   cpas
	LEFT JOIN mrr.CNS_tblCPAReview  cpar
		ON cpas.CPA_Start_ID = cpar.CPA_Start_ID
	INNER JOIN [Graphnet_Config].[InscopePatient] scope
		ON scope.PatientNo = cpas.Patient_ID
	INNER JOIN mrr.CNS_tblCNDocument                cpas_cnD
        ON cpas.CPA_Start_ID = cpas_cnD.CN_Object_ID
    INNER JOIN mrr.CNS_tblObjectTypeValues          cpas_ot
        ON cpas_ot.Object_Type_ID = cpas_cnD.Object_Type_ID
        AND cpas_ot.Key_Table_Name = 'tblCPAStart'
    LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments cpas_id
        ON cpas_id.CN_Doc_ID = cpas_cnD.CN_Doc_ID

	LEFT JOIN mrr.CNS_tblCNDocument                cpar_cnD
        ON cpar.CPA_Review_ID = cpar_cnD.CN_Object_ID
    LEFT JOIN mrr.CNS_tblObjectTypeValues          cpar_ot
        ON cpar_ot.Object_Type_ID = cpar_cnD.Object_Type_ID
        AND cpar_ot.Key_Table_Name = 'tblCPAReview'
    LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments cpar_id
        ON cpar_id.CN_Doc_ID = cpar_cnD.CN_Doc_ID
		AND cpar_id.CN_Doc_ID IS NULL

	GROUP BY cpas_cnD.CN_Doc_ID, cpas.Patient_ID,  cpas.CPA_Start_ID ,IIF(cpas_id.CN_Doc_ID IS NULL, 0, 1)
)

, main_query as 

(
	
SELECT DISTINCT  
	   REPLACE(LEFT(cpa.CN_Doc_ID, 20), '|', '')     AS CPAID
     , REPLACE(LEFT(cpa.Patient_ID, 20), '|', '')    AS PatientID
     , 125                                           AS TenancyID
	 , IIF(cpas.User_Updated = 'Data Migration', cpas.Start_Date, cpas.Updated_Dttm) AS UpdatedDate
     --, CONVERT(VARCHAR(23), COALESCE(cpar.Act_Date + cpar.Act_Start_Time, cpar.Updated_Dttm, cpas.Updated_Dttm), 21)     AS UpdatedDate
     , REPLACE(LEFT(COALESCE(cpar_tv.CPA_Tier_Desc, cpas_tv.CPA_Tier_Desc) , 500), '|', '') AS CPALevel
	 , CONVERT(VARCHAR(23), Next_Meeting_Date, 21)  AS NextDateOfReview 
     --, CONVERT(VARCHAR(23), COALESCE(cpar.Act_Date+ cpar.Act_Start_Time, cpar.Sch_Date + cpar.Sch_Start_Time), 21)  AS NextDateOfReview
     , cpa.Deleted
	 --, cpas.Start_Date								AS StartDate
	 -- TK 30/07/19 added 
	 , ROW_NUMBER() over (partition by cpa.Patient_ID order by cpas.Start_Date desc) as [RecordNo] 
FROM CPA
	LEFT JOIN mrr.CNS_tblCPAStart   cpas
		ON cpa.CPA_Start_ID = cpas.CPA_Start_ID
	LEFT JOIN mrr.CNS_tblCPAReview  cpar
		ON cpa.CPA_Review_ID = cpar.CPA_Review_ID
	LEFT JOIN mrr.CNS_tblCPATierValues cpas_tv
        ON cpas_tv.CPA_Tier_ID = cpas.CPA_Tier_ID	
	LEFT JOIN mrr.CNS_tblCPATierValues cpar_tv
        ON cpar_tv.CPA_Tier_ID = cpar.New_Level_ID
 )
  -- TK 30/07/19 added
 select [CPAID]
		, [PatientID]
		, [TenancyID]
		, [UpdatedDate]
		, [CPALevel]
		, [NextDateOfReview]
		, [Deleted]
 from main_query 
 where RecordNo = 1
  --- OLD CODE -- 20190219
 /*
WITH cpa
AS (
   SELECT CAST(cn.CN_Doc_ID AS VARCHAR(20))                                             AS CPAID
        , cpas.Patient_ID
        , cpas.CPA_Tier_ID
        , IIF(cpas.User_Updated = 'Data Migration', cpas.Start_Date, cpas.Updated_Dttm) AS UpdatedDate
        , CAST(NULL AS DATETIME2)                                                       AS NextReviewDate
        , IIF(id.CN_Doc_ID IS NULL, 0, 1)                                               AS Deleted
   FROM mrr.CNS_tblCPAStart                            cpas
       INNER JOIN mrr.CNS_tblCNDocument                cn
           ON cpas.CPA_Start_ID = cn.CN_Object_ID
       INNER JOIN mrr.CNS_tblObjectTypeValues          ot
           ON ot.Object_Type_ID = cn.Object_Type_ID
              AND ot.Key_Table_Name = 'tblCPAStart'
       LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments id
           ON id.CN_Doc_ID = cn.CN_Doc_ID
   UNION ALL
   SELECT CAST(cn.CN_Doc_ID AS VARCHAR(20))                                           AS CPAID
        , cpar.Patient_ID
        , cpar.New_Level_ID
        , IIF(cpar.User_Updated = 'Data Migration', cpar.Act_Date, cpar.Updated_Dttm) AS UpdatedDate
        , cpar.Next_Meeting_Date
        , IIF(id.CN_Doc_ID IS NULL, 0, 1)                                             AS Deleted
   FROM mrr.CNS_tblCPAReview                           cpar
       INNER JOIN mrr.CNS_tblCNDocument                cn
           ON cpar.CPA_Review_ID = cn.CN_Object_ID
       INNER JOIN mrr.CNS_tblObjectTypeValues          ot
           ON ot.Object_Type_ID = cn.Object_Type_ID
              AND ot.Key_Table_Name = 'tblCPAReview'
       LEFT OUTER JOIN mrr.CNS_tblInvalidatedDocuments id
           ON id.CN_Doc_ID = cn.CN_Doc_ID
   WHERE cpar.New_Level_ID IS NOT NULL)
SELECT REPLACE(LEFT(cpa.CPAID, 20), '|', '')         AS CPAID
     , REPLACE(LEFT(cpa.Patient_ID, 20), '|', '')    AS PatientID
     , 125                                           AS TenancyID
     , CONVERT(VARCHAR(23), cpa.UpdatedDate, 21)     AS UpdatedDate
     , REPLACE(LEFT(tv.CPA_Tier_Desc, 500), '|', '') AS CPALevel
     , CONVERT(VARCHAR(23), cpa.NextReviewDate, 21)  AS NextDateOfReview
     , cpa.Deleted
FROM Graphnet.vwInscopePatient                         scope
    INNER JOIN cpa
        ON scope.PatientNo = cpa.Patient_ID
    INNER JOIN mrr.CNS_tblCPATierValues tv
        ON tv.CPA_Tier_ID = cpa.CPA_Tier_ID;
	*/		

GO


