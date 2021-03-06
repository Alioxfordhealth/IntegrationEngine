SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE view [dbo].[vwCNS_DischargeSummary_Allergies]
as
select ids.OHFTDischargeNotificationSummaryV3_ID
, a.Allergy1
, a.Allergy2
, a.Allergy3
, a.Allergy4
, a.Allergy5
, a.Allergy6
, a.Allergy7
, a.Create_Dttm as DateRecorded
from [dbo].[CNS_tblInscopeDischargeSummary] ids
left join mrr.CNS_udfAllergies a on a.Patient_ID = ids.Patient_ID


GO
