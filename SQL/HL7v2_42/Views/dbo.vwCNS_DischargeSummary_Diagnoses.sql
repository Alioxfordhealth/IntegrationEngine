SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE view [dbo].[vwCNS_DischargeSummary_Diagnoses]
as
select ids.OHFTDischargeNotificationSummaryV3_ID
, icd.Primary_Diag
, icd.Secondary_Diag_1
, icd.Secondary_Diag_2
, icd.Secondary_Diag_3
, icd.Secondary_Diag_4
, icd.Secondary_Diag_5
, icd.Secondary_Diag_6
, icd.Secondary_Diag_7
from [dbo].[CNS_tblInscopeDischargeSummary] ids
left join mrr.CNS_tblICD10 icd on icd.Patient_ID = ids.Patient_ID
left join mrr.CNS_tblCNDocument cnd on cnd.CN_Object_ID = ICD10_ID and cnd.Object_Type_ID = 325
left join mrr.CNS_tblInvalidatedDocuments id on id.CN_Doc_ID = cnd.CN_Doc_ID
where id.CN_Doc_ID is null

GO
