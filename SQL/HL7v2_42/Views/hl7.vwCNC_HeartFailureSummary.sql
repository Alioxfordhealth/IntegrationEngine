SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON






CREATE VIEW  [hl7].[vwCNC_HeartFailureSummary]
AS  



WITH EDT_Hub_ID AS 
(
	SELECT GPD.Patient_ID, COALESCE(EDTHS.Enable_EDT_Hub_ID, '0') AS Enable_EDT_Hub_ID  
	FROM mrr.CNC_tblGPDetail GPD  
	LEFT OUTER JOIN mrr.CNC_tblPracticeSLAMEDTHubSubscriber EDTHS ON EDTHS.Practice_ID = GPD.Practice_ID  
	WHERE GPD.End_Date IS NULL  
)

, Patient_Details AS 
(
	SELECT pt.Patient_ID, pt.Gender_ID, [Current_Date] = CONVERT(VARCHAR(10), GETDATE(), 103),gv.Gender_Desc AS [Gender], DATEDIFF(DAY,pt.Date_Of_Birth, GETDATE())/365 AS Age, CONVERT(VARCHAR(10),pt.Date_Of_Birth, 103) AS [DOB], REPLACE(pt.NHS_Number,' ','') AS [NHS_Number] , pt.Surname AS [Surname], pt.Forename AS [Forename]
	FROM mrr.CNC_tblPatient pt
	LEFT JOIN mrr.CNC_tblGenderValues gv ON gv.Gender_ID = pt.Gender_ID
)

,  Patient_Address AS 
(
	SELECT   address.Patient_ID, [Patient_Current_Address] = (CASE WHEN address.Address1 IS NOT NULL THEN address.Address1 ELSE '' END  +
	CASE WHEN address.Address2 IS NOT NULL THEN CHAR(13) + address.Address2 ELSE '' END +
	CASE WHEN address.Address3 IS NOT NULL THEN CHAR(13) + address.Address3 ELSE '' END +
	CASE WHEN address.Address4 IS NOT NULL THEN CHAR(13) + address.Address4 ELSE '' END +
	CASE WHEN address.Address5 IS NOT NULL THEN CHAR(13) + address.Address5 ELSE '' END +
	CASE WHEN address.Post_Code IS NOT NULL THEN CHAR(13) + address.Post_Code ELSE '' END) 
	FROM mrr.CNC_tblAddress address 
	WHERE (address.End_Date IS NULL OR address.End_Date >= GETDATE()) AND address.Usual_Address_Flag_ID=1 
)


, GPDetails AS 
(
	SELECT GP.Patient_ID, [GP_Name] = (CASE WHEN G.First_Name +' '+ G.Last_Name IS NOT NULL THEN G.First_Name +' '+ G.Last_Name ELSE 'GP Unknown' END),[GP_Address] = (CASE WHEN G.First_Name +' '+ Last_Name IS NOT NULL THEN G.First_Name +' '+ Last_Name ELSE 'GP Unknown' END  + CHAR(13) + CASE WHEN P.Address1 IS NOT NULL THEN P.Address1 ELSE '' END  +
	CASE WHEN P.Address2 IS NOT NULL THEN CHAR(13) + P.Address2 ELSE '' END +
	CASE WHEN P.Address3 IS NOT NULL THEN CHAR(13) + P.Address3 ELSE '' END +
	CASE WHEN P.Address4 IS NOT NULL THEN CHAR(13) + P.Address4 ELSE '' END +
	CASE WHEN P.Address5 IS NOT NULL THEN CHAR(13) + P.Address5 ELSE '' END +
	CASE WHEN P.Post_Code IS NOT NULL THEN CHAR(13) + P.Post_Code ELSE '' END),
	G.GP_Code, P.Practice_Code, P.Practice_Name AS Practice_Desc
	FROM mrr.CNC_tblGPDetail GP
	LEFT OUTER JOIN mrr.CNC_tblPractice P ON P.Practice_ID = GP.Practice_ID
	LEFT OUTER JOIN mrr.CNC_tblGP G ON G.GP_ID = GP.GP_ID
	WHERE End_Date IS NULL 
)


