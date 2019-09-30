USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwEIP]    Script Date: 25/03/2019 10:55:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Graphnet].[vwEIP]
AS
SELECT REPLACE(CAST(EISCommonAssessmentv2_ID AS VARCHAR(20)), '|', '') AS EIPID
     , REPLACE(CAST(eip.Patient_ID AS VARCHAR(20)), '|', '')           AS PatientID
     , 125                                                             AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (EIP.Updated_Dttm)
                         , (stf.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )                                                        AS UpdatedDate
     , CASE
           WHEN eip.fldpsydate1 IS NOT NULL THEN
               1
           ELSE
               0
       END                                                             AS ActiveEIP
     , REPLACE(stf.Staff_Name, '|', '')                                AS MainContact
     , REPLACE(stf.Mobile, '|', '')                                    AS ContactNumber
     , CONVERT(VARCHAR(23), eip.StartDate + eip.StartTime, 21)                       AS EIPStartDate
     , ''                                                              AS CarePlan
     , IIF(invDoc.CN_Doc_ID IS NULL, 0, 1)                             AS Deleted
FROM mrr.CNS_udfEISCommonAssessmentv2 eip
    INNER JOIN Graphnet.[Graphnet_Config].[InscopePatient]                          scope
        ON scope.PatientNo = eip.Patient_ID
    LEFT JOIN mrr.CNS_tblStaff                                       stf
        ON eip.OriginalAuthorID = stf.Staff_ID
    LEFT JOIN mrr.CNS_tblCNDocument                                  cnDoc
        ON cnDoc.Object_Type_ID = 10
           AND eip.EISCommonAssessmentv2_ID = cnDoc.CN_Object_ID
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments                        invDoc
        ON invDoc.CN_Doc_ID = cnDoc.CN_Doc_ID
WHERE eip. [fldCAARMSID] = 0  
AND eip.Confirm_Date IS NOT NULL;



GO


