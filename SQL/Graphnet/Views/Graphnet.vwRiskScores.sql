SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





/*==========================================================================================================================================
There is a single Risk Assesment record for a patient with all the risks and their statuses logged in separate columns.
Because of this unfortunate structure we have to UNPIVOT the data in this query and also separately bring in the text that
describes the risk being assessed.

TODO The possible risks are hard coded in this view. If new types of risk are added to the we will ignore these - so come
up with a better solution - or at least set up some sort of alert.

History:
25/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE VIEW [Graphnet].[vwRiskScores]
AS
WITH [Risks]
AS (
   SELECT [RiskScores].[RiskAssessmentID]
        , [RiskScores].[PatientID]
        , [RiskScores].[TenancyID]
        , [RiskScores].[UpdatedDate]
        , [RiskScores].[Risk]
        , [RiskScores].[RiskScore]
		, [RiskScores].[Confirm_Flag_ID]
   FROM
   (
       SELECT [OHFTGENRiskAssessmentv3_ID] [RiskAssessmentID]
            , [Patient_ID]                 [PatientID]
            , 125                          [TenancyID]
            , [Updated_Dttm]               [UpdatedDate]
            , [fldRiskAssessSlfHrmID]
            , [fldRiskAssessSuicideID]
            , [fldRiskAssessSlfNgtID]
            , [fldRiskAssessHthFallsID]
            , [fldRiskAssessMUsfMedID]
            , [fldRiskAssessSubMisID]
            , [fldRiskAssessActHrmID]
            , [fldRiskAssessDisengID]
            , [fldRiskAssessRskFOtrID]
            , [fldRiskAssessAggVioID]
            , [fldRiskAssessFireSetID]
            , [fldRiskAssessSexOffID]
            , [fldRiskAssessRskTOtrID]
            , [fldRiskAssessRskCdnID]
            , [fldRiskAssessDmgPrpID]
            , [fldRiskAssessMAPPAID]
            , [fldRiskAssessULawRstID]
            , [fldRiskAssessAsbEscID]
            , [fldRiskAssessCPPID]
            , [fldRiskAssessLACID]
			, [Confirm_Flag_ID]
       FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3]
   ) [PivotedScores]
       UNPIVOT
       (
           [RiskScore]
           FOR [Risk] IN ([fldRiskAssessSlfHrmID], [fldRiskAssessSuicideID], [fldRiskAssessSlfNgtID], [fldRiskAssessHthFallsID], [fldRiskAssessMUsfMedID]
                        , [fldRiskAssessSubMisID], [fldRiskAssessActHrmID], [fldRiskAssessDisengID], [fldRiskAssessRskFOtrID], [fldRiskAssessAggVioID]
                        , [fldRiskAssessFireSetID], [fldRiskAssessSexOffID], [fldRiskAssessRskTOtrID], [fldRiskAssessRskCdnID], [fldRiskAssessDmgPrpID]
                        , [fldRiskAssessMAPPAID], [fldRiskAssessULawRstID], [fldRiskAssessAsbEscID], [fldRiskAssessCPPID], [fldRiskAssessLACID]
                         )
      
	   ) [RiskScores]
	  
	  --UNION 
	  --SELECT  [OHFTGENRiskAssessmentv3_ID] [RiskAssessmentID]
   --         , [Patient_ID]                 [PatientID]
   --         , 125                          [TenancyID]
   --         , [Updated_Dttm]               [UpdatedDate]
			--, 'RiskSummary' Risk
			--,1
			--,1
	  --FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3]
)
--SELECT * FROM Risks
--	   WHERE Risks.RiskAssessmentID = 97330
--, RiskScoresDesc AS 
--(

--	  SELECT OHFTGENRiskAssessmentv3_ID,  'fldRiskAssessSlfHrmID' RiskScore, CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentSlfHrm, fldRiskUnableCommentSlfHrm)) RiskScoreDesc FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3]  	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessSuicideID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentSuicide, fldRiskUnableCommentSuicide)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessSlfNgtID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentSlfNgt, fldRiskUnableCommentSlfNgt)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessHthFallsID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentHthFalls, fldRiskUnableCommentHthFalls)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessMUsfMedID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentMUsfMed, fldRiskUnableCommentMUsfMed)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessSubMisID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentSubMis, fldRiskUnableCommentSubMis)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessActHrmID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentActHrm, fldRiskUnableCommentActHrm)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessDisengID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentDiseng, fldRiskUnableCommentDiseng)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessRskFOtrID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentRskFOtr, fldRiskUnableCommentRskFOtr)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessAggVioID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentAggVio, fldRiskUnableCommentAggVio)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessFireSetID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentFireSet, fldRiskUnableCommentFireSet)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessSexOffID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentSexOff, fldRiskUnableCommentSexOff)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessRskTOtrID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentRskTOtr, fldRiskUnableCommentRskTOtr)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessRskCdnID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentRskCdn	, fldRiskUnableCommentRskCdn)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessDmgPrpID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentDmgPrp, fldRiskUnableCommentDmgPrp)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessMAPPAID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentMAPPA, fldRiskUnableCommentMAPPA)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessULawRstID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentULawRst, fldRiskUnableCommentULawRst)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 	
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessAsbEscID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentAsbEsc, fldRiskUnableCommentAsbEsc)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessCPPID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentCPP, fldRiskUnableCommentCPP)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 
--	  UNION 
--	  SELECT OHFTGENRiskAssessmentv3_ID, 'fldRiskAssessLACID', CONVERT(VARCHAR(1000),ISNULL(fldRiskIdCommentLAC, fldRiskUnableCommentLAC)) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 
--	  --UNION 
--	  --SELECT OHFTGENRiskAssessmentv3_ID, 'RiskSummary', CONVERT(VARCHAR(1000),RiskSummary) FROM [mrr].[CNS_udfOHFTGENRiskAssessmentv3] 

--)
   , [RiskMapping]
AS (SELECT *
    FROM
    (
        VALUES
            ('fldRiskAssessSlfHrmID', 'Self Harm', '01')
          , ('fldRiskAssessSuicideID', 'Suicide', '02')
          , ('fldRiskAssessSlfNgtID', 'Self-Neglect', '03')
          , ('fldRiskAssessHthFallsID', 'Physical Health / Falls', '04')
          , ('fldRiskAssessMUsfMedID', 'Misuse of Medication', '05')
          , ('fldRiskAssessSubMisID', 'Alcohol and Substance Misuse', '06')
          , ('fldRiskAssessActHrmID', 'Accidental Harm (Outside the Home)', '07')
          , ('fldRiskAssessDisengID', 'Disengagement / Non-Compliance with Care', '08')
          , ('fldRiskAssessRskFOtrID', 'Risk From Others', '09')
          , ('fldRiskAssessAggVioID', 'Violence and Aggression', '10')
          , ('fldRiskAssessFireSetID', 'Fire-Setting', '11')
          , ('fldRiskAssessSexOffID', 'Sexual Offending', '12')
          , ('fldRiskAssessRskTOtrID', 'Specific Risks to Others', '13')
          , ('fldRiskAssessRskCdnID', 'Risk to Children', '14')
          , ('fldRiskAssessDmgPrpID', 'Damage to Property', '18')
          , ('fldRiskAssessMAPPAID', 'Multi-Agency Public Protection Arrangements (MAPPA)', '17')
          , ('fldRiskAssessULawRstID', 'Unlawful Restrictions / DoLS', '19')
          , ('fldRiskAssessAsbEscID', 'Absconding / Escaping / Wandering', '20')
          , ('fldRiskAssessCPPID', 'Subject to Child Protection Plan', '15')
          , ('fldRiskAssessLACID', 'Looked After Children', '16')
		  --, ('RiskSummary', 'Risk Summary', '21')
    ) AS [RiskMap] ([Risk], [RiskDescription], [Order]) )
   , [InvalidRiskAssessments]
AS ((SELECT [CNDoc].[CN_Object_ID] AS [RiskAssessmentID]
     FROM [mrr].[CNS_tblCNDocument]                     [CNDoc]
         INNER JOIN [mrr].[CNS_tblInvalidatedDocuments] [InvalidDoc]
             ON [InvalidDoc].[CN_Doc_ID] = [CNDoc].[CN_Doc_ID]
         INNER JOIN [mrr].[CNS_tblObjectTypeValues]     [ObjTyp]
             ON ([ObjTyp].[Object_Type_ID] = [CNDoc].[Object_Type_ID])
     WHERE [ObjTyp].[Key_Table_Name] = 'udfOHFTGENRiskAssessmentv3'))
SELECT CAST([Risks].[RiskAssessmentID] AS VARCHAR(10)) + CAST([Order] AS VARCHAR(2))+CAST(REPLACE(LEFT([Risks].[Risk], LEN([Risks].[Risk]) - 2), 'fldRiskAssess', '') AS VARCHAR(10)) AS [RiskScoreID] -- Manufacture a unique ID from the assessment and field.
     , CAST([Risks].[RiskAssessmentID] AS VARCHAR(10))									AS [RiskAssessmentID]
     , CAST([Risks].[PatientID] AS VARCHAR(20))											AS [PatientID]
     , [Risks].[TenancyID]
     , CONVERT(VARCHAR(23), [Risks].[UpdatedDate], 21)									AS UpdatedDate
     , REPLACE(CAST([RiskMapping].[RiskDescription] AS VARCHAR(1000)) , '|', '')		AS [RiskDescription]
  --   , CAST(CASE WHEN [RiskMapping].[RiskDescription]  = 'Risk Summary' THEN rsd.RiskScoreDesc
		--	ELSE REPLACE(CAST([RiskScores].[UDP_Assessed_Not_Desc] + CASE WHEN LEN(rsd.RiskScoreDesc) > 0 THEN ' - ' + REPLACE(REPLACE(rsd.RiskScoreDesc, CHAR(13),''), CHAR(10),'') ELSE '' END  AS VARCHAR(MAX)), '|', '')		
		--END		AS VARCHAR(1000))													AS [RiskStatus]
     , CAST(REPLACE([RiskScores].[UDP_Assessed_Not_Desc] , '|', '')	AS VARCHAR(1000))	AS [RiskStatus]

     , CASE
           WHEN [InvalidRiskAssessments].[RiskAssessmentID] IS NULL THEN
               0
           ELSE
               1
       END																											AS [Deleted]
	 , [RiskMapping].[Order] 
FROM [Graphnet_Config].[InscopePatient]
    INNER JOIN [Risks]
        ON ([Risks].[PatientID] = [PatientNo])
    INNER JOIN [RiskMapping]
        ON ([RiskMapping].[Risk] = [Risks].[Risk])
    INNER JOIN [mrr].[CNS_udpAssessedNotValues] [RiskScores]
        ON ([RiskScores].[UDP_Assessed_Not_ID] = [Risks].[RiskScore])
    LEFT OUTER JOIN [InvalidRiskAssessments]
        ON ([InvalidRiskAssessments].[RiskAssessmentID] = [Risks].[RiskAssessmentID])
	--LEFT JOIN RiskScoresDesc rsd
	--	ON rsd.OHFTGENRiskAssessmentv3_ID = [Risks].[RiskAssessmentID]
	--	AND rsd.RiskScore = [Risks].[Risk]
WHERE Risks.Confirm_Flag_ID = 1
--WHERE [Risks].[RiskScore] <> 0; -- Remove default, Not Assessed scores.
AND [Risks].[UpdatedDate] >= DATEADD(YEAR, -2, GETDATE()) ; -- two years


-- Add historical data
----Historical Data removed as only last 2 years is needed
--UNION 
--
--SELECT RiskScoreID
--       , RiskAssessmentID
--       , PatientID
--       , TenancyID
--       , UpdatedDate
--       , LEFT(RiskDescription, 1000) AS RiskDescription
--       , LEFT(RiskStatus, 1000) AS RiskStatus
--       , Deleted
--       , [Order]
--FROM [Graphnet].[vwRiskScores_HistoricalData]




GO
