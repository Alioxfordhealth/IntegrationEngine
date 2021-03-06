SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfOHFTDischargeNotificationSummaryV3
				EXECUTE mrr_tbl.load_CNS_udfOHFTDischargeNotificationSummaryV3 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfOHFTDischargeNotificationSummaryV3]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3

						TRUNCATE TABLE mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3;

						INSERT INTO mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3
						(
							[OHFTDischargeNotificationSummaryV3_ID], [Updated_Dttm]
						)
						SELECT [OHFTDischargeNotificationSummaryV3_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTDischargeNotificationSummaryV3];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3;

							INSERT INTO mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3
							(
								[OHFTDischargeNotificationSummaryV3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [fldDisLoc], [fldDisLocTele], [fldConsult], [fldCareCoord], [fldDateAdm], [fldDateDis], [fldMHAStat], [fldDisNotIssID], [fldDateNotIss], [fldDiagnosis], [flddrug1ID], [flddose1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldBriefSumm], [fldDisPlan], [fldDisComments], [fld7DayFollowYNID], [fld7DayFollowID], [fld7DayFollowComm], [flgchk], [flgchk7day], [fldWardStayID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldSecDiagnosis0], [fldSecDiagnosis1], [fldSecDiagnosis2], [fldSecDiagnosis3], [fldSecDiagnosis4], [fldMHADate], [fldMHAStart], [fldMHAEnd], [fldMHAStatHide], [fld117Date], [fld117Start], [fld117End], [fld117StatHide], [fld117EndFormatted], [fldMHAOutcome], [fldMHAActive]
							)
							SELECT [OHFTDischargeNotificationSummaryV3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [fldDisLoc], [fldDisLocTele], [fldConsult], [fldCareCoord], [fldDateAdm], [fldDateDis], [fldMHAStat], [fldDisNotIssID], [fldDateNotIss], [fldDiagnosis], [flddrug1ID], [flddose1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldBriefSumm], [fldDisPlan], [fldDisComments], [fld7DayFollowYNID], [fld7DayFollowID], [fld7DayFollowComm], [flgchk], [flgchk7day], [fldWardStayID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldSecDiagnosis0], [fldSecDiagnosis1], [fldSecDiagnosis2], [fldSecDiagnosis3], [fldSecDiagnosis4], [fldMHADate], [fldMHAStart], [fldMHAEnd], [fldMHAStatHide], [fld117Date], [fld117Start], [fld117End], [fld117StatHide], [fld117EndFormatted], [fldMHAOutcome], [fldMHAActive]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTDischargeNotificationSummaryV3];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3 AS src
								WHERE tgt.[OHFTDischargeNotificationSummaryV3_ID] = src.[OHFTDischargeNotificationSummaryV3_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3 AS src
								WHERE tgt.[OHFTDischargeNotificationSummaryV3_ID] = src.[OHFTDischargeNotificationSummaryV3_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3
							(
								[OHFTDischargeNotificationSummaryV3_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [fldDisLoc], [fldDisLocTele], [fldConsult], [fldCareCoord], [fldDateAdm], [fldDateDis], [fldMHAStat], [fldDisNotIssID], [fldDateNotIss], [fldDiagnosis], [flddrug1ID], [flddose1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldBriefSumm], [fldDisPlan], [fldDisComments], [fld7DayFollowYNID], [fld7DayFollowID], [fld7DayFollowComm], [flgchk], [flgchk7day], [fldWardStayID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldSecDiagnosis0], [fldSecDiagnosis1], [fldSecDiagnosis2], [fldSecDiagnosis3], [fldSecDiagnosis4], [fldMHADate], [fldMHAStart], [fldMHAEnd], [fldMHAStatHide], [fld117Date], [fld117Start], [fld117End], [fld117StatHide], [fld117EndFormatted], [fldMHAOutcome], [fldMHAActive]
							)
							SELECT src.[OHFTDischargeNotificationSummaryV3_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[Invalid_Date], src.[Invalid_Flag_ID], src.[Invalid_Staff_Name], src.[Invalid_Reason], src.[OriginalAuthorID], src.[StartDate], src.[fldDisLoc], src.[fldDisLocTele], src.[fldConsult], src.[fldCareCoord], src.[fldDateAdm], src.[fldDateDis], src.[fldMHAStat], src.[fldDisNotIssID], src.[fldDateNotIss], src.[fldDiagnosis], src.[flddrug1ID], src.[flddose1], src.[fldroute1ID], src.[fldprsbr1ID], src.[fldcomm1], src.[flddrug2ID], src.[flddose2], src.[fldroute2ID], src.[fldprsbr2ID], src.[fldcomm2], src.[flddrug3ID], src.[flddose3], src.[fldroute3ID], src.[fldprsbr3ID], src.[fldcomm3], src.[flddrug4ID], src.[flddose4], src.[fldroute4ID], src.[fldprsbr4ID], src.[fldcomm4], src.[flddrug5ID], src.[flddose5], src.[fldroute5ID], src.[fldprsbr5ID], src.[fldcomm5], src.[flddrug6ID], src.[flddose6], src.[fldroute6ID], src.[fldprsbr6ID], src.[fldcomm6], src.[flddrug7ID], src.[flddose7], src.[fldroute7ID], src.[fldprsbr7ID], src.[fldcomm7], src.[flddrug8ID], src.[flddose8], src.[fldroute8ID], src.[fldprsbr8ID], src.[fldcomm8], src.[flddrug9ID], src.[flddose9], src.[fldroute9ID], src.[fldprsbr9ID], src.[fldcomm9], src.[flddrug10ID], src.[flddose10], src.[fldroute10ID], src.[fldprsbr10ID], src.[fldcomm10], src.[flddrug11ID], src.[flddose11], src.[fldroute11ID], src.[fldprsbr11ID], src.[fldcomm11], src.[flddrug12ID], src.[flddose12], src.[fldroute12ID], src.[fldprsbr12ID], src.[fldcomm12], src.[flddrug13ID], src.[flddose13], src.[fldroute13ID], src.[fldprsbr13ID], src.[fldcomm13], src.[flddrug14ID], src.[flddose14], src.[fldroute14ID], src.[fldprsbr14ID], src.[fldcomm14], src.[flddrug15ID], src.[flddose15], src.[fldroute15ID], src.[fldprsbr15ID], src.[fldcomm15], src.[flddrug16ID], src.[flddose16], src.[fldroute16ID], src.[fldprsbr16ID], src.[fldcomm16], src.[flddrug17ID], src.[flddose17], src.[fldroute17ID], src.[fldprsbr17ID], src.[fldcomm17], src.[flddrug18ID], src.[flddose18], src.[fldroute18ID], src.[fldprsbr18ID], src.[fldcomm18], src.[flddrug19ID], src.[flddose19], src.[fldroute19ID], src.[fldprsbr19ID], src.[fldcomm19], src.[flddrug20ID], src.[flddose20], src.[fldroute20ID], src.[fldprsbr20ID], src.[fldcomm20], src.[flddrug21ID], src.[flddose21], src.[fldroute21ID], src.[fldprsbr21ID], src.[fldcomm21], src.[flddrug22ID], src.[flddose22], src.[fldroute22ID], src.[fldprsbr22ID], src.[fldcomm22], src.[flddrug23ID], src.[flddose23], src.[fldroute23ID], src.[fldprsbr23ID], src.[fldcomm23], src.[flddrug24ID], src.[flddose24], src.[fldroute24ID], src.[fldprsbr24ID], src.[fldcomm24], src.[flddrug25ID], src.[flddose25], src.[fldroute25ID], src.[fldprsbr25ID], src.[fldcomm25], src.[fldBriefSumm], src.[fldDisPlan], src.[fldDisComments], src.[fld7DayFollowYNID], src.[fld7DayFollowID], src.[fld7DayFollowComm], src.[flgchk], src.[flgchk7day], src.[fldWardStayID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[fldSecDiagnosis0], src.[fldSecDiagnosis1], src.[fldSecDiagnosis2], src.[fldSecDiagnosis3], src.[fldSecDiagnosis4], src.[fldMHADate], src.[fldMHAStart], src.[fldMHAEnd], src.[fldMHAStatHide], src.[fld117Date], src.[fld117Start], src.[fld117End], src.[fld117StatHide], src.[fld117EndFormatted], src.[fldMHAOutcome], src.[fldMHAActive]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfOHFTDischargeNotificationSummaryV3] AS src
							INNER JOIN (SELECT wrk.[OHFTDischargeNotificationSummaryV3_ID] FROM mrr_wrk.CNS_udfOHFTDischargeNotificationSummaryV3 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfOHFTDischargeNotificationSummaryV3 AS tgt
										WHERE wrk.[OHFTDischargeNotificationSummaryV3_ID] = tgt.[OHFTDischargeNotificationSummaryV3_ID]
									)
								) MissingRecs ON (MissingRecs.[OHFTDischargeNotificationSummaryV3_ID] = src.[OHFTDischargeNotificationSummaryV3_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfOHFTDischargeNotificationSummaryV3
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfOHFTDischargeNotificationSummaryV3

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
