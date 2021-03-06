SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON







CREATE VIEW [dbo].[vwCNC_DuplicatedPatients]
AS

WITH main AS 
(
		SELECT DISTINCT Matching_ID, Patient_ID1, Patient_ID2, P1_NHS_Number, P2_NHS_Number, c.MatchingOn
		FROM  [dbo].[tblCNC_DQ_Issues_DuplicatedPatients] dq
		   CROSS APPLY
		(
			SELECT 'HomePhone'
			WHERE HomePhone_Matching <> '' 
			UNION ALL
			SELECT 'Mobile'
			WHERE MobilePhone_Matching  <> '' 
			UNION ALL
			SELECT 'WorkPhone'
			WHERE WorkPhone_Matching  <> '' 
			UNION ALL
			SELECT 'Address'
			WHERE Address_Matching  <> '' 
			UNION ALL
			SELECT 'Postcode'
			WHERE PostCode_Matching  <> '' 
			UNION ALL
			SELECT 'GP'
			WHERE GP_Matching  <> ''     
			UNION ALL
			SELECT 'Practice'
			WHERE Practice_Matching  <> '' 
		)                                                            c(MatchingOn)
)
, NoOfObjects AS 
(
	SELECT cn.Patient_ID, COUNT(*) AS Objs, MAX(cn.ViewDate) LatestObjectViewDate
	FROM mrr.CNC_tblCNDocument cn
	--INNER JOIN main U ON U.Patient_ID = cn.Patient_ID
	GROUP BY cn.Patient_ID
)
SELECT  DISTINCT  [Matching_ID]
      , [Patient_ID1]
      , [Patient_ID2]
      , [P1_NHS_Number]
      , [P2_NHS_Number]
	  , CASE WHEN ISNULL([P1_NHS_Number],'x') = ISNULL([P2_NHS_Number],'y') THEN 'Same NHSNo.' END AS SameNHSNo_Flag
	  , p1.Objs AS Patient1_NoOfObjects
	  , p2.Objs AS Patient2_NoOfObjects
	  , p1.LatestObjectViewDate AS P1_LatestObjectViewDate
	  , p2.LatestObjectViewDate AS P2_LatestObjectViewDate
	  , pat1.NHS_Trace_Flag AS Pat1_NHS_Trace_Flag
	  , pat2.NHS_Trace_Flag AS Pat2_NHS_Trace_Flag
	  , 'Forename, Surname, DoB, ' + 
		(	SELECT  STUFF((
			SELECT   ', ' + CAST(MatchingOn AS VARCHAR(MAX))
			FROM main b
			WHERE a.[Patient_ID1] = b.[Patient_ID1]
			AND a.[Patient_ID2] = b.[Patient_ID2]
			FOR XML PATH('')
			), 1, 2, '')
		)  AS Matching_ON
	
FROM main a 
LEFT JOIN NoOfObjects P1
	ON a.Patient_ID1 = P1.Patient_ID
LEFT JOIN NoOfObjects P2
	ON a.Patient_ID2 = P2.Patient_ID
LEFT JOIN mrr.CNC_tblPatient Pat1
	ON a.Patient_ID1 = Pat1.Patient_ID
LEFT JOIN mrr.CNC_tblPatient Pat2
	ON a.Patient_ID2 = Pat2.Patient_ID
--WHERE Patient_ID1 = 283919




GO