SELECT  
-- Kettering envelope details
	  CONVERT(VARCHAR(20), GETDATE(), 103) AS MsgIssueDate
	, 'CarenotesMH'				AS MsgSender
	, 'Docman'					AS MsgRecipient
	, 'NHS'						AS IdType
	, PatDet.NHS_Number			AS IdValue
	, 'CU'						AS PersonNameType
	, GPDetails.GP_Code			AS RecpHcpCode 
	, GPDetails.GP_Name			AS RecpHcpDescription
	, GPDetails.Practice_Code	AS RecpPracticeCode
	, GPDetails.Practice_Desc	AS RecpPracticeName
	, S.Consultant_GMC_Code		AS SendHCPCode
	, S.Staff_Name				AS SendHCPDesc
	, HF.fldService				AS SendDepartment
	, 'RNU'						AS OrgCode
	, 'Oxford Health'			AS OrgName
	, 'CH-'+CAST(HeartFailurev4_ID AS VARCHAR(9))AS IntegratedDocumentID
	, 'Heart Failure Report'	AS ReportType
	, CASE WHEN ISDATE(HF.StartDate) = 1 THEN CONVERT(VARCHAR(20),HF.StartDate, 103) END AS EventDate
	, CASE WHEN ISDATE(HF.StartDate) = 1 THEN CONVERT(VARCHAR(20),HF.StartDate, 103) END AS EventDateEnd
	, CONVERT(VARCHAR(20), HF.Confirm_Date, 103) AS DocCreationDate 
	, 'pdf'						AS FileExtension


 -- Report Details 
	, PatDet.Patient_ID
	, PatDet.Gender
	, PatDet.NHS_Number
	, PatDet.Surname
	, PatDet.Forename
	, CONVERT(VARCHAR(20), PatDet.DOB, 103) AS DOB
	, patDet.Gender_ID
	, PatDet.Age
	, PatAdrs.[Patient_Current_Address]  
	, GPDetails.GP_Code
	, GPDetails.Practice_Code
	, GPDetails.GP_Name
	, GPDetails.Practice_Desc
	, GPDetails.GP_Address
	, EDT_Hub_ID.Enable_EDT_Hub_ID
	, (SELECT Object_Type_ID FROM mrr.CNC_tblObjectTypeValues WHERE Object_Type_GUID = '9de326ea-96b3-4cd2-a8e7-af71745e8316' ) AS Object_Type_ID
    , CurrentDate = CONVERT(VARCHAR(10), GETDATE(), 103),
       doc.CN_Doc_ID,
       HF.HeartFailurev4_ID,
       S.Staff_Name,
       StartDate = CONVERT(VARCHAR, HF.StartDate, 103),
       EnteredDate = CONVERT(VARCHAR, HF.fldEnteredDate, 103),
       SessionType = CASE
                         WHEN HF.fldSessionTypeID = '-1' THEN
                             'No Information'
                         WHEN HF.fldSessionTypeID = '0' THEN
                             'Home Visit'
                         WHEN HF.fldSessionTypeID = '1' THEN
                             'Clinic Appointment'
                         WHEN HF.fldSessionTypeID = '2' THEN
                             'Telephone Call'
                         WHEN HF.fldSessionTypeID = '3' THEN
                             'Cardiac Rehab'
                         WHEN HF.fldSessionTypeID = '4' THEN
                             'Clinical Supervision'
                     END,
       fldPatInfo,
       DNACPR = CASE
                    WHEN HF.fldDNACPRID = '-1' THEN
                        'No Information'
                    WHEN HF.fldDNACPRID = '1' THEN
                        'Yes'
                    WHEN HF.fldDNACPRID = '0' THEN
                        'No'
                    WHEN HF.fldDNACPRID = '2' THEN
                        'Not Known'
                END,
       LVSD = CASE
                  WHEN HF.fldLVSDID = '-1' THEN
                      'No Information'
                  WHEN HF.fldLVSDID = '1' THEN
                      'Yes'
                  WHEN HF.fldLVSDID = '0' THEN
                      'No'
                  WHEN HF.fldLVSDID = '2' THEN
                      'Unknown'
              END,
       EchoFind = CONVERT(VARCHAR(10), HF.fldEjectFrac) + '%',
       EchoOut = CASE
                     WHEN HF.fldEchoOutcomesID = '-1' THEN
                         'No Information'
                     WHEN HF.fldEchoOutcomesID = '0' THEN
                         'Mild'
                     WHEN HF.fldEchoOutcomesID = '1' THEN
                         'Mild-Moderate'
                     WHEN HF.fldEchoOutcomesID = '2' THEN
                         'Moderate'
                     WHEN HF.fldEchoOutcomesID = '3' THEN
                         'Moderate-Severe'
                     WHEN HF.fldEchoOutcomesID = '4' THEN
                         'Severe'
                     WHEN HF.fldEchoOutcomesID = '5' THEN
                         'Unknown'
                 END,
       Aetiology = CASE
                       WHEN HF.fldchkIschaemicID = '1' THEN
                           'Ischaemic' + CASE
                                             WHEN HF.fldchkDCMID = '1'
                                                  OR HF.fldchkCardiomyopathyID = '1'
                                                  OR HF.fldchknonLVSDID = '1'
                                                  OR HF.fldchkValvularID = '1'
                                                  OR HF.fldchkAlchCardiomyopID = '1'
                                                  OR HF.fldchkCongHeartID = '1'
                                                  OR HF.fldchkUnknownID = '1'
                                                  OR HF.fldchkHypertenseID = '1'
                                                  OR HF.fldchkRestCardiomyopID = '1'
                                                  OR HF.fldchkInhHeartID = '1'
                                                  OR HF.fldchkOtherID = '1' THEN
                                                 ', '
                                             ELSE
                                                 ''
                                         END
                       ELSE
                           ''
                   END + CASE
                             WHEN HF.fldchkDCMID = '1' THEN
                                 'DCM' + CASE
                                             WHEN fldchkCardiomyopathyID = '1'
                                                  OR HF.fldchknonLVSDID = '1'
                                                  OR fldchkValvularID = '1'
                                                  OR fldchkAlchCardiomyopID = '1'
                                                  OR HF.fldchkCongHeartID = '1'
                                                  OR HF.fldchkUnknownID = '1'
                                                  OR HF.fldchkHypertenseID = '1'
                                                  OR HF.fldchkRestCardiomyopID = '1'
                                                  OR HF.fldchkInhHeartID = '1'
                                                  OR HF.fldchkOtherID = '1' THEN
                                                 ', '
                                             ELSE
                                                 ''
                                         END
                             ELSE
                                 ''
                         END + CASE
                                   WHEN HF.fldchkCardiomyopathyID = '1' THEN
                                       'Rate-Related Cardiomyopathy' + CASE
                                                                           WHEN fldchknonLVSDID = '1'
                                                                                OR HF.fldchkValvularID = '1'
                                                                                OR HF.fldchkAlchCardiomyopID = '1'
                                                                                OR HF.fldchkCongHeartID = '1'
                                                                                OR HF.fldchkUnknownID = '1'
                                                                                OR HF.fldchkHypertenseID = '1'
                                                                                OR HF.fldchkRestCardiomyopID = '1'
                                                                                OR HF.fldchkInhHeartID = '1'
                                                                                OR HF.fldchkOtherID = '1' THEN
                                                                               ', '
                                                                           ELSE
                                                                               ''
                                                                       END
                                   ELSE
                                       ''
                               END + CASE
                                         WHEN HF.fldchknonLVSDID = '1' THEN
                                             'Non-LVSD' + CASE
                                                              WHEN fldchkValvularID = '1'
                                                                   OR HF.fldchkAlchCardiomyopID = '1'
                                                                   OR HF.fldchkCongHeartID = '1'
                                                                   OR HF.fldchkUnknownID = '1'
                                                                   OR HF.fldchkHypertenseID = '1'
                                                                   OR HF.fldchkRestCardiomyopID = '1'
                                                                   OR HF.fldchkInhHeartID = '1'
                                                                   OR HF.fldchkOtherID = '1' THEN
                                                                  ', '
                                                              ELSE
                                                                  ''
                                                          END
                                         ELSE
                                             ''
                                     END + CASE
                                               WHEN HF.fldchkValvularID = '1' THEN
                                                   'Valvular' + CASE
                                                                    WHEN fldchkAlchCardiomyopID = '1'
                                                                         OR HF.fldchkCongHeartID = '1'
                                                                         OR HF.fldchkUnknownID = '1'
                                                                         OR HF.fldchkHypertenseID = '1'
                                                                         OR HF.fldchkRestCardiomyopID = '1'
                                                                         OR HF.fldchkInhHeartID = '1'
                                                                         OR HF.fldchkOtherID = '1' THEN
                                                                        ', '
                                                                    ELSE
                                                                        ''
                                                                END
                                               ELSE
                                                   ''
                                           END
                   + CASE
                         WHEN HF.fldchkAlchCardiomyopID = '1' THEN
                             'Alcoholic Cardiomyopathy' + CASE
                                                              WHEN fldchkCongHeartID = '1'
                                                                   OR HF.fldchkUnknownID = '1'
                                                                   OR HF.fldchkHypertenseID = '1'
                                                                   OR HF.fldchkRestCardiomyopID = '1'
                                                                   OR HF.fldchkInhHeartID = '1'
                                                                   OR HF.fldchkOtherID = '1' THEN
                                                                  ', '
                                                              ELSE
                                                                  ''
                                                          END
                         ELSE
                             ''
                     END + CASE
                               WHEN HF.fldchkCongHeartID = '1' THEN
                                   'Congenital Heart Disease' + CASE
                                                                    WHEN HF.fldchkUnknownID = '1'
                                                                         OR HF.fldchkHypertenseID = '1'
                                                                         OR HF.fldchkRestCardiomyopID = '1'
                                                                         OR HF.fldchkInhHeartID = '1'
                                                                         OR HF.fldchkOtherID = '1' THEN
                                                                        ', '
                                                                    ELSE
                                                                        ''
                                                                END
                               ELSE
                                   ''
                           END + CASE
                                     WHEN HF.fldchkUnknownID = '1' THEN
                                         'Unknown' + CASE
                                                         WHEN fldchkHypertenseID = '1'
                                                              OR HF.fldchkRestCardiomyopID = '1'
                                                              OR HF.fldchkInhHeartID = '1'
                                                              OR HF.fldchkOtherID = '1' THEN
                                                             ', '
                                                         ELSE
                                                             ''
                                                     END
                                     ELSE
                                         ''
                                 END + CASE
                                           WHEN HF.fldchkHypertenseID = '1' THEN
                                               'Hypertensive' + CASE
                                                                    WHEN HF.fldchkRestCardiomyopID = '1'
                                                                         OR HF.fldchkInhHeartID = '1'
                                                                         OR HF.fldchkOtherID = '1' THEN
                                                                        ', '
                                                                    ELSE
                                                                        ''
                                                                END
                                           ELSE
                                               ''
                                       END
                   + CASE
                         WHEN HF.fldchkRestCardiomyopID = '1' THEN
                             'Restrictive Cardiomyopathy' + CASE
                                                                WHEN HF.fldchkInhHeartID = '1'
                                                                     OR HF.fldchkOtherID = '1' THEN
                                                                    ', '
                                                                ELSE
                                                                    ''
                                                            END
                         ELSE
                             ''
                     END + CASE
                               WHEN HF.fldchkInhHeartID = '1' THEN
                                   'Inherited Heart Disease' + CASE
                                                                   WHEN HF.fldchkOtherID = '1' THEN
                                                                       ', '
                                                                   ELSE
                                                                       ''
                                                               END
                               ELSE
                                   ''
                           END + CASE
                                     WHEN HF.fldchkOtherID = '1' THEN
                                         CONVERT(VARCHAR, HF.fldAeitologyOther)
                                     ELSE
                                         ''
                                 END,
       Ischaemic = CASE
                       WHEN HF.fldIschHeartID = '-1' THEN
                           'No Information'
                       WHEN HF.fldIschHeartID = '1' THEN
                           'Yes'
                       WHEN HF.fldIschHeartID = '0' THEN
                           'No'
                       WHEN HF.fldIschHeartID = '2' THEN
                           'Unknown'
                   END,
       HF.fldIschHeartDetails,
       Valve = CASE
                   WHEN HF.fldValveDiseaseID = '-1' THEN
                       'No Information'
                   WHEN HF.fldValveDiseaseID = '1' THEN
                       'Yes'
                   WHEN HF.fldValveDiseaseID = '0' THEN
                       'No'
                   WHEN HF.fldValveDiseaseID = '2' THEN
                       'Unknown'
               END,
       HF.fldValveDiseaseDetails,
       Hypertension = CASE
                          WHEN HF.fldHypertensionID = '-1' THEN
                              'No Information'
                          WHEN HF.fldHypertensionID = '1' THEN
                              'Yes'
                          WHEN HF.fldHypertensionID = '0' THEN
                              'No'
                          WHEN HF.fldHypertensionID = '2' THEN
                              'Unknown'
                      END,
       HF.fldHypertensionDetails,
       Arrhythmia = CASE
                        WHEN HF.fldArrhythmiaID = '-1' THEN
                            'No Information'
                        WHEN HF.fldArrhythmiaID = '1' THEN
                            'Yes'
                        WHEN HF.fldArrhythmiaID = '0' THEN
                            'No'
                        WHEN HF.fldArrhythmiaID = '2' THEN
                            'Unknown'
                    END,
       HF.fldArrhythmiaDetails,
       Diabetes = CASE
                      WHEN HF.fldDiabetesID = '-1' THEN
                          'No Information'
                      WHEN HF.fldDiabetesID = '1' THEN
                          'Yes'
                      WHEN HF.fldDiabetesID = '0' THEN
                          'No'
                      WHEN HF.fldDiabetesID = '2' THEN
                          'Unknown'
                  END,
       HF.fldDiabetesDetails,
       ChronKidney = CASE
                         WHEN HF.fldChronKidDiseaseID = '-1' THEN
                             'No Information'
                         WHEN HF.fldChronKidDiseaseID = '1' THEN
                             'Yes'
                         WHEN HF.fldChronKidDiseaseID = '0' THEN
                             'No'
                         WHEN HF.fldChronKidDiseaseID = '2' THEN
                             'Unknown'
                     END,
       HF.fldChronKidDiseaseDetails,
       Asthma = CASE
                    WHEN HF.fldAsthmaID = '-1' THEN
                        'No Information'
                    WHEN HF.fldAsthmaID = '1' THEN
                        'Yes'
                    WHEN HF.fldAsthmaID = '0' THEN
                        'No'
                    WHEN HF.fldAsthmaID = '2' THEN
                        'Unknown'
                END,
       HF.fldAsthmaDetails,
       COPD = CASE
                  WHEN HF.fldCOPDID = '-1' THEN
                      'No Information'
                  WHEN HF.fldCOPDID = '1' THEN
                      'Yes'
                  WHEN HF.fldCOPDID = '0' THEN
                      'No'
                  WHEN HF.fldCOPDID = '2' THEN
                      'Unknown'
              END,
       HF.fldCOPDDetails,
       Cerebrovasc = CASE
                         WHEN HF.fldCerebroAccID = '-1' THEN
                             'No Information'
                         WHEN HF.fldCerebroAccID = '1' THEN
                             'Yes'
                         WHEN HF.fldCerebroAccID = '0' THEN
                             'No'
                         WHEN HF.fldCerebroAccID = '2' THEN
                             'Unknown'
                     END,
       HF.fldCerebroAccDetails,
       Perivasc = CASE
                      WHEN HF.fldPeriVascDiseaseID = '-1' THEN
                          'No Information'
                      WHEN HF.fldPeriVascDiseaseID = '1' THEN
                          'Yes'
                      WHEN HF.fldPeriVascDiseaseID = '0' THEN
                          'No'
                      WHEN HF.fldPeriVascDiseaseID = '2' THEN
                          'Unknown'
                  END,
       HF.fldPeriVascDiseaseDetails,
       Anaemia = CASE
                     WHEN HF.fldAnaemiaID = '-1' THEN
                         'No Information'
                     WHEN HF.fldAnaemiaID = '1' THEN
                         'Yes'
                     WHEN HF.fldAnaemiaID = '0' THEN
                         'No'
                     WHEN HF.fldAnaemiaID = '2' THEN
                         'Unknown'
                 END,
       HF.fldAnaemiaDetails,
       HF.fldOthrMedHist,
       Device = CASE
                    WHEN HF.fldDeviceID = '-1' THEN
                        'No Information'
                    WHEN HF.fldDeviceID = '0' THEN
                        'None'
                    WHEN HF.fldDeviceID = '1' THEN
                        'CRT-D (Cardiac Resynchronisation Therapy - Defibrilator'
                    WHEN HF.fldDeviceID = '2' THEN
                        'CRT-P (Cardiac Resynchronisation Therapy - Pacemaker)'
                    WHEN HF.fldDeviceID = '3' THEN
                        'ICD - (Implantable Cardiovascular Defibrilator)'
                    WHEN HF.fldDeviceID = '4' THEN
                        'PPM - (Permanent Pacemaker)'
                    WHEN HF.fldDeviceID = '5' THEN
                        'Unknown'
                    WHEN HF.fldDeviceID = '6' THEN
                        'Declined'
                    WHEN HF.fldDeviceID = '7' THEN
                        'Other'
                END,
       HF.fldDeviceDate,
       HF.fldDeviceDetails,
       CoronaryAng = CASE
                         WHEN HF.fldCoroAngioID = '-1' THEN
                             'No Information'
                         WHEN HF.fldCoroAngioID = '1' THEN
                             'Yes'
                         WHEN HF.fldCoroAngioID = '0' THEN
                             'No'
                         WHEN HF.fldCoroAngioID = '2' THEN
                             'Unknown'
                     END,
       HF.fldCoroAngioDetails,
       PCI = CASE
                 WHEN HF.fldPCIID = '-1' THEN
                     'No Information'
                 WHEN HF.fldPCIID = '1' THEN
                     'Yes'
                 WHEN HF.fldPCIID = '0' THEN
                     'No'
                 WHEN HF.fldPCIID = '2' THEN
                     'Unknown'
             END,
       HF.fldPCIDetails,
       CABG = CASE
                  WHEN HF.fldCABGID = '-1' THEN
                      'No Information'
                  WHEN HF.fldCABGID = '1' THEN
                      'Yes'
                  WHEN HF.fldCABGID = '0' THEN
                      'No'
                  WHEN HF.fldCABGID = '2' THEN
                      'Unknown'
              END,
       HF.fldCABGDetails,
       Medi1 = M1.Generic_Name,
       HF.flddose1,
       HF.fldfreq1,
       Route1 = CASE
                    WHEN HF.fldroute1ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute1ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute1ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute1ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute1ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute1ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute1ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute1ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute1ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute1ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute1ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute1ID = '10' THEN
                        'Otic'
                END,
       Pres1 = CASE
                   WHEN HF.fldprsbr1ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr1ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr1ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm1,
       Medi2 = M2.Generic_Name,
       HF.flddose2,
       HF.fldfreq2,
       Route2 = CASE
                    WHEN HF.fldroute2ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute2ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute2ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute2ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute2ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute2ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute2ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute2ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute2ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute2ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute2ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute2ID = '10' THEN
                        'Otic'
                END,
       Pres2 = CASE
                   WHEN HF.fldprsbr2ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr2ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr2ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm2,
       Medi3 = M3.Generic_Name,
       HF.flddose3,
       HF.fldfreq3,
       Route3 = CASE
                    WHEN HF.fldroute3ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute3ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute3ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute3ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute3ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute3ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute3ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute3ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute3ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute3ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute3ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute3ID = '10' THEN
                        'Otic'
                END,
       Pres3 = CASE
                   WHEN HF.fldprsbr3ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr3ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr3ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm3,
       Medi4 = M4.Generic_Name,
       HF.flddose4,
       HF.fldfreq4,
       Route4 = CASE
                    WHEN HF.fldroute4ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute4ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute4ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute4ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute4ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute4ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute4ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute4ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute4ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute4ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute4ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute4ID = '10' THEN
                        'Otic'
                END,
       Pres4 = CASE
                   WHEN HF.fldprsbr4ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr4ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr4ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm4,
       Medi5 = M5.Generic_Name,
       HF.flddose5,
       HF.fldfreq5,
       Route5 = CASE
                    WHEN HF.fldroute5ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute5ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute5ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute5ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute5ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute5ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute5ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute5ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute5ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute5ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute5ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute5ID = '10' THEN
                        'Otic'
                END,
       Pres5 = CASE
                   WHEN HF.fldprsbr5ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr5ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr5ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm5,
       Medi6 = M6.Generic_Name,
       HF.flddose6,
       HF.fldfreq6,
       Route6 = CASE
                    WHEN HF.fldroute6ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute6ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute6ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute6ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute6ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute6ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute6ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute6ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute6ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute6ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute6ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute6ID = '10' THEN
                        'Otic'
                END,
       Pres6 = CASE
                   WHEN HF.fldprsbr6ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr6ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr6ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm6,
       Medi7 = M7.Generic_Name,
       HF.flddose7,
       HF.fldfreq7,
       Route7 = CASE
                    WHEN HF.fldroute7ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute7ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute7ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute7ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute7ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute7ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute7ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute7ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute7ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute7ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute7ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute7ID = '10' THEN
                        'Otic'
                END,
       Pres7 = CASE
                   WHEN HF.fldprsbr7ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr7ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr7ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm7,
       Medi8 = M8.Generic_Name,
       HF.flddose8,
       HF.fldfreq8,
       Route8 = CASE
                    WHEN HF.fldroute8ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute8ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute8ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute8ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute8ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute8ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute8ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute8ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute8ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute8ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute8ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute8ID = '10' THEN
                        'Otic'
                END,
       Pres8 = CASE
                   WHEN HF.fldprsbr8ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr8ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr8ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm8,
       Medi9 = M9.Generic_Name,
       HF.flddose9,
       HF.fldfreq9,
       Route9 = CASE
                    WHEN HF.fldroute9ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldroute9ID = '0' THEN
                        'Oral'
                    WHEN HF.fldroute9ID = '1' THEN
                        'Intramuscular'
                    WHEN HF.fldroute9ID = '2' THEN
                        'Inhalation'
                    WHEN HF.fldroute9ID = '3' THEN
                        'Subcutaneous'
                    WHEN HF.fldroute9ID = '4' THEN
                        'Sublingual'
                    WHEN HF.fldroute9ID = '5' THEN
                        'Rectal'
                    WHEN HF.fldroute9ID = '6' THEN
                        'Topical'
                    WHEN HF.fldroute9ID = '7' THEN
                        'Intravenous'
                    WHEN HF.fldroute9ID = '8' THEN
                        'Transdermal'
                    WHEN HF.fldroute9ID = '9' THEN
                        'Ocular'
                    WHEN HF.fldroute9ID = '10' THEN
                        'Otic'
                END,
       Pres9 = CASE
                   WHEN HF.fldprsbr9ID = '-1' THEN
                       'No Information'
                   WHEN HF.fldprsbr9ID = '0' THEN
                       'OHFT'
                   WHEN HF.fldprsbr9ID = '1' THEN
                       'Other'
               END,
       HF.fldcomm9,
       Medi10 = M10.Generic_Name,
       HF.flddose10,
       HF.fldfreq10,
       Route10 = CASE
                     WHEN HF.fldroute10ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute10ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute10ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute10ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute10ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute10ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute10ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute10ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute10ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute10ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute10ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute10ID = '10' THEN
                         'Otic'
                 END,
       Pres10 = CASE
                    WHEN HF.fldprsbr10ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr10ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr10ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm10,
       Medi11 = M11.Generic_Name,
       HF.flddose11,
       HF.fldfreq11,
       Route11 = CASE
                     WHEN HF.fldroute11ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute11ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute11ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute11ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute11ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute11ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute11ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute11ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute11ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute11ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute11ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute11ID = '10' THEN
                         'Otic'
                 END,
       Pres11 = CASE
                    WHEN HF.fldprsbr11ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr11ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr11ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm11,
       Medi12 = M12.Generic_Name,
       HF.flddose12,
       HF.fldfreq12,
       Route12 = CASE
                     WHEN HF.fldroute12ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute12ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute12ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute12ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute12ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute12ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute12ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute12ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute12ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute12ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute12ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute12ID = '10' THEN
                         'Otic'
                 END,
       Pres12 = CASE
                    WHEN HF.fldprsbr12ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr12ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr12ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm12,
       Medi13 = M13.Generic_Name,
       HF.flddose13,
       HF.fldfreq13,
       Route13 = CASE
                     WHEN HF.fldroute13ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute13ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute13ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute13ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute13ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute13ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute13ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute13ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute13ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute13ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute13ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute13ID = '10' THEN
                         'Otic'
                 END,
       Pres13 = CASE
                    WHEN HF.fldprsbr13ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr13ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr13ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm13,
       Medi14 = M14.Generic_Name,
       HF.flddose14,
       HF.fldfreq14,
       Route14 = CASE
                     WHEN HF.fldroute14ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute14ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute14ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute14ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute14ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute14ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute14ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute14ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute14ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute14ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute14ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute14ID = '10' THEN
                         'Otic'
                 END,
       Pres14 = CASE
                    WHEN HF.fldprsbr14ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr14ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr14ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm14,
       Medi15 = M15.Generic_Name,
       HF.flddose15,
       HF.fldfreq15,
       Route15 = CASE
                     WHEN HF.fldroute15ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute15ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute15ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute15ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute15ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute15ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute15ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute15ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute15ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute15ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute15ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute15ID = '10' THEN
                         'Otic'
                 END,
       Pres15 = CASE
                    WHEN HF.fldprsbr15ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr15ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr15ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm15,
       Medi16 = M16.Generic_Name,
       HF.flddose16,
       HF.fldfreq16,
       Route16 = CASE
                     WHEN HF.fldroute16ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute16ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute16ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute16ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute16ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute16ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute16ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute16ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute16ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute16ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute16ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute16ID = '10' THEN
                         'Otic'
                 END,
       Pres16 = CASE
                    WHEN HF.fldprsbr16ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr16ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr16ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm16,
       Medi17 = M17.Generic_Name,
       HF.flddose17,
       HF.fldfreq17,
       Route17 = CASE
                     WHEN HF.fldroute17ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute17ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute17ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute17ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute17ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute17ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute17ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute17ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute17ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute17ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute17ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute17ID = '10' THEN
                         'Otic'
                 END,
       Pres17 = CASE
                    WHEN HF.fldprsbr17ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr17ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr17ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm17,
       Medi18 = M18.Generic_Name,
       HF.flddose18,
       HF.fldfreq18,
       Route18 = CASE
                     WHEN HF.fldroute18ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute18ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute18ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute18ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute18ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute18ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute18ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute18ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute18ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute18ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute18ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute18ID = '10' THEN
                         'Otic'
                 END,
       Pres18 = CASE
                    WHEN HF.fldprsbr18ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr18ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr18ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm18,
       Medi19 = M19.Generic_Name,
       HF.flddose19,
       HF.fldfreq19,
       Route19 = CASE
                     WHEN HF.fldroute19ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute19ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute19ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute19ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute19ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute19ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute19ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute19ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute19ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute19ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute19ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute19ID = '10' THEN
                         'Otic'
                 END,
       Pres19 = CASE
                    WHEN HF.fldprsbr19ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr19ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr19ID = '1' THEN
                        'Other'
                END,
       HF.fldcomm19,
       Medi20 = M20.Generic_Name,
       HF.flddose20,
       HF.fldfreq20,
       Route20 = CASE
                     WHEN HF.fldroute20ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute20ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute20ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute20ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute20ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute20ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute20ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute20ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute20ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute20ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute20ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute20ID = '10' THEN
                         'Otic'
                 END,
       Pres20 = CASE
                    WHEN HF.fldprsbr20ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr20ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr20ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm20
       , Medi21 = M21.Generic_Name
       , HF.flddose21
       , HF.fldfreq21
       , Route21 = CASE
                     WHEN HF.fldroute21ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute21ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute21ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute21ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute21ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute21ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute21ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute21ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute21ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute21ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute21ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute21ID = '10' THEN
                         'Otic'
                 END
       , Pres21 = CASE
                    WHEN HF.fldprsbr21ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr21ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr21ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm21
       , Medi22 = M22.Generic_Name
       , HF.flddose22
       , HF.fldfreq22
       , Route22 = CASE
                     WHEN HF.fldroute22ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute22ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute22ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute22ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute22ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute22ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute22ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute22ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute22ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute22ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute22ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute22ID = '10' THEN
                         'Otic'
                 END
       , Pres22 = CASE
                    WHEN HF.fldprsbr22ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr22ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr22ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm22
       , Medi23 = M23.Generic_Name
       , HF.flddose23
       , HF.fldfreq23
       , Route23 = CASE
                     WHEN HF.fldroute23ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute23ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute23ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute23ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute23ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute23ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute23ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute23ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute23ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute23ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute23ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute23ID = '10' THEN
                         'Otic'
                 END
       , Pres23 = CASE
                    WHEN HF.fldprsbr23ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr23ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr23ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm23
       , Medi24 = M24.Generic_Name
       , HF.flddose24
       , HF.fldfreq24
       , Route24 = CASE
                     WHEN HF.fldroute24ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute24ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute24ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute24ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute24ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute24ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute24ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute24ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute24ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute24ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute24ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute24ID = '10' THEN
                         'Otic'
                 END
       , Pres24 = CASE
                    WHEN HF.fldprsbr24ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr24ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr24ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm24
       , Medi25 = M25.Generic_Name
       , HF.flddose25
       , HF.fldfreq25
       , Route25 = CASE
                     WHEN HF.fldroute25ID = '-1' THEN
                         'No Information'
                     WHEN HF.fldroute25ID = '0' THEN
                         'Oral'
                     WHEN HF.fldroute25ID = '1' THEN
                         'Intramuscular'
                     WHEN HF.fldroute25ID = '2' THEN
                         'Inhalation'
                     WHEN HF.fldroute25ID = '3' THEN
                         'Subcutaneous'
                     WHEN HF.fldroute25ID = '4' THEN
                         'Sublingual'
                     WHEN HF.fldroute25ID = '5' THEN
                         'Rectal'
                     WHEN HF.fldroute25ID = '6' THEN
                         'Topical'
                     WHEN HF.fldroute25ID = '7' THEN
                         'Intravenous'
                     WHEN HF.fldroute25ID = '8' THEN
                         'Transdermal'
                     WHEN HF.fldroute25ID = '9' THEN
                         'Ocular'
                     WHEN HF.fldroute25ID = '10' THEN
                         'Otic'
                 END
       , Pres25 = CASE
                    WHEN HF.fldprsbr25ID = '-1' THEN
                        'No Information'
                    WHEN HF.fldprsbr25ID = '0' THEN
                        'OHFT'
                    WHEN HF.fldprsbr25ID = '1' THEN
                        'Other'
                END
       , HF.fldcomm25
       , HF.fldFutureMeds
       , HF.fldHeartFailMed
       , HF.fldOthrRelMed
       , HF.fldBreathlessness
       , HF.fldMobLimit
       , HF.fldOrthopnoea
       , HF.fldPND
       , HF.fldOedema
       , HF.fldAscites
       , HF.fldChest
       , HF.fldCough
       , HF.fldFldIntake
       , HF.fldAngina
       , HF.fldPalpitations
       , HF.fldDizziness
       , HF.fldFatigue
       , HF.fldECGFind
       , CardRehab = CASE
                       WHEN HF.fldCardiacRehabID = '0' THEN
                           'Agreed - Make Referral'
                       WHEN HF.fldCardiacRehabID = '1' THEN
                           'Currently Attending'
                       WHEN HF.fldCardiacRehabID = '2' THEN
                           'Declined'
                       WHEN HF.fldCardiacRehabID = '3' THEN
                           'Referred - On Waiting List'
                       WHEN HF.fldCardiacRehabID = '4' THEN
                           'Completed'
                       WHEN HF.fldCardiacRehabID = '5' THEN
                           'Not Discussed'
                   END
       , CBT = CASE
                 WHEN fldCBTRevID = '0' THEN
                     'Agreed - Make Referral'
                 WHEN fldCBTRevID = '1' THEN
                     'Currently Attending'
                 WHEN fldCBTRevID = '2' THEN
                     'Declined'
                 WHEN HF.fldCBTRevID = '3' THEN
                     'Referred - On Waiting List'
                 WHEN HF.fldCBTRevID = '4' THEN
                     'Completed'
                 WHEN HF.fldCBTRevID = '5' THEN
                     'Not Discussed'
             END
       , HF.fldWeight
       , HF.fldSittingBP
       , HF.fldStandingBP
       , HeartRyth = CASE
                       WHEN fldHeartRythID = '-1' THEN
                           'No Information'
                       WHEN fldHeartRythID = '0' THEN
                           'Regular'
                       WHEN fldHeartRythID = '1' THEN
                           'Irregular'
                   END
       , HF.fldPulse
       , HF.fldResp
       , HF.fldSpO2
       , HF.fldTemp
       , NewYork = CASE
                     WHEN HF.fldNYHAID = '-1' THEN
                         'No Information'
                     WHEN HF.fldNYHAID = '0' THEN
                         'I'
                     WHEN HF.fldNYHAID = '1' THEN
                         'II'
                     WHEN HF.fldNYHAID = '2' THEN
                         'III'
                     WHEN HF.fldNYHAID = '3' THEN
                         'IV'
                 END
       , HF.fldMUST
       , HF.fldBraden
       , HF.fldDetsPlanAction
	   , CAST(HF.Confirm_Date + HF.[Confirm_Time] AS DATETIME) AS Confirm_Date
