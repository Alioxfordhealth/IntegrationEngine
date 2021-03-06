SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblCPADischarge
				EXECUTE mrr_tbl.load_CNS_tblCPADischarge 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblCPADischarge]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblCPADischarge
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblCPADischarge

						TRUNCATE TABLE mrr_wrk.CNS_tblCPADischarge;

						INSERT INTO mrr_wrk.CNS_tblCPADischarge
						(
							[CPA_Discharge_ID], [Updated_Dttm]
						)
						SELECT [CPA_Discharge_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPADischarge];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblCPADischarge

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblCPADischarge;

							INSERT INTO mrr_tbl.CNS_tblCPADischarge
							(
								[CPA_Discharge_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_ID], [CPA_Discharge_Date], [CPA_Discharge_Time], [CPA_Discharge_Dttm], [Authorised_By_Staff_ID], [CPA_Discharge_Type_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End]
							)
							SELECT [CPA_Discharge_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_ID], [CPA_Discharge_Date], [CPA_Discharge_Time], [CPA_Discharge_Dttm], [Authorised_By_Staff_ID], [CPA_Discharge_Type_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPADischarge];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblCPADischarge AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblCPADischarge AS src
								WHERE tgt.[CPA_Discharge_ID] = src.[CPA_Discharge_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblCPADischarge AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblCPADischarge AS src
								WHERE tgt.[CPA_Discharge_ID] = src.[CPA_Discharge_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblCPADischarge
							(
								[CPA_Discharge_ID], [Patient_ID], [CPA_Start_ID], [CPA_Review_ID], [CPA_Discharge_Date], [CPA_Discharge_Time], [CPA_Discharge_Dttm], [Authorised_By_Staff_ID], [CPA_Discharge_Type_ID], [Moved_To], [Contact_Info], [Responsibility_Of], [SW_Involved_ID], [Day_Centre_Involved_ID], [Sheltered_Work_Involved_ID], [Non_NHS_Res_Accom_ID], [Domicil_Care_Involved_ID], [CPA_Employment_Status_ID], [CPA_Weekly_Hours_Worked_ID], [CPA_Accomodation_Status_ID], [CPA_Settled_Accomodation_Indicator_ID], [Receiving_Direct_Payments_ID], [Individual_Budget_Agreed_ID], [Other_Financial_Considerations_ID], [Comments], [Accommodation_Status_Date], [Employment_Status_Date], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Active_Period_End]
							)
							SELECT src.[CPA_Discharge_ID], src.[Patient_ID], src.[CPA_Start_ID], src.[CPA_Review_ID], src.[CPA_Discharge_Date], src.[CPA_Discharge_Time], src.[CPA_Discharge_Dttm], src.[Authorised_By_Staff_ID], src.[CPA_Discharge_Type_ID], src.[Moved_To], src.[Contact_Info], src.[Responsibility_Of], src.[SW_Involved_ID], src.[Day_Centre_Involved_ID], src.[Sheltered_Work_Involved_ID], src.[Non_NHS_Res_Accom_ID], src.[Domicil_Care_Involved_ID], src.[CPA_Employment_Status_ID], src.[CPA_Weekly_Hours_Worked_ID], src.[CPA_Accomodation_Status_ID], src.[CPA_Settled_Accomodation_Indicator_ID], src.[Receiving_Direct_Payments_ID], src.[Individual_Budget_Agreed_ID], src.[Other_Financial_Considerations_ID], src.[Comments], src.[Accommodation_Status_Date], src.[Employment_Status_Date], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Active_Period_End]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblCPADischarge] AS src
							INNER JOIN (SELECT wrk.[CPA_Discharge_ID] FROM mrr_wrk.CNS_tblCPADischarge wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblCPADischarge AS tgt
										WHERE wrk.[CPA_Discharge_ID] = tgt.[CPA_Discharge_ID]
									)
								) MissingRecs ON (MissingRecs.[CPA_Discharge_ID] = src.[CPA_Discharge_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblCPADischarge
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblCPADischarge

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
