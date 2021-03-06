SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [dbo].[ReportPatientReview]
AS
SELECT        pr.Id, chr.CarenotesPatientId, rd.Code, rd.ShortName, rd.LongName, rd.ReviewType, dbo.FnReportReviewTypeFromEnum(rd.ReviewType) AS ReviewTypeDesc, rd.CoreProgramme, ro.Code AS OutcomeCode, 
                         ro.Description AS OutcomeDesc, pr.DateScheduled, pr.DateOutcome, pr.OutcomedByStaffId, chc.Code AS CentreCode, chc.Name AS CentreName, rl.Code AS ReviewLocationCode, 
                         rl.Description AS ReviewLocationDesc, pr.ConsultationId, pr.OriginalReviewId, pr.Removed
FROM            mrr.CCH_PatientReview AS pr INNER JOIN
                         mrr.CCH_ChildHealthRecord AS chr ON chr.Id = pr.PatientId AND chr.ExpiredDateTime IS NULL INNER JOIN
                         mrr.CCH_ReviewDefinition AS rd ON rd.Id = pr.ReviewDefinitionId LEFT OUTER JOIN
                         mrr.CCH_ChildHealthCentre AS chc ON chc.Id = pr.CentreId AND chc.ExpiredDateTime IS NULL LEFT OUTER JOIN
                         mrr.CCH_ReviewOutcome AS ro ON ro.Id = pr.ReviewOutcomeId LEFT OUTER JOIN
                         mrr.CCH_ReviewLocation AS rl ON rl.Id = pr.ReviewLocationId
WHERE        (pr.ExpiredDateTime IS NULL)


GO
