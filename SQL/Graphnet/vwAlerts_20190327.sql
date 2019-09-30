--USE [Graphnet]
--GO

--/****** Object:  View [Graphnet].[vwAlerts]    Script Date: 27/03/2019 10:32:29 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO





--/*==========================================================================================================================================
--The view to gather patient alerts needs to capture all active alerts for a patient. If there are no longer any active alerts for
--a patient but there have been in the past, we must return a single dummy alert record.
--If a patient has never had an alert they will not have any record returned here.

--IMPORTANT: When query the data in the target table for alerts, it is important to order the output by PatientNo and AlertOrder. This
--must be done in SSIS when populating the csv file.

--History:
--20/06/2018 OBMH\Steve.Nicoll  Initial version.

--==========================================================================================================================================*/

--ALTER VIEW [Graphnet].[vwAlerts]
--AS
WITH
-----------------------------------------------------------------------
-- Get invalid alerts. Are there ever any?
-----------------------------------------------------------------------
[InvalidAlerts]
AS (
   SELECT [CNDoc].[CN_Object_ID] AS [Alert_ID]
   FROM [mrr].[CNS_tblCNDocument]                     [CNDoc]
       INNER JOIN [mrr].[CNS_tblInvalidatedDocuments] [InvalidDoc]
           ON [InvalidDoc].[CN_Doc_ID] = [CNDoc].[CN_Doc_ID]
       INNER JOIN [mrr].[CNS_tblObjectTypeValues]     [ObjTyp]
           ON ([ObjTyp].[Object_Type_ID] = [CNDoc].[Object_Type_ID])
   WHERE [ObjTyp].[Key_Table_Name] = 'tblAlert')
-----------------------------------------------------------------------
-- Gather all inscope open, closed and invalid alerts.
-- TODO Most recent alerts will be at the top of the list - is that right?
-----------------------------------------------------------------------
, [CandidateAlerts]
AS (SELECT [Alert].[Patient_ID]                                                                   AS [PatientNo]
         , 125                                                                                    AS [TenancyID]
         , [Alert].[Alert_ID]
         , 'Alert'                                                                                AS [AlertCategory]
         , [Alert].[Alert_Type_ID]
         , CASE
               WHEN ISNULL([Alert].[Alert_Description], '') = '' THEN
                   CAST([Alert].[Alert_Comment] AS VARCHAR(1000))
               ELSE
                   [Alert].[Alert_Description]
           END                                                                                    AS [Comments] -- Usually Description is populated but when it is not the comments field can also contain important information.
         , [Alert].[Start_Date]                                                                   AS [StartDate]
         , [Alert].[End_Date]                                                                     AS [EndDate]
         , MAX([Alert].[Updated_Dttm]) OVER (PARTITION BY [Alert].[Patient_ID])                   [UpdatedDate]
         , CASE
               WHEN ISNULL([Alert].[End_Date], '29990101') > SYSDATETIME() -- An alert is still active if its end date is in the future.
                    AND [InvalidAlerts].[Alert_ID] IS NULL THEN
                   1
               ELSE
                   0
           END                                                                                    AS [ActiveAlert]
         , SUM(   CASE
                      WHEN ISNULL([Alert].[End_Date], '29990101') > SYSDATETIME() -- An alert is still active if its end date is in the future.
                           AND [InvalidAlerts].[Alert_ID] IS NULL THEN
                          1
                      ELSE
                          0
                  END
              ) OVER (PARTITION BY [Alert].[Patient_ID])                                          AS [ActiveAlertCount]
         , ROW_NUMBER() OVER (PARTITION BY [Alert].[Patient_ID] ORDER BY [Alert].[Alert_ID] DESC) [AlertSelector]
    FROM [Graphnet].[vwInscopePatient]                   [Inscope]
        INNER JOIN [mrr].[CNS_tblAlert] [Alert]
            ON ([Alert].[Patient_ID] = [Inscope].[PatientNo])
        LEFT OUTER JOIN [InvalidAlerts]                  [InvalidAlerts]
            ON ([InvalidAlerts].[Alert_ID] = [Alert].[Alert_ID]))
-----------------------------------------------------------------------
-- Prepare a single default alert for patients who have no open alert.
-----------------------------------------------------------------------
, [NullAlerts]
AS (SELECT [CandidateAlerts].[PatientNo]
         , [CandidateAlerts].[TenancyID]
         , [CandidateAlerts].[AlertSelector]
         , [CandidateAlerts].[AlertCategory]
         , [CandidateAlerts].[Comments]
         , [CandidateAlerts].[StartDate]
         , [CandidateAlerts].[EndDate]
         , [CandidateAlerts].[UpdatedDate]
         , [CandidateAlerts].[ActiveAlertCount]
    FROM [CandidateAlerts]
    WHERE [CandidateAlerts].[ActiveAlertCount] = 0
          AND [CandidateAlerts].[AlertSelector] = 1)
-----------------------------------------------------------------------
-- Now return all the lists of active alerts and dummy alerts where
-- patients have no active alert.
-- [AlertOrder] must be calculated here as inactive alerts are only
-- filtered out at this stage.
-----------------------------------------------------------------------
SELECT [CandidateAlerts].[PatientNo]
     , [CandidateAlerts].[TenancyID]
     , ROW_NUMBER() OVER (PARTITION BY [CandidateAlerts].[PatientNo]
                          ORDER BY [CandidateAlerts].[Alert_ID] DESC
                         )                                                   AS [AlertOrder]
     , [CandidateAlerts].[AlertCategory]
     , CAST([AlertType].[Alert_Type_ID] AS VARCHAR(100))                     AS [AlertType]
     , REPLACE(CAST([AlertType].[Alert_Type_Desc] AS VARCHAR(100)), '|', '') AS [AlertTypeDescription]
     , CAST(NULL AS VARCHAR(100))                                            AS [AlertSubType]
     , REPLACE(CAST(NULL AS VARCHAR(100)), '|', '')                          AS [AlertSubTypeDescription]
     , 'U'                                                                   AS [Severity]
     , REPLACE([CandidateAlerts].[Comments], '|', '')                        AS [Comments]
     , CONVERT(VARCHAR(23), [CandidateAlerts].[StartDate], 21)               AS StartDate
     , CONVERT(VARCHAR(23), [CandidateAlerts].[EndDate], 21)                 AS EndDate
     , CONVERT(VARCHAR(23), [CandidateAlerts].[UpdatedDate], 21)             AS UpdatedDate
FROM [CandidateAlerts]
    LEFT OUTER JOIN [mrr].[CNS_tblAlertTypeValues] [AlertType]
        ON ([AlertType].[Alert_Type_ID] = [CandidateAlerts].[Alert_Type_ID])
WHERE [CandidateAlerts].[ActiveAlertCount] > 0
      AND [CandidateAlerts].[ActiveAlert] = 1
GO