FROM mrr.CNC_udfHeartFailurev4 HF
	LEFT JOIN Patient_Details PatDet
		ON HF.Patient_ID = PatDet.Patient_ID
    LEFT JOIN Patient_Address PatAdrs 
		ON PatAdrs.Patient_ID = HF.Patient_ID
	LEFT JOIN EDT_Hub_ID 
		ON EDT_Hub_ID.Patient_ID = HF.Patient_ID
	LEFT JOIN GPDetails 
		ON GPDetails.Patient_ID = HF.Patient_ID
	LEFT OUTER JOIN mrr.CNC_tblStaff S
        ON HF.OriginalAuthorID = S.Staff_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M1
        ON HF.flddrug1ID = M1.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M2
        ON HF.flddrug2ID = M2.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M3
        ON HF.flddrug3ID = M3.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M4
        ON HF.flddrug4ID = M4.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M5
        ON HF.flddrug5ID = M5.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M6
        ON HF.flddrug6ID = M6.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M7
        ON HF.flddrug7ID = M7.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M8
        ON HF.flddrug8ID = M8.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M9
        ON HF.flddrug9ID = M9.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M10
        ON HF.flddrug10ID = M10.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M11
        ON HF.flddrug11ID = M11.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M12
        ON HF.flddrug12ID = M12.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M13
        ON HF.flddrug13ID = M13.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M14
        ON HF.flddrug14ID = M14.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M15
        ON HF.flddrug15ID = M15.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M16
        ON HF.flddrug16ID = M16.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M17
        ON HF.flddrug17ID = M17.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M18
        ON HF.flddrug18ID = M18.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M19
        ON HF.flddrug19ID = M19.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M20
        ON HF.flddrug20ID = M20.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M21
        ON HF.flddrug21ID = M21.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M22
        ON HF.flddrug22ID = M22.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M23
        ON HF.flddrug23ID = M23.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M24
        ON HF.flddrug24ID = M24.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblMedicine M25
        ON HF.flddrug25ID = M25.Medicine_ID
    LEFT OUTER JOIN mrr.CNC_tblCNDocument doc
        ON doc.CN_Object_ID = HF.HeartFailurev4_ID
           AND doc.Object_Type_ID =
           (
               SELECT Object_Type_ID
               FROM mrr.CNC_tblObjectTypeValues
               WHERE Object_Type_GUID = '9de326ea-96b3-4cd2-a8e7-af71745e8316'
           )
    LEFT OUTER JOIN mrr.CNC_tblInvalidatedDocuments id
        ON id.CN_Doc_ID = doc.CN_Doc_ID
WHERE id.CN_Doc_ID IS NULL
      AND HF.Confirm_Flag_ID = '1'

--ORDER BY HF.Create_Dttm DESC XMLELEMENT=HeartFailureSummary}


 

GO
