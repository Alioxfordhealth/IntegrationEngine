USE [Graphnet]
GO

/****** Object:  View [Graphnet].[vwReferrals]    Script Date: 30/09/2019 10:48:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [Graphnet].[vwReferrals]
AS

--==========================
-- NON-INPATIENT Episodes
--==========================
SELECT REPLACE(LEFT(CAST(epi.Episode_ID AS VARCHAR(20)), 20), '|', '')	AS ReferralID
     , REPLACE(LEFT(CAST(epi.Patient_ID AS VARCHAR(20)), 20), '|', '')  AS PatientID
     , 125																AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(updated_dttm)
                   FROM
                   (
                       VALUES
                           (dmsv.updated_dttm)
                         , (l.updated_dttm)
                         , (epi.updated_dttm)
                         --, (rpv.updated_dttm)
                         , (rsv.updated_dttm)
                         , (sv.updated_dttm)
                   ) AS alldates (updated_dttm)
               )
             , 21
              )															AS UpdatedDate
     --, REPLACE(LEFT(rsv.External_Code1, 2), '|', '')                  AS ReferralSource
     , LEFT(REPLACE(rsv.Referral_Source_Desc, '|', ''), 80)			AS ReferralSource
     , REPLACE(REPLACE(REPLACE(LEFT(epi.Contact_Name, 100), '|', ''), '\', ''), '/', '')                    AS Referrer
     , CAST(NULL AS VARCHAR(80))										AS RefOrgCode
     , REPLACE(LEFT(epi.Contact_Telephone, 20), '|', '')                AS ContactNumber
     , CONVERT(VARCHAR(23), epi.Referral_Date, 21)                      AS ReferralDate
     , REPLACE(ISNULL(CAST(rpv.Referral_Priority_Desc AS VARCHAR(50)), '9'), '|', '')     AS Urgency
     , REPLACE(LEFT(rrv.Referral_Reason_Desc, 80), '|', '')				AS ReferralReason
     , REPLACE(LEFT(l.Location_Name, 80), '|', '')						AS TeamReferredTo
     , NULL																AS HCPReferredTo
     , REPLACE(ISNULL(LEFT(sv.External_Code1, 3), '710'), '|', '')		AS Specialty
     , CONVERT(VARCHAR(23), epi.Referral_Received_Date, 21)             AS DateReceived
     , CAST(NULL AS VARCHAR(80))										AS CareSetting
     , CONVERT(VARCHAR(23), epi.Accepted_Date, 21)                      AS DateAccepted
     , CONVERT(VARCHAR(23), epi.Discharge_Date, 21)                     AS DischargeDate
     , CAST(NULL AS VARCHAR(100))										AS DischargeHCP
     , REPLACE(LEFT(dmsv.Discharge_Method_Episode_Desc, 100), '|', '')  AS DischargeReason
     , IIF(cn.CN_Object_ID IS NULL, 0, 1)								AS Deleted
FROM [Graphnet_Config].[InscopePatient]                   scope
    INNER JOIN mrr.CNS_tblEpisode                        epi
        ON epi.Patient_ID = scope.PatientNo
    LEFT OUTER JOIN mrr.CNS_tblReferralSourceValues       rsv
        ON rsv.Referral_Source_ID = epi.Referral_Source_ID
    LEFT OUTER JOIN mrr.CNS_tblServiceValues              sv
        ON epi.Service_ID = sv.Service_ID
    LEFT OUTER JOIN mrr.CNS_tblLocation                   l
        ON epi.Location_ID = l.Location_ID
    LEFT OUTER JOIN mrr.CNS_tblDischargeMethodEpisodeValues		dmsv
        ON epi.Discharge_Method_Episode_ID = dmsv.Discharge_Method_Episode_ID
    LEFT OUTER JOIN mrr.CNS_tblReferralPriorityValues     rpv
        ON rpv.Referral_Priority_ID = epi.Episode_Priority_ID
    LEFT OUTER JOIN mrr.CNS_tblReferralReasonValues       rrv
        ON epi.Referral_Reason_ID = rrv.Referral_Reason_ID
    LEFT OUTER JOIN
    (
        SELECT cn.CN_Object_ID
        FROM mrr.CNS_tblCNDocument                     cn
            INNER JOIN mrr.CNS_tblObjectTypeValues     ot
                ON ot.Object_Type_ID = cn.Object_Type_ID
            INNER JOIN mrr.CNS_tblInvalidatedDocuments id
                ON id.CN_Doc_ID = cn.CN_Doc_ID
        WHERE ot.Key_Table_Name = 'tblEpisode'
    )                                                                    cn
        ON cn.CN_Object_ID = epi.Episode_ID 
WHERE epi.Episode_Type_ID != 3
AND ISNULL(epi.Discharge_Destination_ID,0) <> 69  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(epi.Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(epi.Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */


UNION ALL

