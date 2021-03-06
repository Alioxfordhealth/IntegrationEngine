SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_tblAddress
				EXECUTE mrr_tbl.load_CNC_tblAddress 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_tblAddress]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_tblAddress
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblAddress

						TRUNCATE TABLE mrr_wrk.CNC_tblAddress;

						INSERT INTO mrr_wrk.CNC_tblAddress
						(
							[Address_ID], [Updated_Dttm]
						)
						SELECT [Address_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAddress];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_tblAddress

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_tblAddress;

							INSERT INTO mrr_tbl.CNC_tblAddress
							(
								[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
							)
							SELECT [Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAddress];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_tblAddress AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblAddress AS src
								WHERE tgt.[Address_ID] = src.[Address_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_tblAddress AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_tblAddress AS src
								WHERE tgt.[Address_ID] = src.[Address_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_tblAddress
							(
								[Address_ID], [Patient_ID], [Usual_Address_Flag_ID], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [City_ID], [Main_Phone_Number_Type_ID], [Main_Telephone_Number], [Tel_Home], [Tel_Home_Confidential_Flag_ID], [Tel_Mobile], [Tel_SMS], [Tel_Mobile_Confidential_Flag_ID], [Tel_Work], [Tel_Work_Confidential_Flag_ID], [Email_Address], [SMS_Reminders_Flag_ID], [Address_Type_ID], [Address_Confidential_Flag_ID], [Start_Date], [End_Date], [Health_Authority], [Commissioning_Contract_Number_ID], [Local_Authority], [Electoral_Ward], [District_Of_Residence], [Residence_PCT_ID], [DAT_Of_Residence_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Method_Of_Contact_Other], [PCT_Of_Index_Offence_ID], [CCG_ID], [PDS_ID]
							)
							SELECT src.[Address_ID], src.[Patient_ID], src.[Usual_Address_Flag_ID], src.[Address1], src.[Address2], src.[Address3], src.[Address4], src.[Address5], src.[Post_Code], src.[City_ID], src.[Main_Phone_Number_Type_ID], src.[Main_Telephone_Number], src.[Tel_Home], src.[Tel_Home_Confidential_Flag_ID], src.[Tel_Mobile], src.[Tel_SMS], src.[Tel_Mobile_Confidential_Flag_ID], src.[Tel_Work], src.[Tel_Work_Confidential_Flag_ID], src.[Email_Address], src.[SMS_Reminders_Flag_ID], src.[Address_Type_ID], src.[Address_Confidential_Flag_ID], src.[Start_Date], src.[End_Date], src.[Health_Authority], src.[Commissioning_Contract_Number_ID], src.[Local_Authority], src.[Electoral_Ward], src.[District_Of_Residence], src.[Residence_PCT_ID], src.[DAT_Of_Residence_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Method_Of_Contact_Other], src.[PCT_Of_Index_Offence_ID], src.[CCG_ID], src.[PDS_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAddress] AS src
							INNER JOIN (SELECT wrk.[Address_ID] FROM mrr_wrk.CNC_tblAddress wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_tblAddress AS tgt
										WHERE wrk.[Address_ID] = tgt.[Address_ID]
									)
								) MissingRecs ON (MissingRecs.[Address_ID] = src.[Address_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_tblAddress
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_tblAddress

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
