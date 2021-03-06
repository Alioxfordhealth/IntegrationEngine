SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON




CREATE VIEW [src].[vwCNC_Inpatientvisit]
AS
--not finished, still need to bring in ascribe wards and check whether using ConsultantGMCCode or professional registration entry

WITH latestwardstay AS
( SELECT * FROM(
SELECT   Ward_Stay_ID ,
         CND.Episode_ID ,
                    W.Patient_ID ,
                    W.Location_ID ,
                    L.Location_Name AS WardName ,
                    Actual_Start_Dttm AS Ward_Adm_Dttm ,
                    Actual_End_Dttm AS Ward_Dis_Dttm ,
                    W.Updated_Dttm AS Wardstay_Updated_Dttm,
					ROW_NUMBER() OVER ( PARTITION BY CND.Episode_ID,w.Patient_ID ORDER BY w.Updated_Dttm DESC ) AS RN
          FROM      OHMirror.mirror.mrr.CNC_tblWardStay AS W
                    INNER JOIN OHMirror.mirror.mrr.CNC_tblCNDocument CND 
						ON W.Ward_Stay_ID = CND.CN_Object_ID
                         AND CND.Object_Type_ID = 82 -- AND CND.ViewForm = 'Ward Stay'
                    INNER JOIN OHMirror.mirror.mrr.CNC_tblLocation AS L 
						ON W.Location_ID = L.Location_ID
          WHERE     Actual_Start_Dttm IS NOT NULL
                    AND COALESCE(Actual_End_Dttm, GETDATE()) > Actual_Start_Dttm
                    AND CAST(Actual_Start_Dttm AS DATE) <> CAST(COALESCE(W.Actual_End_Date,
                                                              GETDATE()) AS DATE)
                    AND L.Location_Name NOT LIKE '%Test%') wardstay


WHERE wardstay.RN =1),

externalMapping
    AS ( SELECT   ECM.Internal_Data_Key ,
                COALESCE(ECM.External_Code,
                            ECMDS.External_Code_Mapping_Default_Value,
                            ECMV.External_Code_Mapping_Default_Value) AS External_Code ,
                ECMDS.External_Code_Mapping_Data_Source_Key AS DataType
        FROM     OHMirror.mirror.mrr.CNC_tblExternalCodeMappingContextValues ECMV
                LEFT OUTER JOIN OHMirror.mirror.mrr.CNC_tblExternalCodeMappingDataSource ECMDS 
					ON ECMV.External_Code_Mapping_Context_ID = ECMDS.External_Code_Mapping_Context_ID
                LEFT OUTER JOIN OHMirror.mirror.mrr.CNC_tblExternalCodeMapping ECM 
					ON ECMDS.External_Code_Mapping_Data_Source_ID = ECM.External_Code_Mapping_Data_Source_ID
        WHERE    ECMV.External_Code_Mapping_Context_Key = 'MHMDS'
                AND ECMDS.External_Code_Mapping_Data_Source_Key IN ('Discharge_Method_Episode')
        )


SELECT * FROM
( SELECT e.Patient_ID
     , pc.code					AS Episode_Type -- from HL70004 PatientClass
     , ws.Location_ID			AS Ward_LocationID --to link with ascribe codes
     , at.code					AS Admission_Type
     --, sc.Consultant_GMC_Code AS Consulting_GMC_Code  ---or use professional registration entry?? 
     --, sc.Surname AS Consulting_Surname
     --, sc.Forename AS Consulting_Forename
	 , con.[GMCCode]			AS Consulting_GMC_Code
	 , con.Surname				AS Consulting_Surname
	 , con.Forename				AS Consulting_Forename
     , adm.code					AS Admit_Source --  referral source
     , e.Episode_ID
     , exmap.External_Code		AS Discharge_Method --national code for discharge method
     , dd.code					AS Discharge_Destination_ID --itk0013 codes
     , REPLACE(CONVERT(VARCHAR(8),ws.Ward_Adm_Dttm, 112)+CONVERT(VARCHAR(8),ws.Ward_Adm_Dttm, 114), ':','')   AS PV_Start
     , REPLACE(CONVERT(VARCHAR(8),ws.Ward_Dis_Dttm, 112)+CONVERT(VARCHAR(8),ws.Ward_Dis_Dttm, 114), ':','')   AS PV_End
	 , ws.Wardstay_Updated_Dttm
	 , e.Updated_Dttm AS Episode_Updated_Dttm
	 , ROW_NUMBER() OVER(PARTITION BY e.patient_ID ORDER BY e.Updated_Dttm DESC) AS RN 
	

FROM OHMirror.mirror.mrr.CNC_tblEpisode e
	LEFT JOIN	HL7v2_42_ReferenceData.dbo.tblHL70004PatientClass		pc
		ON pc.PicklistID = e.Episode_Type_ID
	LEFT JOIN	HL7v2_42_ReferenceData.dbo.tblHL70007AdmissionType		at
		ON at.picklistID = e.Episode_Priority_ID 
		AND at.sourcesystem = 'CN CH'
    LEFT JOIN OHMirror.mirror.mrr.CNC_tblGPDetail						gpd
        ON gpd.Patient_ID = e.Patient_ID
    LEFT JOIN OHMirror.mirror.mrr.CNC_tblGP								gp
        ON gp.GP_ID = e.GP_ID
        AND gpd.Start_Date <= e.Start_Date
        AND COALESCE(gpd.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(e.Discharge_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN OHMirror.mirror.mrr.CNC_tblTeamMember						tm
        ON tm.Patient_ID = e.Patient_ID
        AND tm.Team_Member_Role_ID = 0    
        AND tm.Start_Date <= CONVERT(DATE, e.Start_Date)
        AND COALESCE(tm.End_Date, CONVERT(DATE, GETDATE())) <= COALESCE(e.Discharge_Date, CONVERT(DATE, GETDATE()))
    LEFT JOIN HL7v2_42_ReferenceData.dbo.tblHL70023AdmitSource			adm
        ON adm.PicklistID = e.Referral_Source_ID 
		AND adm.sourcesystem = 'CN CH'
    LEFT JOIN OHMirror.mirror.mrr.CNC_tblStaff							sc
        ON sc.Staff_ID = tm.Staff_ID
    LEFT JOIN [ReferenceMappingTables].[dbo].[tblCareNotesAscribeConsultants] con
		ON REPLACE(ISNULL(sc.Consultant_GMC_Code, sc.Professional_Registration_Entry),'C','') = con.[GMCCode]
	LEFT JOIN externalMapping											exmap
        ON exmap.Internal_Data_Key = e.Discharge_Method_Episode_ID
    LEFT JOIN ReferenceMappingTables.dbo.tblDischargeDestination		dd
        ON dd.PicklistID = e.Discharge_Destination_ID 
		AND dd.sourcesystem = 'CNC'
    LEFT JOIN LatestWardStay											ws
        ON ws.Patient_ID = e.Patient_ID
        AND ws.Episode_ID = e.Episode_ID
	WHERE   e.Episode_Type_ID = 3 ---bringing through inpatient episodes only
	AND ISNULL(e.Discharge_Destination_ID,0)	  <> 89  /*REMOVE "ENTERED IN ERROR"*/
	AND ISNULL(e.Referral_Closure_Reason_ID,0)  <> 10  /*REMOVE "ENTERED IN ERROR"*/
	AND ISNULL(e.Discharge_Method_Episode_ID,0) <> 43  /*REMOVE "ENTERED IN ERROR" */
		) episode
			
		WHERE episode.RN = 1
		







GO
