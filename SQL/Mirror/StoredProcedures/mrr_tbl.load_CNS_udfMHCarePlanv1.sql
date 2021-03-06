SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfMHCarePlanv1
				EXECUTE mrr_tbl.load_CNS_udfMHCarePlanv1 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfMHCarePlanv1]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfMHCarePlanv1
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfMHCarePlanv1

						TRUNCATE TABLE mrr_wrk.CNS_udfMHCarePlanv1;

						INSERT INTO mrr_wrk.CNS_udfMHCarePlanv1
						(
							[MHCarePlanv1_ID], [Updated_Dttm]
						)
						SELECT [MHCarePlanv1_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHCarePlanv1];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfMHCarePlanv1

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfMHCarePlanv1;

							INSERT INTO mrr_tbl.CNS_udfMHCarePlanv1
							(
								[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldneed1], [fldint1], [fldwho1], [fldneed2], [fldint2], [fldwho2], [fldneed3], [fldint3], [fldwho3], [fldneed4], [fldint4], [fldwho4], [fldneed5], [fldint5], [fldwho5], [fldneed6], [fldint6], [fldwho6], [fldneed7], [fldint7], [fldwho7], [fldneed8], [fldint8], [fldwho8], [fldneed9], [fldint9], [fldwho9], [fldneed10], [fldint10], [fldwho10], [fldneed11], [fldint11], [fldwho11], [fldneed12], [fldint12], [fldwho12], [fldneed13], [fldint13], [fldwho13], [fldneed14], [fldint14], [fldwho14], [fldneed15], [fldint15], [fldwho15], [fldneed16], [fldint16], [fldwho16], [fldneed17], [fldint17], [fldwho17], [fldneed18], [fldint18], [fldwho18], [fldneed19], [fldint19], [fldwho19], [fldneed20], [fldint20], [fldwho20], [fldcurmed], [fldlvlinv], [fldothrcom], [fldtrigwarn], [fldcrspln], [fldcontpln], [fldsrvcusr], [fldinfoshar], [fldcpcopyID], [fldreason], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCPType], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID], [fldCPAgreed]
							)
							SELECT [MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldneed1], [fldint1], [fldwho1], [fldneed2], [fldint2], [fldwho2], [fldneed3], [fldint3], [fldwho3], [fldneed4], [fldint4], [fldwho4], [fldneed5], [fldint5], [fldwho5], [fldneed6], [fldint6], [fldwho6], [fldneed7], [fldint7], [fldwho7], [fldneed8], [fldint8], [fldwho8], [fldneed9], [fldint9], [fldwho9], [fldneed10], [fldint10], [fldwho10], [fldneed11], [fldint11], [fldwho11], [fldneed12], [fldint12], [fldwho12], [fldneed13], [fldint13], [fldwho13], [fldneed14], [fldint14], [fldwho14], [fldneed15], [fldint15], [fldwho15], [fldneed16], [fldint16], [fldwho16], [fldneed17], [fldint17], [fldwho17], [fldneed18], [fldint18], [fldwho18], [fldneed19], [fldint19], [fldwho19], [fldneed20], [fldint20], [fldwho20], [fldcurmed], [fldlvlinv], [fldothrcom], [fldtrigwarn], [fldcrspln], [fldcontpln], [fldsrvcusr], [fldinfoshar], [fldcpcopyID], [fldreason], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCPType], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID], [fldCPAgreed]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHCarePlanv1];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfMHCarePlanv1 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfMHCarePlanv1 AS src
								WHERE tgt.[MHCarePlanv1_ID] = src.[MHCarePlanv1_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfMHCarePlanv1 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfMHCarePlanv1 AS src
								WHERE tgt.[MHCarePlanv1_ID] = src.[MHCarePlanv1_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfMHCarePlanv1
							(
								[MHCarePlanv1_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [flstrtdate], [flrevdate], [Hidden_items], [Icd_10], [Cluster_lvl], [fldneed1], [fldint1], [fldwho1], [fldneed2], [fldint2], [fldwho2], [fldneed3], [fldint3], [fldwho3], [fldneed4], [fldint4], [fldwho4], [fldneed5], [fldint5], [fldwho5], [fldneed6], [fldint6], [fldwho6], [fldneed7], [fldint7], [fldwho7], [fldneed8], [fldint8], [fldwho8], [fldneed9], [fldint9], [fldwho9], [fldneed10], [fldint10], [fldwho10], [fldneed11], [fldint11], [fldwho11], [fldneed12], [fldint12], [fldwho12], [fldneed13], [fldint13], [fldwho13], [fldneed14], [fldint14], [fldwho14], [fldneed15], [fldint15], [fldwho15], [fldneed16], [fldint16], [fldwho16], [fldneed17], [fldint17], [fldwho17], [fldneed18], [fldint18], [fldwho18], [fldneed19], [fldint19], [fldwho19], [fldneed20], [fldint20], [fldwho20], [fldcurmed], [fldlvlinv], [fldothrcom], [fldtrigwarn], [fldcrspln], [fldcontpln], [fldsrvcusr], [fldinfoshar], [fldcpcopyID], [fldreason], [fldshrdate], [flgrb], [flgnd1], [flgnd2], [flgnd3], [flgnd4], [flgnd5], [flgnd6], [flgnd7], [flgnd8], [flgnd9], [flgnd10], [flgnd11], [flgnd12], [flgnd13], [flgnd14], [flgnd15], [flgnd16], [flgnd17], [flgnd18], [flgnd19], [flgnd20], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [fldSafetyPlanFileName], [fldSafetyPlan], [fldCarePlanType1ID], [fldCarePlanType2ID], [fldCarePlanType3ID], [fldCarePlanType4ID], [fldCarePlanType5ID], [fldCarePlanType6ID], [fldCPType], [fldCarePlanAgreed1ID], [fldCarePlanAgreed2ID], [fldCarePlanAgreed3ID], [fldCarePlanAgreed4ID], [fldCarePlanAgreed5ID], [fldCarePlanAgreed6ID], [fldCarePlanAgreed7ID], [fldCPAgreed]
							)
							SELECT src.[MHCarePlanv1_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[OriginalAuthorID], src.[flstrtdate], src.[flrevdate], src.[Hidden_items], src.[Icd_10], src.[Cluster_lvl], src.[fldneed1], src.[fldint1], src.[fldwho1], src.[fldneed2], src.[fldint2], src.[fldwho2], src.[fldneed3], src.[fldint3], src.[fldwho3], src.[fldneed4], src.[fldint4], src.[fldwho4], src.[fldneed5], src.[fldint5], src.[fldwho5], src.[fldneed6], src.[fldint6], src.[fldwho6], src.[fldneed7], src.[fldint7], src.[fldwho7], src.[fldneed8], src.[fldint8], src.[fldwho8], src.[fldneed9], src.[fldint9], src.[fldwho9], src.[fldneed10], src.[fldint10], src.[fldwho10], src.[fldneed11], src.[fldint11], src.[fldwho11], src.[fldneed12], src.[fldint12], src.[fldwho12], src.[fldneed13], src.[fldint13], src.[fldwho13], src.[fldneed14], src.[fldint14], src.[fldwho14], src.[fldneed15], src.[fldint15], src.[fldwho15], src.[fldneed16], src.[fldint16], src.[fldwho16], src.[fldneed17], src.[fldint17], src.[fldwho17], src.[fldneed18], src.[fldint18], src.[fldwho18], src.[fldneed19], src.[fldint19], src.[fldwho19], src.[fldneed20], src.[fldint20], src.[fldwho20], src.[fldcurmed], src.[fldlvlinv], src.[fldothrcom], src.[fldtrigwarn], src.[fldcrspln], src.[fldcontpln], src.[fldsrvcusr], src.[fldinfoshar], src.[fldcpcopyID], src.[fldreason], src.[fldshrdate], src.[flgrb], src.[flgnd1], src.[flgnd2], src.[flgnd3], src.[flgnd4], src.[flgnd5], src.[flgnd6], src.[flgnd7], src.[flgnd8], src.[flgnd9], src.[flgnd10], src.[flgnd11], src.[flgnd12], src.[flgnd13], src.[flgnd14], src.[flgnd15], src.[flgnd16], src.[flgnd17], src.[flgnd18], src.[flgnd19], src.[flgnd20], src.[ReplanRequested], src.[DocumentGroupIdentifier], src.[PreviousCNObjectID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[fldEnteredDate], src.[fldEnteredTime], src.[StartDate], src.[StartTime], src.[fldSafetyPlanFileName], src.[fldSafetyPlan], src.[fldCarePlanType1ID], src.[fldCarePlanType2ID], src.[fldCarePlanType3ID], src.[fldCarePlanType4ID], src.[fldCarePlanType5ID], src.[fldCarePlanType6ID], src.[fldCPType], src.[fldCarePlanAgreed1ID], src.[fldCarePlanAgreed2ID], src.[fldCarePlanAgreed3ID], src.[fldCarePlanAgreed4ID], src.[fldCarePlanAgreed5ID], src.[fldCarePlanAgreed6ID], src.[fldCarePlanAgreed7ID], src.[fldCPAgreed]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfMHCarePlanv1] AS src
							INNER JOIN (SELECT wrk.[MHCarePlanv1_ID] FROM mrr_wrk.CNS_udfMHCarePlanv1 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfMHCarePlanv1 AS tgt
										WHERE wrk.[MHCarePlanv1_ID] = tgt.[MHCarePlanv1_ID]
									)
								) MissingRecs ON (MissingRecs.[MHCarePlanv1_ID] = src.[MHCarePlanv1_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfMHCarePlanv1
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfMHCarePlanv1

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
