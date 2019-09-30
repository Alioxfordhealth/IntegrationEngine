USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwCPAEpisode]    Script Date: 30/07/2019 13:05:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [Graphnet].[vwCPAEpisode]
AS
WITH DeDuplicate_CPA_Disch AS
(
	SELECT dis.CPA_Start_ID, dis.CPA_Discharge_Date, dis.Updated_Dttm, ROW_NUMBER() OVER(PARTITION BY dis.CPA_Start_ID ORDER BY dis.Updated_Dttm desc) RN
	FROM mrr.CNS_tblCPADischarge dis
	    INNER JOIN Graphnet.vwInscopePatient                     scope
        ON dis.Patient_ID = scope.PatientNo
)
SELECT REPLACE(CAST(strt.CPA_Start_ID AS VARCHAR(20)), '|', '')                               AS CPAEpisodeID
     , REPLACE(CAST(strt.Patient_ID AS VARCHAR(20)), '|', '')                                 AS PatientID
     , 125                                                                                    AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (strt.Updated_Dttm)
                         , (dis.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )                                                                               AS UpdatedDate
     , CONVERT(VARCHAR(23), strt.Start_Date, 21)                                              AS [StartDate]
     , CONVERT(VARCHAR(23), IIF(InvcnStrt.CN_Doc_ID IS NULL, dis.CPA_Discharge_Date, ''), 21) AS EndDate
     , REPLACE(cnStrt.ViewText, '|', '')                                                      AS Details
     , IIF(InvcnStrt.CN_Doc_ID IS NULL, 0, 1)                                                 AS Deleted
FROM mrr.CNS_tblCPAStart                      strt
    --LEFT JOIN mrr.CNS_tblCPADischarge         dis
    --    ON dis.CPA_Start_ID = strt.CPA_Start_ID
    LEFT JOIN DeDuplicate_CPA_Disch         dis
        ON dis.CPA_Start_ID = strt.CPA_Start_ID
		AND dis.RN = 1
    INNER JOIN Graphnet.vwInscopePatient                     scope
        ON strt.Patient_ID = scope.PatientNo
    LEFT JOIN mrr.CNS_tblCNDocument           cnStrt
        ON strt.CPA_Start_ID = cnStrt.CN_Object_ID
           AND cnStrt.Object_Type_ID = 42
    LEFT JOIN mrr.CNS_tblCNDocument           cnDis
        ON strt.CPA_Start_ID = cnDis.CN_Object_ID
           AND cnStrt.Object_Type_ID = 40
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments InvcnDis
        ON cnDis.CN_Doc_ID = InvcnDis.CN_Doc_ID
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments InvcnStrt
        ON cnStrt.CN_Doc_ID = InvcnStrt.CN_Doc_ID
WHERE strt.Start_Date IS NOT NULL;


GO


