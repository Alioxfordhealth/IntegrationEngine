SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblMHASectionDefinition
				EXECUTE mrr_tbl.load_CNS_tblMHASectionDefinition 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblMHASectionDefinition]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblMHASectionDefinition
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblMHASectionDefinition

						TRUNCATE TABLE mrr_wrk.CNS_tblMHASectionDefinition;

						INSERT INTO mrr_wrk.CNS_tblMHASectionDefinition
						(
							[MHA_Section_Definition_ID], [Updated_Dttm]
						)
						SELECT [MHA_Section_Definition_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASectionDefinition];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblMHASectionDefinition

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblMHASectionDefinition;

							INSERT INTO mrr_tbl.CNS_tblMHASectionDefinition
							(
								[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT [MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASectionDefinition];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblMHASectionDefinition AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblMHASectionDefinition AS src
								WHERE tgt.[MHA_Section_Definition_ID] = src.[MHA_Section_Definition_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblMHASectionDefinition AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblMHASectionDefinition AS src
								WHERE tgt.[MHA_Section_Definition_ID] = src.[MHA_Section_Definition_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblMHASectionDefinition
							(
								[MHA_Section_Definition_ID], [MHA_Section_Definition_Desc], [Active], [Default_Flag], [External_Code1], [External_Code2], [Display_Order], [CORC_Export_Code], [MHA_Section_Duration_Type_ID], [MHA_Section_Duration_Value], [Nominated_Deputy_Visible_Flag_ID], [Nominated_Deputy_Mandatory_Flag_ID], [Recommendation1_Visible_Flag_ID], [Recommendation1_Mandatory_Flag_ID], [Recommendation2_Visible_Flag_ID], [Recommendation2_Mandatory_Flag_ID], [Nurse_Visible_Flag_ID], [Nurse_Mandatory_Flag_ID], [Nearest_Relative_Visible_Flag_ID], [Nearest_Relative_Mandatory_Flag_ID], [Approved_Social_Worker_Visible_Flag_ID], [Approved_Social_Worker_Mandatory_Flag_ID], [Warn_If_No_Overlap_Flag_ID], [Set_End_Time_To_Midnight_Flag_ID], [Include_Social_Service_Assessment_Flag_ID], [Display_Renewal_Button_Flag_ID], [Display_Extension_Button_Flag_ID], [Comment_For_Med_Officer_Knows_Patient_Flag_ID], [Auto_Create_Section117_Doc_Flag_ID], [Include_Court_Details_Flag_ID], [Include_Home_Office_Details_Flag_ID], [Display_Mental_Category_Change_Button_Flag_ID], [Display_Sec12_Recomendation1_Approved_Flag_ID], [Display_Sec12_Recomendation2_Approved_Flag_ID], [Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT src.[MHA_Section_Definition_ID], src.[MHA_Section_Definition_Desc], src.[Active], src.[Default_Flag], src.[External_Code1], src.[External_Code2], src.[Display_Order], src.[CORC_Export_Code], src.[MHA_Section_Duration_Type_ID], src.[MHA_Section_Duration_Value], src.[Nominated_Deputy_Visible_Flag_ID], src.[Nominated_Deputy_Mandatory_Flag_ID], src.[Recommendation1_Visible_Flag_ID], src.[Recommendation1_Mandatory_Flag_ID], src.[Recommendation2_Visible_Flag_ID], src.[Recommendation2_Mandatory_Flag_ID], src.[Nurse_Visible_Flag_ID], src.[Nurse_Mandatory_Flag_ID], src.[Nearest_Relative_Visible_Flag_ID], src.[Nearest_Relative_Mandatory_Flag_ID], src.[Approved_Social_Worker_Visible_Flag_ID], src.[Approved_Social_Worker_Mandatory_Flag_ID], src.[Warn_If_No_Overlap_Flag_ID], src.[Set_End_Time_To_Midnight_Flag_ID], src.[Include_Social_Service_Assessment_Flag_ID], src.[Display_Renewal_Button_Flag_ID], src.[Display_Extension_Button_Flag_ID], src.[Comment_For_Med_Officer_Knows_Patient_Flag_ID], src.[Auto_Create_Section117_Doc_Flag_ID], src.[Include_Court_Details_Flag_ID], src.[Include_Home_Office_Details_Flag_ID], src.[Display_Mental_Category_Change_Button_Flag_ID], src.[Display_Sec12_Recomendation1_Approved_Flag_ID], src.[Display_Sec12_Recomendation2_Approved_Flag_ID], src.[Allow_Section_To_Be_Run_Concurrently_Under_Other_Sections_Flag_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblMHASectionDefinition] AS src
							INNER JOIN (SELECT wrk.[MHA_Section_Definition_ID] FROM mrr_wrk.CNS_tblMHASectionDefinition wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblMHASectionDefinition AS tgt
										WHERE wrk.[MHA_Section_Definition_ID] = tgt.[MHA_Section_Definition_ID]
									)
								) MissingRecs ON (MissingRecs.[MHA_Section_Definition_ID] = src.[MHA_Section_Definition_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblMHASectionDefinition
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblMHASectionDefinition

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
