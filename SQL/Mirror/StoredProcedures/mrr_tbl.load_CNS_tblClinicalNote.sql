SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblClinicalNote
				EXECUTE mrr_tbl.load_CNS_tblClinicalNote 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblClinicalNote]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblClinicalNote
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblClinicalNote

						TRUNCATE TABLE mrr_wrk.CNS_tblClinicalNote;

						INSERT INTO mrr_wrk.CNS_tblClinicalNote
						(
							[Clinical_Note_ID], [Updated_Dttm]
						)
						SELECT [Clinical_Note_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalNote];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblClinicalNote

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblClinicalNote;

							INSERT INTO mrr_tbl.CNS_tblClinicalNote
							(
								[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Clinical_Note_Text], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
							)
							SELECT [Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Clinical_Note_Text], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalNote];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblClinicalNote AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblClinicalNote AS src
								WHERE tgt.[Clinical_Note_ID] = src.[Clinical_Note_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblClinicalNote AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblClinicalNote AS src
								WHERE tgt.[Clinical_Note_ID] = src.[Clinical_Note_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblClinicalNote
							(
								[Clinical_Note_ID], [Patient_ID], [Author_Staff_ID], [Clinical_Note_Category_ID], [Clinical_Note_Type_ID], [Clinical_Note_Date], [Clinical_Note_Time], [Entry_Date], [Entry_Time], [Clinical_Note_Summary], [Clinical_Note_Text], [Confirm_Flag_ID], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Confirm_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Clinical_Note_Text_HTML]
							)
							SELECT src.[Clinical_Note_ID], src.[Patient_ID], src.[Author_Staff_ID], src.[Clinical_Note_Category_ID], src.[Clinical_Note_Type_ID], src.[Clinical_Note_Date], src.[Clinical_Note_Time], src.[Entry_Date], src.[Entry_Time], src.[Clinical_Note_Summary], src.[Clinical_Note_Text], src.[Confirm_Flag_ID], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[Confirm_Date], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Clinical_Note_Text_HTML]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblClinicalNote] AS src
							INNER JOIN (SELECT wrk.[Clinical_Note_ID] FROM mrr_wrk.CNS_tblClinicalNote wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblClinicalNote AS tgt
										WHERE wrk.[Clinical_Note_ID] = tgt.[Clinical_Note_ID]
									)
								) MissingRecs ON (MissingRecs.[Clinical_Note_ID] = src.[Clinical_Note_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblClinicalNote
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblClinicalNote

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
