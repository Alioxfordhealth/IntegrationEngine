SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

			/*==========================================================================================================================================
				Notes:
				Template for checking that Mirror table data matches the source data. This cannot compare text and blob datatype at present but it
				provides a good enough check that the mirror table is up to date.


				Test:

				EXECUTE mrr_tbl.reconcile_ADA_Case

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[reconcile_ADA_Case]
				-- Add the parameters for the stored procedure here
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;

					DECLARE @DiscrepacyCount BIGINT = 0;

					WITH GatherDiscrepancies
					AS ((SELECT 'In Mirror' AS DiscrepancySource
							   ,[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						 FROM mrr_tbl.ADA_Case
						 EXCEPT
						 SELECT 'In Mirror' AS DiscrepancySource
							   ,[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Case])
						UNION ALL
						(SELECT 'In Source' AS DiscrepancySource
							   ,[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						 FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[Case]
						 EXCEPT
						 SELECT 'In Source' AS DiscrepancySource
							   ,[CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [AlertAcknowledgementDate], [CaseTagRef], [NoteRematchRequired], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [SequenceNumber], [UpdateReference]
						 FROM mrr_tbl.ADA_Case))
					SELECT @DiscrepacyCount = COUNT(*)
					FROM GatherDiscrepancies;


					IF @DiscrepacyCount > 0
						THROW 51000, 'Mirror table mrr_tbl.ADA_Case has discrepancies when compared to its source table.', 1;

				END;
				
GO