--==========================
-- WARS STAYS
--==========================
SELECT REPLACE(LEFT(CAST('WS'+CAST(ws.Ward_Stay_ID AS VARCHAR) AS VARCHAR(20)), 20), '|', '')	AS ReferralID
     , REPLACE(LEFT(CAST(epi.Patient_ID AS VARCHAR(20)), 20), '|', '')  AS PatientID
     , 125																AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(updated_dttm)
                   FROM
                   (
                       VALUES
                           (ws.Updated_Dttm)
                         , (l.updated_dttm)
                         , (epi.updated_dttm)
                         --, (rpv.updated_dttm)
                         , (rsv.updated_dttm)
                         , (sv.updated_dttm)
                   ) AS alldates (updated_dttm)
               )
             , 21
              )															AS UpdatedDate
     --, REPLACE(LEFT(rsv.External_Code1, 2), '|', '')                  AS ReferralSource
     , CAST(REPLACE(rsv.Referral_Source_Desc, '|', '') AS VARCHAR(80))  AS ReferralSource
     , REPLACE(LEFT(epi.Contact_Name, 100), '|', '')                    AS Referrer
     , CAST(NULL AS VARCHAR(80))										AS RefOrgCode
     , REPLACE(LEFT(epi.Contact_Telephone, 20), '|', '')                AS ContactNumber
     , CONVERT(VARCHAR(23), ws.Actual_Start_Dttm, 21)                      AS ReferralDate
     , REPLACE(ISNULL(CAST(rpv.Referral_Priority_Desc AS VARCHAR(50)), '9'), '|', '')     AS Urgency
     , REPLACE(LEFT(rrv.Referral_Reason_Desc, 80), '|', '')				AS ReferralReason
     , REPLACE(LEFT(wsLoc.Location_Name, 80), '|', '')					AS TeamReferredTo
     , NULL																AS HCPReferredTo
     , REPLACE(ISNULL(LEFT(sv.External_Code1, 3), '710'), '|', '')		AS Specialty
     , CONVERT(VARCHAR(23), ISNULL(ws.Actual_Start_Dttm,Planned_Start_Dttm), 21)					AS DateReceived
     , CAST(NULL AS VARCHAR(80))										AS CareSetting
     , CONVERT(VARCHAR(23), ws.Actual_Start_Dttm, 21)                   AS DateAccepted
     , CONVERT(VARCHAR(23), ws.Actual_End_Dttm, 21)                     AS DischargeDate  -- epi.Discharge_Date
     , CAST(NULL AS VARCHAR(100))										AS DischargeHCP
     , NULL																AS DischargeReason
     , IIF(cn.CN_Object_ID IS NULL, 0, 1)								AS Deleted
FROM [Graphnet_Config].[InscopePatient]				scope
	LEFT JOIN mrr.CNS_tblWardStay					ws 
		ON scope.PatientNo = ws.Patient_ID
	LEFT JOIN mrr.CNS_tblCNDocument					cnDoc
		ON ws.Ward_Stay_ID = cnDoc.CN_Object_ID
		AND cnDoc.Object_Type_ID = 82
    INNER JOIN mrr.CNS_tblEpisode					epi
        ON epi.Episode_ID = cnDoc.Episode_ID
		AND epi.Episode_Type_ID = 3
	LEFT JOIN mrr.CNS_tblInpatientEpisode			inp
		ON inp.Inpatient_Episode_ID = epi.Episode_ID
		AND epi.Episode_Type_ID = 3
	LEFT JOIN mrr.CNS_tblLocation					wsLoc
		ON wsLoc.Location_ID = ws.Location_ID
    LEFT OUTER JOIN mrr.CNS_tblReferralSourceValues       rsv
        ON rsv.Referral_Source_ID = epi.Referral_Source_ID
    LEFT OUTER JOIN mrr.CNS_tblServiceValues              sv
        ON epi.Service_ID = sv.Service_ID
    LEFT OUTER JOIN mrr.CNS_tblLocation                   l
        ON epi.Location_ID = l.Location_ID
    --LEFT OUTER JOIN mrr.CNS_tblDischargeMethodEpisodeValues		dmsv
    --    ON epi.Discharge_Method_Episode_ID = dmsv.Discharge_Method_Episode_ID
    LEFT OUTER JOIN mrr.CNS_tblReferralPriorityValues     rpv
        ON rpv.Referral_Priority_ID = epi.Episode_Priority_ID
    LEFT OUTER JOIN mrr.CNS_tblReferralReasonValues       rrv
        ON epi.Referral_Reason_ID = rrv.Referral_Reason_ID
    LEFT OUTER JOIN
    (
        SELECT cn.CN_Object_ID
        FROM mrr.CNS_tblCNDocument                     cn
            INNER JOIN mrr.CNS_tblObjectTypeValues     ot
                ON ot.Object_Type_ID = cn.Object_Type_ID
            INNER JOIN mrr.CNS_tblInvalidatedDocuments id
                ON id.CN_Doc_ID = cn.CN_Doc_ID
        WHERE ot.Key_Table_Name = 'tblEpisode'
    )                                                                    cn
        ON cn.CN_Object_ID = epi.Episode_ID 
WHERE ISNULL(epi.Discharge_Destination_ID,0) <> 69  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(epi.Referral_Closure_Reason_ID,0)  <> 11  /*REMOVE "ENTERED IN ERROR"*/
AND ISNULL(epi.Discharge_Method_Episode_ID,0) <> 26  /*REMOVE "ENTERED IN ERROR" */


GO


