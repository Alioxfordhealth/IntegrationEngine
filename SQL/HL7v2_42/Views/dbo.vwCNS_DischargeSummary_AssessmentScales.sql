SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON



CREATE view [dbo].[vwCNS_DischargeSummary_AssessmentScales]
as
select ids.OHFTDischargeNotificationSummaryV3_ID
, h.Main_Conclusion + ', HONOS Total = ' + h.Total as AssessmentScale
, ROW_NUMBER() OVER(Partition by ids.Patient_ID order by h.Assessment_Date + coalesce(h.Assessment_Time, '00:00') desc) as rn
from [dbo].[CNS_tblInscopeDischargeSummary] ids
left join mrr.CNS_tblHONOS h on h.Patient_ID = ids.Patient_ID
left join mrr.CNS_tblCNDocument cn on cn.CN_Object_ID = h.HONOS_ID and cn.Object_Type_ID = 69
where h.Main_Conclusion not like '%Draft%'
and cn.Referral_ID = ids.Referral_ID

GO
