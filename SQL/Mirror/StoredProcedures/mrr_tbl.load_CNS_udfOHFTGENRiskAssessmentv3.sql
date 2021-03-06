SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfOHFTGENRiskAssessmentv3
				EXECUTE mrr_tbl.load_CNS_udfOHFTGENRiskAssessmentv3 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfOHFTGENRiskAssessmentv3]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'I' -- I= Incremental, F=Truncate/Insert
				AS
				BEGIN
					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					DECLARE @Threshold NUMERIC(4, 1) = 25.0; -- When gross change greater than this percentage, we will do a full reload. (Valid values between 0.0-100.0, to 1 decimal place.)
					DECLARE @OriginalTargetCount BIGINT,
							@WorkingCount INTEGER,
							@Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					--Try...
					BEGIN TRY
						--	How many records in target (the count does not have to be super accurate but should be as fast as possible)?
						SET @OriginalTargetCount =
						(
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3

						TRUNCATE TABLE mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3;

						INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3
						(
							[OHFTGENRiskAssessmentv3_ID], [Updated_Dttm]
						)
						SELECT [OHFTGENRiskAssessmentv3_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessmentv3];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3;

							INSERT INTO mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3
							(
								[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskIdCommentSlfHrm], [fldRiskUnableCommentSlfHrm], [fldRiskAssessSuicideID], [fldRiskIdCommentSuicide], [fldRiskUnableCommentSuicide], [fldRiskAssessSlfNgtID], [fldRiskIdCommentSlfNgt], [fldRiskUnableCommentSlfNgt], [fldRiskAssessHthFallsID], [fldRiskIdCommentHthFalls], [fldRiskUnableCommentHthFalls], [fldRiskAssessMUsfMedID], [fldRiskIdCommentMUsfMed], [fldRiskUnableCommentMUsfMed], [fldRiskAssessSubMisID], [fldRiskIdCommentSubMis], [fldRiskUnableCommentSubMis], [fldRiskAssessActHrmID], [fldRiskIdCommentActHrm], [fldRiskUnableCommentActHrm], [fldRiskAssessDisengID], [fldRiskIdCommentDiseng], [fldRiskUnableCommentDiseng], [fldRiskAssessRskFOtrID], [fldRiskIdCommentRskFOtr], [fldRiskUnableCommentRskFOtr], [fldRiskAssessAggVioID], [fldRiskIdCommentAggVio], [fldRiskUnableCommentAggVio], [fldRiskAssessFireSetID], [fldRiskIdCommentFireSet], [fldRiskUnableCommentFireSet], [fldRiskAssessSexOffID], [fldRiskIdCommentSexOff], [fldRiskUnableCommentSexOff], [fldRiskAssessRskTOtrID], [fldRiskIdCommentRskTOtr], [fldRiskUnableCommentRskTOtr], [fldRiskAssessRskCdnID], [fldRiskIdCommentRskCdn], [fldRiskUnableCommentRskCdn], [fldRiskAssessDmgPrpID], [fldRiskIdCommentDmgPrp], [fldRiskUnableCommentDmgPrp], [fldRiskAssessMAPPAID], [fldRiskIdCommentMAPPA], [fldRiskUnableCommentMAPPA], [fldRiskAssessULawRstID], [fldRiskIdCommentULawRst], [fldRiskUnableCommentULawRst], [fldRiskAssessAsbEscID], [fldRiskIdCommentAsbEsc], [fldRiskUnableCommentAsbEsc], [fldRiskAssessCPPID], [fldRiskIdCommentCPP], [fldRiskUnableCommentCPP], [RiskSummary], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRefReasonComm], [fldRiskAssessLACID], [fldRiskIdCommentLAC], [fldRiskUnableCommentLAC], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime], [fldRefSocCareComm]
							)
							SELECT [OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskIdCommentSlfHrm], [fldRiskUnableCommentSlfHrm], [fldRiskAssessSuicideID], [fldRiskIdCommentSuicide], [fldRiskUnableCommentSuicide], [fldRiskAssessSlfNgtID], [fldRiskIdCommentSlfNgt], [fldRiskUnableCommentSlfNgt], [fldRiskAssessHthFallsID], [fldRiskIdCommentHthFalls], [fldRiskUnableCommentHthFalls], [fldRiskAssessMUsfMedID], [fldRiskIdCommentMUsfMed], [fldRiskUnableCommentMUsfMed], [fldRiskAssessSubMisID], [fldRiskIdCommentSubMis], [fldRiskUnableCommentSubMis], [fldRiskAssessActHrmID], [fldRiskIdCommentActHrm], [fldRiskUnableCommentActHrm], [fldRiskAssessDisengID], [fldRiskIdCommentDiseng], [fldRiskUnableCommentDiseng], [fldRiskAssessRskFOtrID], [fldRiskIdCommentRskFOtr], [fldRiskUnableCommentRskFOtr], [fldRiskAssessAggVioID], [fldRiskIdCommentAggVio], [fldRiskUnableCommentAggVio], [fldRiskAssessFireSetID], [fldRiskIdCommentFireSet], [fldRiskUnableCommentFireSet], [fldRiskAssessSexOffID], [fldRiskIdCommentSexOff], [fldRiskUnableCommentSexOff], [fldRiskAssessRskTOtrID], [fldRiskIdCommentRskTOtr], [fldRiskUnableCommentRskTOtr], [fldRiskAssessRskCdnID], [fldRiskIdCommentRskCdn], [fldRiskUnableCommentRskCdn], [fldRiskAssessDmgPrpID], [fldRiskIdCommentDmgPrp], [fldRiskUnableCommentDmgPrp], [fldRiskAssessMAPPAID], [fldRiskIdCommentMAPPA], [fldRiskUnableCommentMAPPA], [fldRiskAssessULawRstID], [fldRiskIdCommentULawRst], [fldRiskUnableCommentULawRst], [fldRiskAssessAsbEscID], [fldRiskIdCommentAsbEsc], [fldRiskUnableCommentAsbEsc], [fldRiskAssessCPPID], [fldRiskIdCommentCPP], [fldRiskUnableCommentCPP], [RiskSummary], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRefReasonComm], [fldRiskAssessLACID], [fldRiskIdCommentLAC], [fldRiskUnableCommentLAC], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime], [fldRefSocCareComm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessmentv3];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3 AS src
								WHERE tgt.[OHFTGENRiskAssessmentv3_ID] = src.[OHFTGENRiskAssessmentv3_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3 AS src
								WHERE tgt.[OHFTGENRiskAssessmentv3_ID] = src.[OHFTGENRiskAssessmentv3_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3
							(
								[OHFTGENRiskAssessmentv3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [aRole], [StartDate], [EndDate], [fldRiskAssessSlfHrmID], [fldRiskIdCommentSlfHrm], [fldRiskUnableCommentSlfHrm], [fldRiskAssessSuicideID], [fldRiskIdCommentSuicide], [fldRiskUnableCommentSuicide], [fldRiskAssessSlfNgtID], [fldRiskIdCommentSlfNgt], [fldRiskUnableCommentSlfNgt], [fldRiskAssessHthFallsID], [fldRiskIdCommentHthFalls], [fldRiskUnableCommentHthFalls], [fldRiskAssessMUsfMedID], [fldRiskIdCommentMUsfMed], [fldRiskUnableCommentMUsfMed], [fldRiskAssessSubMisID], [fldRiskIdCommentSubMis], [fldRiskUnableCommentSubMis], [fldRiskAssessActHrmID], [fldRiskIdCommentActHrm], [fldRiskUnableCommentActHrm], [fldRiskAssessDisengID], [fldRiskIdCommentDiseng], [fldRiskUnableCommentDiseng], [fldRiskAssessRskFOtrID], [fldRiskIdCommentRskFOtr], [fldRiskUnableCommentRskFOtr], [fldRiskAssessAggVioID], [fldRiskIdCommentAggVio], [fldRiskUnableCommentAggVio], [fldRiskAssessFireSetID], [fldRiskIdCommentFireSet], [fldRiskUnableCommentFireSet], [fldRiskAssessSexOffID], [fldRiskIdCommentSexOff], [fldRiskUnableCommentSexOff], [fldRiskAssessRskTOtrID], [fldRiskIdCommentRskTOtr], [fldRiskUnableCommentRskTOtr], [fldRiskAssessRskCdnID], [fldRiskIdCommentRskCdn], [fldRiskUnableCommentRskCdn], [fldRiskAssessDmgPrpID], [fldRiskIdCommentDmgPrp], [fldRiskUnableCommentDmgPrp], [fldRiskAssessMAPPAID], [fldRiskIdCommentMAPPA], [fldRiskUnableCommentMAPPA], [fldRiskAssessULawRstID], [fldRiskIdCommentULawRst], [fldRiskUnableCommentULawRst], [fldRiskAssessAsbEscID], [fldRiskIdCommentAsbEsc], [fldRiskUnableCommentAsbEsc], [fldRiskAssessCPPID], [fldRiskIdCommentCPP], [fldRiskUnableCommentCPP], [RiskSummary], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [StartTime], [fldRefSocCareID], [fldRefSocDate], [fldRefReasonID], [fldRefReasonComm], [fldRiskAssessLACID], [fldRiskIdCommentLAC], [fldRiskUnableCommentLAC], [flgchkChildRisk], [flgchkSocialCare], [flgchkSocialCareComm], [flgchkendborder], [flgchkGen0], [flgchkGen1], [flgchkGen2], [flgchkGen3], [flgchkGen4], [flgchkGen5], [flgchkGen6], [flgchkGen7], [flgchkGen8], [flgchkGen9], [flgchkGen10], [flgchkGen11], [flgchkGen12], [flgchkGen13], [flgchkGen14], [flgchkGen15], [flgchkGen16], [flgchkGen17], [flgchkGen18], [flgchkGen19], [fldEnteredDate], [fldEnteredTime], [fldRefSocCareComm]
							)
							SELECT src.[OHFTGENRiskAssessmentv3_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[OriginalAuthorID], src.[aRole], src.[StartDate], src.[EndDate], src.[fldRiskAssessSlfHrmID], src.[fldRiskIdCommentSlfHrm], src.[fldRiskUnableCommentSlfHrm], src.[fldRiskAssessSuicideID], src.[fldRiskIdCommentSuicide], src.[fldRiskUnableCommentSuicide], src.[fldRiskAssessSlfNgtID], src.[fldRiskIdCommentSlfNgt], src.[fldRiskUnableCommentSlfNgt], src.[fldRiskAssessHthFallsID], src.[fldRiskIdCommentHthFalls], src.[fldRiskUnableCommentHthFalls], src.[fldRiskAssessMUsfMedID], src.[fldRiskIdCommentMUsfMed], src.[fldRiskUnableCommentMUsfMed], src.[fldRiskAssessSubMisID], src.[fldRiskIdCommentSubMis], src.[fldRiskUnableCommentSubMis], src.[fldRiskAssessActHrmID], src.[fldRiskIdCommentActHrm], src.[fldRiskUnableCommentActHrm], src.[fldRiskAssessDisengID], src.[fldRiskIdCommentDiseng], src.[fldRiskUnableCommentDiseng], src.[fldRiskAssessRskFOtrID], src.[fldRiskIdCommentRskFOtr], src.[fldRiskUnableCommentRskFOtr], src.[fldRiskAssessAggVioID], src.[fldRiskIdCommentAggVio], src.[fldRiskUnableCommentAggVio], src.[fldRiskAssessFireSetID], src.[fldRiskIdCommentFireSet], src.[fldRiskUnableCommentFireSet], src.[fldRiskAssessSexOffID], src.[fldRiskIdCommentSexOff], src.[fldRiskUnableCommentSexOff], src.[fldRiskAssessRskTOtrID], src.[fldRiskIdCommentRskTOtr], src.[fldRiskUnableCommentRskTOtr], src.[fldRiskAssessRskCdnID], src.[fldRiskIdCommentRskCdn], src.[fldRiskUnableCommentRskCdn], src.[fldRiskAssessDmgPrpID], src.[fldRiskIdCommentDmgPrp], src.[fldRiskUnableCommentDmgPrp], src.[fldRiskAssessMAPPAID], src.[fldRiskIdCommentMAPPA], src.[fldRiskUnableCommentMAPPA], src.[fldRiskAssessULawRstID], src.[fldRiskIdCommentULawRst], src.[fldRiskUnableCommentULawRst], src.[fldRiskAssessAsbEscID], src.[fldRiskIdCommentAsbEsc], src.[fldRiskUnableCommentAsbEsc], src.[fldRiskAssessCPPID], src.[fldRiskIdCommentCPP], src.[fldRiskUnableCommentCPP], src.[RiskSummary], src.[ReplanRequested], src.[DocumentGroupIdentifier], src.[PreviousCNObjectID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[StartTime], src.[fldRefSocCareID], src.[fldRefSocDate], src.[fldRefReasonID], src.[fldRefReasonComm], src.[fldRiskAssessLACID], src.[fldRiskIdCommentLAC], src.[fldRiskUnableCommentLAC], src.[flgchkChildRisk], src.[flgchkSocialCare], src.[flgchkSocialCareComm], src.[flgchkendborder], src.[flgchkGen0], src.[flgchkGen1], src.[flgchkGen2], src.[flgchkGen3], src.[flgchkGen4], src.[flgchkGen5], src.[flgchkGen6], src.[flgchkGen7], src.[flgchkGen8], src.[flgchkGen9], src.[flgchkGen10], src.[flgchkGen11], src.[flgchkGen12], src.[flgchkGen13], src.[flgchkGen14], src.[flgchkGen15], src.[flgchkGen16], src.[flgchkGen17], src.[flgchkGen18], src.[flgchkGen19], src.[fldEnteredDate], src.[fldEnteredTime], src.[fldRefSocCareComm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTGENRiskAssessmentv3] AS src
							INNER JOIN (SELECT wrk.[OHFTGENRiskAssessmentv3_ID] FROM mrr_wrk.CNS_udfOHFTGENRiskAssessmentv3 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfOHFTGENRiskAssessmentv3 AS tgt
										WHERE wrk.[OHFTGENRiskAssessmentv3_ID] = tgt.[OHFTGENRiskAssessmentv3_ID]
									)
								) MissingRecs ON (MissingRecs.[OHFTGENRiskAssessmentv3_ID] = src.[OHFTGENRiskAssessmentv3_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfOHFTGENRiskAssessmentv3
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

						-- Commit the data lolad and audit table update.
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfOHFTGENRiskAssessmentv3

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
