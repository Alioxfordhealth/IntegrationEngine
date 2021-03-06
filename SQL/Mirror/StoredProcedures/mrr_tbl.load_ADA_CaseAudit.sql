SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_ADA_CaseAudit
				EXECUTE mrr_tbl.load_ADA_CaseAudit 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_ADA_CaseAudit]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'F' -- I= Incremental, F=Truncate/Insert, value ignored for full load only loaders
				AS
				BEGIN
					DECLARE @Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					--Try...
					BEGIN TRY
						BEGIN TRANSACTION;

						--07/06/2019  DD/TK added
						DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(EditDate)  FROM mrr_tbl.ADA_CaseAudit ),'1 Jan 1900')

						IF OBJECT_ID('dbo.tmpADACaseAudit6789','U') IS NOT NULL
						DROP TABLE dbo.tmpADACaseAudit6789

						SELECT [CaseAuditRef]
						INTO dbo.tmpADACaseAudit6789
						FROM [MHOXCARESQL01\MHOXCARESQL01].Adastra3Oxford.dbo.[CaseAudit] 
						WHERE EditDate > @MaxDate

						--TRUNCATE TABLE mrr_tbl.ADA_CaseAudit;

						DELETE FROM mrr_tbl.ADA_CaseAudit
						FROM mrr_tbl.ADA_CaseAudit pat
						WHERE EXISTS (SELECT 1 FROM dbo.tmpADACaseAudit6789 tmp WHERE tmp.CaseAuditRef = pat.CaseAuditRef)

						INSERT INTO mrr_tbl.ADA_CaseAudit
						(
							[CaseAuditRef], [CaseStatus], [ChangeReason], [CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [CaseTagRef], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [CallerIdPhone], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [NoteRematchRequired], [AlertAcknowledgementDate], [SequenceNumber], [UpdateReference]
						)
						SELECT c.[CaseAuditRef], [CaseStatus], [ChangeReason], [CaseRef], [EditDate], [ServiceRef], [OrganisationGroupRef], [CurrentLocationRef], [PatientRef], [ProviderRef], [CaseNo], [ActiveDate], [EntryDate], [ContactPhone], [CurrentLocationPhone], [Forename], [Surname], [SurnamePrefix], [Maiden], [MaidenPrefix], [CaseTypeRef], [CallerRelationshipRef], [CallerName], [CallerPhone], [CallerExtn], [ProviderGroupRef], [Summary], [BookedDate], [ProviderAdditionalText], [InsuranceType], [InsuranceSource], [InsuranceCompanyRef], [InsuranceNumber], [LocationRef], [FinalOutcomeRef], [Cancelled], [Testcall], [PatientAuditRef], [SpecialismRef], [DutyStationRef], [CurrentLocationExpiry], [ProviderGroupAdditionalText], [RegistrationTypeRef], [Initials], [Confidential], [MultipleCallMasterCaseRef], [CoverRef], [InvoiceAddressRef], [ActivePerformanceManagementRef], [SpecialismTypeRef], [PassProviderRef], [RequiresUserAcknowledgement], [UserAcknowledged], [AcknowledgementMessageRef], [LastEditByUserRef], [ProviderType], [WalkIn], [CaseTagRef], [SensitiveCase], [CurrentLocationPhoneExtn], [ContactPhoneExtn], [CallerIdPhone], [NationalProviderCode], [NationalProviderGroupCode], [InsuranceStartDate], [InsuranceEndDate], [NationalNumberStatus], [FutureCase], [ServiceVisibility], [OtherServiceVisibility], [CallerPhonePrefix], [ContactPhonePrefix], [CurrentLocationPhonePrefix], [NationalRepeatCallerStatus], [NoteRematchRequired], [AlertAcknowledgementDate], [SequenceNumber], [UpdateReference]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[CaseAudit] c
						INNER JOIN dbo.tmpADACaseAudit6789 tmp ON  tmp.CaseAuditRef = c.CaseAuditRef;

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.ADA_CaseAudit
						(
							LoadType,
							RunByUser,
							StartTime,
							EndTime,
							Inserted,
							Updated,
							Deleted
						)
						VALUES
						(   @LoadType,   -- LoadType - nvarchar(1)
							SYSTEM_USER, -- RunByUser - nvarchar(128)
							@StartTime,  -- StartTime - datetime2(7)
							@EndTime,    -- EndTime - datetime2(7)
							@Inserted,   -- Inserted - int
							@Updated,    -- Updated - int
							@Deleted     -- Deleted - int
							);
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.ADA_CaseAudit

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
