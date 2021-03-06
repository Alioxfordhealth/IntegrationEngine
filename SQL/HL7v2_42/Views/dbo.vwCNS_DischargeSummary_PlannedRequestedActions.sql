SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE view [dbo].[vwCNS_DischargeSummary_PlannedRequestedActions]
as
select ids.OHFTDischargeNotificationSummaryV3_ID
, isnull('Need: ' + CAST(fldneed1 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint1 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho1 as varchar) + ' ', '') as cp1
, isnull('Need: ' + CAST(fldneed2 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint2 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho2 as varchar) + ' ', '') as cp2
, isnull('Need: ' + CAST(fldneed3 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint3 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho3 as varchar) + ' ', '') as cp3
, isnull('Need: ' + CAST(fldneed4 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint4 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho4 as varchar) + ' ', '') as cp4
, isnull('Need: ' + CAST(fldneed5 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint5 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho5 as varchar) + ' ', '') as cp5
, isnull('Need: ' + CAST(fldneed6 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint6 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho6 as varchar) + ' ', '') as cp6
, isnull('Need: ' + CAST(fldneed7 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint7 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho7 as varchar) + ' ', '') as cp7
, isnull('Need: ' + CAST(fldneed8 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint8 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho8 as varchar) + ' ', '') as cp8
, isnull('Need: ' + CAST(fldneed9 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint9 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho9 as varchar) + ' ', '') as cp9
, isnull('Need: ' + CAST(fldneed10 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint10 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho10 as varchar) + ' ', '') as cp10
, isnull('Need: ' + CAST(fldneed11 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint11 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho11 as varchar) + ' ', '') as cp11
, isnull('Need: ' + CAST(fldneed12 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint12 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho12 as varchar) + ' ', '') as cp12
, isnull('Need: ' + CAST(fldneed13 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint13 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho13 as varchar) + ' ', '') as cp13
, isnull('Need: ' + CAST(fldneed14 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint14 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho14 as varchar) + ' ', '') as cp14
, isnull('Need: ' + CAST(fldneed15 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint15 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho15 as varchar) + ' ', '') as cp15
, isnull('Need: ' + CAST(fldneed16 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint16 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho16 as varchar) + ' ', '') as cp16
, isnull('Need: ' + CAST(fldneed17 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint17 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho17 as varchar) + ' ', '') as cp17
, isnull('Need: ' + CAST(fldneed18 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint18 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho18 as varchar) + ' ', '') as cp18
, isnull('Need: ' + CAST(fldneed19 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint19 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho19 as varchar) + ' ', '') as cp19
, isnull('Need: ' + CAST(fldneed20 as varchar) + ' ', '') + isnull('Intervention: ' + CAST(fldint20 as varchar) + ' ', '') + isnull('Who: ' + CAST(fldwho20 as varchar) + ' ', '') as cp20
, CASE WHEN fldCarePlanAgreed1ID = 1 THEN 'Patient, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed2ID = 1 THEN 'Advocate, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed3ID = 1 THEN 'Local Community Support Team, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed5ID = 1 THEN 'Family Member or Carer, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed6ID = 1 THEN 'Clinical Service or Team, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed7ID = 1 THEN 'Commissioner, ' ELSE '' END
	+ CASE WHEN fldCarePlanAgreed4ID = 1 THEN 'Other, ' ELSE '' END as CPAgreedBy
, fldCPAgreed as CPAgreedByFurtherInfo
from mrr.CNS_udfMHCarePlanv1 cp
LEFT JOIN mrr.CNS_tblCNDocument cnd ON cnd.CN_Object_ID = cp.MHCarePlanv1_ID AND cnd.Object_Type_ID = 10000271
INNER JOIN [dbo].[CNS_tblInscopeDischargeSummary] ids ON ids.Referral_ID = cnd.Referral_ID

GO
