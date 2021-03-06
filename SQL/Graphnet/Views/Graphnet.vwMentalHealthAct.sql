SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





/*


Change Logs:
28-Nov-2018 FS added time to all date columns

*/


CREATE VIEW [Graphnet].[vwMentalHealthAct]
AS
SELECT DISTINCT
       CAST([MHA_Section_ID] AS VARCHAR(18)) + '-' + CAST(ROW_NUMBER() OVER (PARTITION BY [MHA_Section_ID] ORDER BY mha.[Start_Date] DESC) AS VARCHAR(3)) AS MHAID
     , REPLACE(CAST(mha.[Patient_ID] AS VARCHAR(20)), '|', '')                                                                                            AS PatientID
     , 125                                                                                                                                                AS TenancyID
     , CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (mha.Updated_Dttm)
                         , (def.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )																				AS UpdatedDate
     , REPLACE(def.MHA_Section_Definition_Desc, '|', '')                                    AS MHASection
     , CONVERT(VARCHAR(23), mha.[Start_Date] + mha.Start_Time, 21)							AS SectionStartDate
     , CONVERT(VARCHAR(23), mha.[End_Date] + mha.End_Time, 21)								AS SectionEndDate
     , NULL /*CONVERT(VARCHAR(23), ab.Actual_Start_Date + ab.Actual_Start_Time, 21)*/		AS LeaveStartDate
     , NULL /*CONVERT(VARCHAR(23), ab.Actual_End_Date + ab.Actual_End_Time, 21)	*/			AS LeaveEndDate
     , NULL /*REPLACE(stts.Absence_Status_Desc, '|', '')*/									AS LeaveStatus
     , IIF(InvcnDoc.CN_Doc_ID IS NULL, 0, 1)												AS Deleted
FROM mrr.CNS_tblMHASection                                                    mha
    INNER JOIN Graphnet.[Graphnet_Config].[InscopePatient]                                   scope
        ON mha.Patient_ID = scope.PatientNo
    LEFT JOIN mrr.CNS_tblMHASectionDefinition                                 def
        ON mha.[MHA_Section_Definition_ID] = def.[MHA_Section_Definition_ID]
    LEFT JOIN mrr.CNS_tblCNDocument                                           cnDoc
        ON cnDoc.CN_Object_ID = mha.MHA_Section_ID
           AND cnDoc.Object_Type_ID = 83
    LEFT JOIN mrr.CNS_tblInvalidatedDocuments                                 InvcnDoc
        ON cnDoc.CN_Doc_ID = InvcnDoc.CN_Doc_ID
    --LEFT JOIN mrr.CNS_tblAbsence                                              ab
    --    ON ab.Patient_ID = scope.PatientNo
    --       AND ab.Actual_Start_Date >= mha.Start_Date
    --       AND ab.Actual_End_Date <= mha.End_Date
    --LEFT JOIN mrr.CNS_tblAbsenceStatusValues stts
    --    ON ab.Absence_Status_ID = stts.Absence_Status_ID;
WHERE (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (mha.Updated_Dttm)
                         , (def.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               ) >= DATEADD(YEAR, -2, GETDATE()) ; -- two years

GO
