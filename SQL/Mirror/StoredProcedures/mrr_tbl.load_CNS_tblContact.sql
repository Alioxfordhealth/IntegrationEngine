SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_tblContact
				EXECUTE mrr_tbl.load_CNS_tblContact 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_tblContact]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_tblContact
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblContact

						TRUNCATE TABLE mrr_wrk.CNS_tblContact;

						INSERT INTO mrr_wrk.CNS_tblContact
						(
							[Contact_ID], [Updated_Dttm]
						)
						SELECT [Contact_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblContact];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_tblContact

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_tblContact;

							INSERT INTO mrr_tbl.CNS_tblContact
							(
								[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Comments], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
							)
							SELECT [Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Comments], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblContact];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_tblContact AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblContact AS src
								WHERE tgt.[Contact_ID] = src.[Contact_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_tblContact AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_tblContact AS src
								WHERE tgt.[Contact_ID] = src.[Contact_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_tblContact
							(
								[Contact_ID], [Patient_ID], [Contact_Type_ID], [Primary_Contact_ID], [Permission_To_Contact_ID], [No_Divulge_ID], [Additional_Information_ID], [Contact_Name], [Title_ID], [Forename], [Middlename], [Surname], [Salutation], [Address1], [Address2], [Address3], [Address4], [Address5], [Post_Code], [Contact_DOB], [Preferred_Method_Of_Contact_ID], [Start_Date], [End_Date], [Relationship], [Gender_ID], [First_Language_ID], [Interpreter_ID], [Home_Telephone], [Home_Telephone_Confidential_ID], [Mobile_Telephone], [Mobile_Telephone_Confidential_ID], [Work_Telephone], [Work_Telephone_Confidential_ID], [Email_Address], [Contact_NHS_Num], [Contact_Ethnicity_ID], [Contact_Other_Ref], [Contact_Soc_Serv_Ref], [Contact_NINumber], [Contact_Registered_GP_ID], [Refugee_Stateless_Person_ID], [Contact_Date_Of_Death], [Permission_To_Contact_GP_ID], [School], [School_Admin_Contact], [School_Contact], [School_Head_Teacher], [School_Telephone], [School_Fax], [Further_Information], [Comments], [Permission_To_Contact_School_ID], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [Family_Parental_Responsibility_ID], [Family_Legal_Status_ID]
							)
							SELECT src.[Contact_ID], src.[Patient_ID], src.[Contact_Type_ID], src.[Primary_Contact_ID], src.[Permission_To_Contact_ID], src.[No_Divulge_ID], src.[Additional_Information_ID], src.[Contact_Name], src.[Title_ID], src.[Forename], src.[Middlename], src.[Surname], src.[Salutation], src.[Address1], src.[Address2], src.[Address3], src.[Address4], src.[Address5], src.[Post_Code], src.[Contact_DOB], src.[Preferred_Method_Of_Contact_ID], src.[Start_Date], src.[End_Date], src.[Relationship], src.[Gender_ID], src.[First_Language_ID], src.[Interpreter_ID], src.[Home_Telephone], src.[Home_Telephone_Confidential_ID], src.[Mobile_Telephone], src.[Mobile_Telephone_Confidential_ID], src.[Work_Telephone], src.[Work_Telephone_Confidential_ID], src.[Email_Address], src.[Contact_NHS_Num], src.[Contact_Ethnicity_ID], src.[Contact_Other_Ref], src.[Contact_Soc_Serv_Ref], src.[Contact_NINumber], src.[Contact_Registered_GP_ID], src.[Refugee_Stateless_Person_ID], src.[Contact_Date_Of_Death], src.[Permission_To_Contact_GP_ID], src.[School], src.[School_Admin_Contact], src.[School_Contact], src.[School_Head_Teacher], src.[School_Telephone], src.[School_Fax], src.[Further_Information], src.[Comments], src.[Permission_To_Contact_School_ID], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[Family_Parental_Responsibility_ID], src.[Family_Legal_Status_ID]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblContact] AS src
							INNER JOIN (SELECT wrk.[Contact_ID] FROM mrr_wrk.CNS_tblContact wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_tblContact AS tgt
										WHERE wrk.[Contact_ID] = tgt.[Contact_ID]
									)
								) MissingRecs ON (MissingRecs.[Contact_ID] = src.[Contact_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_tblContact
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_tblContact

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
