SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [Graphnet].[vwRiskAssessment_HistoricalData]
AS


SELECT 'O' + CAST(OHFTGENRiskAssessment_ID AS VARCHAR(10))  AS 'RiskAssessmentID'
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
                          risk.StartDate 
                  END
                , 21
              )						AS 'DateOfAssessment'
     , NULL							AS 'ClinicalSetting'
     --, Confirm_Staff_Name         AS 'Assessor'
     , stf.Staff_Name				AS 'Assessor'
     , CONVERT(VARCHAR(200),sjr.Staff_Job_Role_Code_Desc)						AS 'Role'
     , CASE
           WHEN InvalidDoc.CN_Doc_ID IS NULL THEN
               0
           ELSE
               1
       END                        AS 'Deleted'
FROM Graphnet.vwInscopePatient                                   AS scope
    INNER JOIN [mrr].[CNS_udfOHFTGENRiskAssessment] AS risk
        ON scope.PatientNo = risk.Patient_ID
	LEFT JOIN mrr.CNS_tblStaff stf 
		ON stf.Staff_ID = risk.OriginalAuthorID
	LEFT JOIN [mrr].[CNS_tblStaffJobRoleCodeValues] sjr
		ON sjr.Staff_Job_Role_Code_ID = stf.Job_Role_Code_ID
	LEFT JOIN mrr.CNS_tblCNDocument                     CNDoc
		ON risk.OHFTGENRiskAssessment_ID = CNDoc.CN_Object_ID
    INNER JOIN mrr.CNS_tblObjectTypeValues     ObjTyp
        ON ObjTyp.Object_Type_ID = CNDoc.Object_Type_ID
		AND ObjTyp.Key_Table_Name = 'udfOHFTGENRiskAssessment'
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments InvalidDoc
        ON InvalidDoc.CN_Doc_ID = CNDoc.CN_Doc_ID


GO
