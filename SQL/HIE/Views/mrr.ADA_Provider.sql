SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_Provider] AS SELECT [ProviderRef], [OrganisationGroupRef], [RotaGroupRef], [Forename], [Surname], [SurnamePrefix], [Maiden], [Lookup], [ProviderType], [PagerNumber], [Sex], [AlternativeKey], [Interlinkage], [Email], [Initials], [HomePhone], [MobilePhone], [OtherPhone], [EDIAddress], [V2LastUpdate], [AddressRef], [V2Import], [Obsolete], [Member], [IndemnityNumber], [IndemnityRenewal], [ApprovedForService], [XXX_LastAppraisalDate], [XXX_Audited], [XXX_LastAuditDate], [PSQOversamplingEndDate], [ContactDetails], [PagerFormat], [NationalProviderCode], [AremoteDeviceRef], [ProviderPaymentGroupRef], [ProviderBillingGroupRef], [WorkOptOut], [RetainerPercentage], [ApprovedForServiceByUserRef], [ApprovedForServiceDate], [AverageHoursWorkedOutsideOrganisation], [PCTPerformersList], [PCTPerformersListLastCheckDate], [IndemnityInsuranceProviderRef], [DefaultAvailabilityPatternRef], [ApprovedOnBehalfOfUserRef] FROM [Mirror].[mrr_tbl].[ADA_Provider];

GO
