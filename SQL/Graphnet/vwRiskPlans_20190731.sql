USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwRiskPlans]    Script Date: 31/07/2019 13:07:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








/*

Change Logs:
FS 28-Nov-2018 Added values Field1Desc and Field1Value
*/

ALTER VIEW [Graphnet].[vwRiskPlans]
AS
WITH InvalidRiskAssessments
AS (
   SELECT CNDoc.CN_Object_ID AS RiskAssessmentID
   FROM mrr.CNS_tblCNDocument                     CNDoc
       INNER JOIN mrr.CNS_tblInvalidatedDocuments InvalidDoc
           ON InvalidDoc.CN_Doc_ID = CNDoc.CN_Doc_ID
       INNER JOIN mrr.CNS_tblObjectTypeValues     ObjTyp
           ON (ObjTyp.Object_Type_ID = CNDoc.Object_Type_ID)
   WHERE ObjTyp.Key_Table_Name = 'udfOHFTGENRiskAssessmentv3')
SELECT [OHFTGENRiskAssessmentv3_ID]          AS 'RiskPlanID'
     , [OHFTGENRiskAssessmentv3_ID]          AS 'RiskAssessmentID'
     , risk.[Patient_ID]                     AS 'PatientID'
     , 125                                   AS 'TenancyID'
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX([UpdatedDate])
                   FROM
                   (
                       VALUES
                           ([risk].[Updated_Dttm])
                   ) AS [AllDates] ([UpdatedDate])
               )
             , 21
              )                              AS [UpdatedDate]
     , CONVERT(VARCHAR(23), [StartDate], 21) AS 'DateEntered'
     , 'Risk Summary'                        AS 'Field1Description'
     , REPLACE(REPLACE(REPLACE(REPLACE(CAST(risk.RiskSummary AS VARCHAR(MAX)) , CHAR(13),''), CHAR(10),''),'|',''),'"','')    AS 'Field1Value'
     , CASE
           WHEN InvalidRiskAssessments.RiskAssessmentID IS NULL THEN
               0
           ELSE
               1
       END                                   AS 'Deleted'
FROM [Graphnet].[vwInscopePatient]                                     AS scope
    INNER JOIN [mrr].[CNS_udfOHFTGENRiskAssessmentv3] AS risk
        ON scope.[PatientNo] = risk.Patient_ID
    LEFT OUTER JOIN InvalidRiskAssessments
        ON InvalidRiskAssessments.RiskAssessmentID = risk.OHFTGENRiskAssessmentv3_ID
WHERE Confirm_Flag_ID = 1

GO


