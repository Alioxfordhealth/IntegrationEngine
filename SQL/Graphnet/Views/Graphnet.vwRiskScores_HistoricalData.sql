SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON





/*==========================================================================================================================================


==========================================================================================================================================*/
CREATE VIEW [Graphnet].[vwRiskScores_HistoricalData]
AS


WITH Risks AS 
(
SELECT OHFTGENRiskAssessment_ID  [RiskAssessmentID]
    , [Patient_ID]                 [PatientID]
    , 125                          [TenancyID]
    , [Updated_Dttm]               [UpdatedDate]
	, a.Risk
	, [RiskScore] 
FROM 
(
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm],  'fldRiskAssessSlfHrmID' Risk
	  , CASE WHEN SelfHarmEverID = 1 OR SelfInjuryOrHarmEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore] 
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment]  	

	  UNION 

	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessSuicideID'
	  , CASE WHEN SuicidalIdeationEverID = 1 
				OR ActWithSuicidalIntentEverID = 1 
				OR AttemptedSuicideWithIntentEverID = 1 
				OR ParaSuicideEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore] 
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	

	  UNION 

	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessSlfNgtID'
	  , CASE WHEN SevereSelfNeglectEverID = 1 OR SelfNeglectEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessHthFallsID'
	  , CASE WHEN PhysicalHealthEverID = 1 OR FallsEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessMUsfMedID'
	  , CASE WHEN UnsafeUseMedicationEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore] 
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessSubMisID'
	  , CASE WHEN SubstanceMisuseEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessActHrmID'
	  , CASE WHEN AccidentalHarmOutsideHomeEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessDisengID'
	  , CASE WHEN DisengagementEverID = 1 OR  NonConcordanceEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessRskFOtrID'
	  , CASE WHEN RiskCausedByMedicationsServicesTreatmentEverID = 1 
				OR RiskOfEmotionalPsychologicalAbuseEverID = 1 
				OR RiskOfFinancialAbuseEverID = 1 
				OR RiskOfNeglectEverID = 1 
				OR RiskOfPhysicalHarmEverID = 1 
				OR RiskOfSexualExploitationEverID = 1 
				OR CPPForSelfOrOtherEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessAggVioID'
	  , CASE WHEN AggressionAndViolenceEverID = 1
				OR familyEverID = 1
				OR OtherClientsEverID = 1
				OR GeneralPublicEverID = 1
				OR StaffEverID = 1  THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessFireSetID'
	  , CASE WHEN FireEverID = 1 OR ArsonEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessSexOffID'
	  , CASE WHEN ConvictedOfSexOffenceAgainstChildYoungPersonEverID = 1
				OR ConvictedOfSexualAssaultEverID = 1
				OR SexOffendersAct2003EverID = 1  THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessRskTOtrID'
	  , CASE WHEN RiskToChildrenAdultsEverID = 1
				OR ProbationServiceInvolvementEverID = 1
				OR RiskToChildrenEverID = 1
				OR ArsonEverID = 1
				OR ExpliotationFinancialEmotionalEverID = 1
				OR HostageTakingEverID = 1
				OR RiskToVulnrableAdultsEverID = 1
				OR MAPPAEverID = 1
				OR StalkingEverID = 1
				OR WeaponsEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessRskCdnID'
	  , CASE WHEN RiskToChildrenAdultsEverID = 1 OR RiskToChildrenEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessDmgPrpID'
	  , CASE WHEN DamageToPropertyEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessMAPPAID'
	  , CASE WHEN MAPPAEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessULawRstID'
	  , CASE WHEN RiskOfUnlawfulRestrictionsEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 	
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessAsbEscID'
	  , CASE WHEN AbscondingEscapingEverID = 1 OR AccidentalHarmOutsideHomeEverID = 1  THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessCPPID'
	  , CASE WHEN CPPForSelfOrOtherEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 
	  
	  UNION 
	  
	  SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'fldRiskAssessLACID'
	  , CASE WHEN SelfHarmEverID = 1 OR SelfInjuryOrHarmEverID = 1 THEN 'Yes' ELSE 'No' END [RiskScore]
	  FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 
	  
	  --UNION 
	  
	  --SELECT OHFTGENRiskAssessment_ID,[Patient_ID], [Updated_Dttm], 'RiskSummary'
	  --, REPLACE(REPLACE(CONVERT(VARCHAR(500),RisksIdentifiedComments) +
   --     CONVERT(VARCHAR(500),RiskEvidenceGeneralComments) +
	  --  CONVERT(VARCHAR(500),AccidentsComments) +
	  --  CONVERT(VARCHAR(500),HarmToOthersComments) +
	  --  CONVERT(VARCHAR(500),SexualOffencesComments)+
	  --  CONVERT(VARCHAR(500),ViolenceTowardsOthersComments) +
	  --  CONVERT(VARCHAR(500),HarmFromOthersComments) +
	  --  CONVERT(VARCHAR(500),HarmToSelfComments),CHAR(13),''), CHAR(10),'') AS  [RiskScore]
	  --FROM [mrr].[CNS_udfOHFTGENRiskAssessment] 
) a

)
,[RiskMapping] AS 
(SELECT *
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

SELECT 'O' + CAST([Risks].[RiskAssessmentID] AS VARCHAR(10)) + CAST([Order] AS VARCHAR(2))+CAST(REPLACE(LEFT([Risks].[Risk], LEN([Risks].[Risk]) - 2), 'fldRiskAssess', '') AS VARCHAR(10)) AS [RiskScoreID] -- Manufacture a unique ID from the assessment and field.
     , 'O' + CAST([Risks].[RiskAssessmentID] AS VARCHAR(10))						AS [RiskAssessmentID]
     , CAST([Risks].[PatientID] AS VARCHAR(20))										AS [PatientID]
     , [Risks].[TenancyID]
     , CONVERT(VARCHAR(23), [Risks].[UpdatedDate], 21)								AS UpdatedDate
     , REPLACE(CAST([RiskMapping].[RiskDescription] AS VARCHAR(MAX)) , '|', '')		AS [RiskDescription]
     , REPLACE(CAST(Risks.RiskScore  AS VARCHAR(MAX)), '|', '')						AS [RiskStatus]
     , 0																			AS [Deleted]
	 , [RiskMapping].[Order] 

FROM [Graphnet_Config].[InscopePatient]
    INNER JOIN [Risks]
        ON ([Risks].[PatientID] = [PatientNo])
    INNER JOIN [RiskMapping]
        ON ([RiskMapping].[Risk] = [Risks].[Risk])

GO
