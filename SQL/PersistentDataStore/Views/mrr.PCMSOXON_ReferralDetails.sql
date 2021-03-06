SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE VIEW [mrr].[PCMSOXON_ReferralDetails] AS SELECT [CaseNumber], [PatientID], [DateOfOnset], [PrimaryProb], [SecondaryProb], [PresentingProb], [PrimaryDiagnosis], [SecondaryDiagnosis], [OtherProb], [Referrer], [ResponsibleCommissioner], [WorkerName], [Profession], [Consent], [GPCode], [GPName], [Custom1], [Custom2], [Custom3], [EndOfCareDate], [ReferralAccepted], [OtherCaseNumber], [ServiceReqAccept], [PatientConsent2], [EndOfCareReason], [ReferredToService] FROM [Mirror].[mrr_tbl].[PCMSOXON_ReferralDetails];


GO
