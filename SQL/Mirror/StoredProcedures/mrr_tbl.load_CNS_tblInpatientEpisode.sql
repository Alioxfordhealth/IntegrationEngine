SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblInpatientEpisode
				EXECUTE mrr_tbl.load_CNS_tblInpatientEpisode 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblInpatientEpisode]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblInpatientEpisode
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblInpatientEpisode

						TRUNCATE TABLE mrr_wrk.CNS_tblInpatientEpisode;

						INSERT INTO mrr_wrk.CNS_tblInpatientEpisode
						(
							[Inpatient_Episode_ID], [Updated_Dttm]
						)
						SELECT [Inpatient_Episode_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblInpatientEpisode];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblInpatientEpisode

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblInpatientEpisode;

							INSERT INTO mrr_tbl.CNS_tblInpatientEpisode
							(
								[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
							)
							SELECT [Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblInpatientEpisode];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblInpatientEpisode AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblInpatientEpisode AS src
								WHERE tgt.[Inpatient_Episode_ID] = src.[Inpatient_Episode_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblInpatientEpisode AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblInpatientEpisode AS src
								WHERE tgt.[Inpatient_Episode_ID] = src.[Inpatient_Episode_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblInpatientEpisode
							(
								[Inpatient_Episode_ID], [Admission_Type_ID], [Planned_Admission_Date], [Last_Discharge_Date], [Ninety_Day_Readmission_Flag_ID], [Ninety_Day_Readmission_Status], [MHA_Admission_Status_ID], [Section_Start_Date], [Admission_Source_ID], [Admission_Time], [Admission_Method_ID], [Management_Code_ID], [Gender_ID], [Accomodation_ID], [Lives_With_ID], [Ethnicity_ID], [Employment_ID], [Overseas_Visitor_Status_ID], [Valuables_In_Safe_Keeping_Flag_ID], [Admission_Address1], [Admission_Address2], [Admission_Address3], [Admission_Address4], [Admission_Address5], [Admission_Post_Code], [Admission_Telephone], [Admission_Fax], [Planned_Discharge_Date], [Delayed_Discharge_Date], [Delayed_Discharge_Code_ID], [Responsibility_Of_Care_ID], [Seven_Day_Disch_Followup_Required_ID], [Seven_Day_Disch_Followup_By_Whom_Staff_ID], [Seven_Day_Disch_Followup_Date], [Sick_Certificate_Required_And_Used_ID], [Physical_Description_Recorded_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Planned_Discharge_Destination_ID]
							)
							SELECT src.[Inpatient_Episode_ID], src.[Admission_Type_ID], src.[Planned_Admission_Date], src.[Last_Discharge_Date], src.[Ninety_Day_Readmission_Flag_ID], src.[Ninety_Day_Readmission_Status], src.[MHA_Admission_Status_ID], src.[Section_Start_Date], src.[Admission_Source_ID], src.[Admission_Time], src.[Admission_Method_ID], src.[Management_Code_ID], src.[Gender_ID], src.[Accomodation_ID], src.[Lives_With_ID], src.[Ethnicity_ID], src.[Employment_ID], src.[Overseas_Visitor_Status_ID], src.[Valuables_In_Safe_Keeping_Flag_ID], src.[Admission_Address1], src.[Admission_Address2], src.[Admission_Address3], src.[Admission_Address4], src.[Admission_Address5], src.[Admission_Post_Code], src.[Admission_Telephone], src.[Admission_Fax], src.[Planned_Discharge_Date], src.[Delayed_Discharge_Date], src.[Delayed_Discharge_Code_ID], src.[Responsibility_Of_Care_ID], src.[Seven_Day_Disch_Followup_Required_ID], src.[Seven_Day_Disch_Followup_By_Whom_Staff_ID], src.[Seven_Day_Disch_Followup_Date], src.[Sick_Certificate_Required_And_Used_ID], src.[Physical_Description_Recorded_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Planned_Discharge_Destination_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblInpatientEpisode] AS src
							INNER JOIN (SELECT wrk.[Inpatient_Episode_ID] FROM mrr_wrk.CNS_tblInpatientEpisode wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblInpatientEpisode AS tgt
										WHERE wrk.[Inpatient_Episode_ID] = tgt.[Inpatient_Episode_ID]
									)
								) MissingRecs ON (MissingRecs.[Inpatient_Episode_ID] = src.[Inpatient_Episode_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblInpatientEpisode
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblInpatientEpisode

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
