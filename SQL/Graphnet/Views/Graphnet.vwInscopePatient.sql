SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON










/*==========================================================================================================================================
Return patient IDs that fall within the Bucks Graphnet data set. Inner join to this view when creating other Graphnet views.

History:
15/06/2018 OBMH\Steve.Nicoll  Initial version.
18/06/2018 OBMH\Nicholas.Walne	Added WHERE clause for NOT LIKE '%XX%'
23/07/2018 OBMH\Nicholas.Walne	Adjusted the CCG derivation to take into account practices with branch codes & alter to get test patients only (temporary)

--==========================================================================================================================================*/
CREATE VIEW [Graphnet].[vwInscopePatient]
AS
SELECT [pat].[Patient_ID] AS [PatientNo]
FROM [mrr].[CNS_tblPatient]                              [pat]
    INNER JOIN [mrr].[CNS_tblGPDetail]                   [gpd]
        ON [pat].[Patient_ID] = [gpd].[Patient_ID]
           AND [gpd].[End_Date] IS NULL
    INNER JOIN [mrr].[CNS_tblPractice]                   [prac]
        ON [gpd].[Practice_ID] = [prac].[Practice_ID]
    LEFT JOIN mrr.CNS_tblPractice                          AS prac2
        ON LEFT(prac.Practice_Code, 6) = prac2.Practice_Code
    INNER JOIN [mrr].[CNS_tblClinicalCommissioningGroup] [ccg]
        ON [ccg].[CCG_ID] = COALESCE(gpd.CCG_ID, [prac].[CCG_ID], prac2.CCG_ID)
           AND [ccg].[CCG_Identifier] IN (   '10Y' -- NHS AYLESBURY VALE CCG
                                           , '10H' -- NHS CHILTERN CCG
										   , '14Y' -- NHS BUCKS
                                         )
WHERE ( pat.Access_Restricted_ID = 0
		AND pat.Surname NOT LIKE '%XX%TEST%'
		AND pat.Surname NOT LIKE '%DO%NOT%USE%'
		AND pat.Patient_ID <> 299714 -- Identified by Ian P as not to be used as test
	  )
	  OR pat.Patient_ID = 366407 -- this is a test patient used by Graphnet to test linking activities for this patient from all sources. please refer to Nadine email to Tatjana on 13 December 2019 13:38 



GO
