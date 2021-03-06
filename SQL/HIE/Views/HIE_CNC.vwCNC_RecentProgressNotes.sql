SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





/*==========================================================================================================================================
Gather data for clinical notes. This query is problematic, with slow performance. may need further work.

History:
22/06/2018 OBMH\Steve.Nicoll  Initial version based on Nik's code.
28/11/2018 FS added ClinicCat and ClicniCType to Notes colum

==========================================================================================================================================*/
CREATE VIEW [HIE_CNC].[vwCNC_RecentProgressNotes]
AS
SELECT CAST([note].[Clinical_Note_ID] AS VARCHAR(20))                                                                     AS [SpecialNotesID]
     , CAST([note].[Patient_ID] AS VARCHAR(20))                                                                           AS [PatientID]
     , 125                                                                                                                AS [TenancyID]
     , CONVERT(VARCHAR(23), [note].[Updated_Dttm], 21)                                                                    AS [UpdatedDate]
     , NULL                                                                                                               AS [Order] -- Spec says a nullable text field - what is really wanted here?
--     , CONVERT(VARCHAR(23), [note].[Clinical_Note_Date] + note.Clinical_Note_Time, 21)                                    AS [CreateTime]
     , CONVERT(VARCHAR(23), CAST(CAST(CAST([Clinical_Note_Date] AS DATE) AS VARCHAR(10)) + ' ' +Clinical_Note_Time AS DATETIME), 21)  AS [CreateTime]
     --, REPLACE(REPLACE(REPLACE(REPLACE(CAST(CONCAT(cat.Clinical_Note_Category_Desc, ' - ' ,cnt.Clinical_Note_Type_Desc, '. ' , [note].[Clinical_Note_Text]) AS VARCHAR(5000)), '|', ''), CHAR(13), ''), CHAR(10), ''),'"','') AS [Notes]
     , REPLACE(REPLACE(CAST(CONCAT(cat.Clinical_Note_Category_Desc, ' - ' ,cnt.Clinical_Note_Type_Desc, '. ' , [note].[Clinical_Note_Text]) AS VARCHAR(5000)), '|', ''),'"','') AS [Notes]
     , IIF([cn].[CN_Object_ID] IS NULL, 0, 1)                                                                             AS [Deleted]
FROM HIE_CNC.tblCNC_InscopePatient                     [scope]
    INNER JOIN [mrr].[CNC_tblClinicalNote] [note]
        ON [note].[Patient_ID] = [scope].[PatientNo]
	LEFT JOIN mrr.CNC_tblClinicalNoteCategoryValues cat
		ON cat.Clinical_Note_Category_ID = note.Clinical_Note_Category_ID
	LEFT JOIN mrr.CNC_tblClinicalNoteTypeValues cnt
		ON cnt.Clinical_Note_Type_ID = note.Clinical_Note_Type_ID
    LEFT OUTER JOIN
    (
        SELECT [cn].[CN_Object_ID]
        FROM [mrr].[CNC_tblCNDocument]                     [cn]
            INNER JOIN [mrr].[CNC_tblObjectTypeValues]     [ot]
                ON [ot].[Object_Type_ID] = [cn].[Object_Type_ID]
            INNER JOIN [mrr].[CNC_tblInvalidatedDocuments] [id]
                ON [id].[CN_Doc_ID] = [cn].[CN_Doc_ID]
        WHERE [ot].[Key_Table_Name] = 'tblClinicalNote'
    )                                                       [cn]
        ON [cn].[CN_Object_ID] = [note].[Clinical_Note_ID]
WHERE note.Confirm_Flag_ID = 1;


GO
