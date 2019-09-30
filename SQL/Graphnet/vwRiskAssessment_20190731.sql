USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwRiskAssessment]    Script Date: 31/07/2019 12:23:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [Graphnet].[vwRiskAssessment]
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
SELECT OHFTGENRiskAssessmentv3_ID AS 'RiskAssessmentID'
     , risk.Patient_ID            AS 'PatientID'
     , 125                        AS 'TenancyID'
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(UpdatedDate)
                   FROM
                   (
                       VALUES
                           (risk.Updated_Dttm)
                   ) AS AllDates (UpdatedDate)
               )
             , 21
              )                   AS UpdatedDate
     , CONVERT(   VARCHAR(23)
                , CASE
                      WHEN StartDate IS NULL THEN
                      (
                          SELECT MAX(UpdatedDate)
                          FROM
                          (
                              VALUES
                                  (risk.Updated_Dttm)
                          ) AS AllDates (UpdatedDate)
                      )
                      ELSE
                          risk.StartDate + risk.StartTime
                  END
                , 21
              )						AS 'DateOfAssessment'
     , NULL							AS 'ClinicalSetting'
     --, Confirm_Staff_Name         AS 'Assessor'
     , stf.Staff_Name				AS 'Assessor'
     , NULL							AS 'Role'
     , CASE
           WHEN InvalidRiskAssessments.RiskAssessmentID IS NULL THEN
               0
           ELSE
               1
       END                        AS 'Deleted'
FROM Graphnet.vwInscopePatient                                   AS scope
    INNER JOIN mrr.CNS_udfOHFTGENRiskAssessmentv3 AS risk
        ON scope.PatientNo = risk.Patient_ID
    LEFT OUTER JOIN InvalidRiskAssessments
        ON InvalidRiskAssessments.RiskAssessmentID = risk.OHFTGENRiskAssessmentv3_ID
	LEFT JOIN mrr.CNS_tblStaff stf 
		ON stf.Staff_ID = risk.OriginalAuthorID
WHERE Confirm_Flag_ID = 1;


GO
