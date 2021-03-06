SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNS_udfEISCommonAssessmentv2
				EXECUTE mrr_tbl.load_CNS_udfEISCommonAssessmentv2 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNS_udfEISCommonAssessmentv2]
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
							SELECT COUNT(*) FROM mrr_tbl.CNS_udfEISCommonAssessmentv2
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfEISCommonAssessmentv2

						TRUNCATE TABLE mrr_wrk.CNS_udfEISCommonAssessmentv2;

						INSERT INTO mrr_wrk.CNS_udfEISCommonAssessmentv2
						(
							[EISCommonAssessmentv2_ID], [Updated_Dttm]
						)
						SELECT [EISCommonAssessmentv2_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfEISCommonAssessmentv2];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNS_udfEISCommonAssessmentv2

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNS_udfEISCommonAssessmentv2;

							INSERT INTO mrr_tbl.CNS_udfEISCommonAssessmentv2
							(
								[EISCommonAssessmentv2_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldCAARMSID], [fldCAARMSrateID], [fldCAARMSratecomm], [fldpatstatID], [fldpsydate1], [fldpsydate2], [fldpsydate3], [fldpsydate4], [fldcomorbradioID], [fldautisticchkID], [fldepilepsychkID], [fldothrchkID], [fldheadinjchkID], [fldThyroidchkID], [flddiabeteschkID], [fldsubmisckID], [fldcomorbRead], [fldcomorbothercomm], [fldServices], [fldexserAMHTID], [fldexseryouthoffID], [fldexserCAMHSID], [fldexserinpatwardID], [fldexserdrugalcID], [fldexserothrID], [fldExtServRead], [fldextServcomm], [fldposdelID], [fldposcondisorgID], [fldposhallbehID], [fldposexciteID], [fldposgrandID], [fldpossuspID], [fldposhostID], [fldnegbluntID], [fldnegemowithID], [fldnegpoorrapID], [fldnegpasssocwithID], [fldnegdiffabsID], [fldneglackspontID], [fldnegsterthinkID], [fldsltsofasID], [fldintcodedets], [fldintsumm], [fldmenhlthsatID], [fldaddhlpmenhlthID], [fldaddhlpdetsmenhlth], [fldperhlthsatID], [fldaddhlpperhlthID], [fldaddhlpdetsperhlth], [fldjobsatID], [fldaddhlpjobID], [fldaddhlpdetsjob], [fldaccomsatID], [fldaddhlpaccomID], [fldaddhlpdetsaccom], [fldleisactsatID], [fldaddhlpleisactID], [fldaddhlpdetsleisact], [fldfriendsatID], [fldaddhlpfriendID], [fldaddhlpdetsfriend], [fldpartfamsatID], [fldaddhlpfamsatID], [fldaddhlpdetsfamsat], [fldpersafesatID], [fldaddhlppersafeID], [fldaddhlpdetspersafe], [fldmedsatID], [fldaddhlpmedID], [fldaddhlpdetsmed], [fldprachlpsatID], [fldaddhlpID], [fldaddhlpdets], [fldmenhlthconsultsatID], [fldaddhlpmenhlthconsultID], [fldaddhlpdetsmenhlthconsult], [fldqprbtrmyslfID], [fldqprchncsID], [fldqprposrelID], [fldqprprtsocID], [fldqprassertID], [fldqprlifepurpID], [fldqprexpchngbtrID], [fldqprpastevntsID], [fldqprmotbtrID], [fldqprpostngsID], [fldqprundrstndmyslfID], [fldqprchrgoflifeID], [fldqprengwlifeID], [fldqprcontmylifeID], [fldqprtimeienjyID], [fldEIPdate0], [fldEIPdrop0ID], [fldEIPdate1], [fldEIPdrop1ID], [fldEIPdate2], [fldEIPdrop2ID], [fldEIPdate3], [fldEIPdrop3ID], [fldEIPdate4], [fldEIPdrop4ID], [fldEIPdate5], [fldEIPdrop5ID], [fldEIPdate6], [fldEIPdrop6ID], [fldEIPdate7], [fldEIPdrop7ID], [fldEIPdate8], [fldEIPdrop8ID], [fldEIPdate9], [fldEIPdrop9ID], [fldEIPdate10], [fldEIPdrop10ID], [fldEIPdate11], [fldEIPdrop11ID], [fldEIPdate12], [fldEIPdrop12ID], [fldEIPdate13], [fldEIPdrop13ID], [fldEIPdate14], [fldEIPdrop14ID], [fldEIPdate15], [fldEIPdrop15ID], [fldEIPdate16], [fldEIPdrop16ID], [flgAssessType], [flgCAARMS], [flgcomorbchk], [flgcomorbothr], [flgintcodedets], [flgExtServ], [flgDIALOG0], [flgDIALOG1], [flgDIALOG2], [flgDIALOG3], [flgDIALOG4], [flgDIALOG5], [flgDIALOG6], [flgDIALOG7], [flgDIALOG8], [flgDIALOG9], [flgDIALOG10], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
							)
							SELECT [EISCommonAssessmentv2_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldCAARMSID], [fldCAARMSrateID], [fldCAARMSratecomm], [fldpatstatID], [fldpsydate1], [fldpsydate2], [fldpsydate3], [fldpsydate4], [fldcomorbradioID], [fldautisticchkID], [fldepilepsychkID], [fldothrchkID], [fldheadinjchkID], [fldThyroidchkID], [flddiabeteschkID], [fldsubmisckID], [fldcomorbRead], [fldcomorbothercomm], [fldServices], [fldexserAMHTID], [fldexseryouthoffID], [fldexserCAMHSID], [fldexserinpatwardID], [fldexserdrugalcID], [fldexserothrID], [fldExtServRead], [fldextServcomm], [fldposdelID], [fldposcondisorgID], [fldposhallbehID], [fldposexciteID], [fldposgrandID], [fldpossuspID], [fldposhostID], [fldnegbluntID], [fldnegemowithID], [fldnegpoorrapID], [fldnegpasssocwithID], [fldnegdiffabsID], [fldneglackspontID], [fldnegsterthinkID], [fldsltsofasID], [fldintcodedets], [fldintsumm], [fldmenhlthsatID], [fldaddhlpmenhlthID], [fldaddhlpdetsmenhlth], [fldperhlthsatID], [fldaddhlpperhlthID], [fldaddhlpdetsperhlth], [fldjobsatID], [fldaddhlpjobID], [fldaddhlpdetsjob], [fldaccomsatID], [fldaddhlpaccomID], [fldaddhlpdetsaccom], [fldleisactsatID], [fldaddhlpleisactID], [fldaddhlpdetsleisact], [fldfriendsatID], [fldaddhlpfriendID], [fldaddhlpdetsfriend], [fldpartfamsatID], [fldaddhlpfamsatID], [fldaddhlpdetsfamsat], [fldpersafesatID], [fldaddhlppersafeID], [fldaddhlpdetspersafe], [fldmedsatID], [fldaddhlpmedID], [fldaddhlpdetsmed], [fldprachlpsatID], [fldaddhlpID], [fldaddhlpdets], [fldmenhlthconsultsatID], [fldaddhlpmenhlthconsultID], [fldaddhlpdetsmenhlthconsult], [fldqprbtrmyslfID], [fldqprchncsID], [fldqprposrelID], [fldqprprtsocID], [fldqprassertID], [fldqprlifepurpID], [fldqprexpchngbtrID], [fldqprpastevntsID], [fldqprmotbtrID], [fldqprpostngsID], [fldqprundrstndmyslfID], [fldqprchrgoflifeID], [fldqprengwlifeID], [fldqprcontmylifeID], [fldqprtimeienjyID], [fldEIPdate0], [fldEIPdrop0ID], [fldEIPdate1], [fldEIPdrop1ID], [fldEIPdate2], [fldEIPdrop2ID], [fldEIPdate3], [fldEIPdrop3ID], [fldEIPdate4], [fldEIPdrop4ID], [fldEIPdate5], [fldEIPdrop5ID], [fldEIPdate6], [fldEIPdrop6ID], [fldEIPdate7], [fldEIPdrop7ID], [fldEIPdate8], [fldEIPdrop8ID], [fldEIPdate9], [fldEIPdrop9ID], [fldEIPdate10], [fldEIPdrop10ID], [fldEIPdate11], [fldEIPdrop11ID], [fldEIPdate12], [fldEIPdrop12ID], [fldEIPdate13], [fldEIPdrop13ID], [fldEIPdate14], [fldEIPdrop14ID], [fldEIPdate15], [fldEIPdrop15ID], [fldEIPdate16], [fldEIPdrop16ID], [flgAssessType], [flgCAARMS], [flgcomorbchk], [flgcomorbothr], [flgintcodedets], [flgExtServ], [flgDIALOG0], [flgDIALOG1], [flgDIALOG2], [flgDIALOG3], [flgDIALOG4], [flgDIALOG5], [flgDIALOG6], [flgDIALOG7], [flgDIALOG8], [flgDIALOG9], [flgDIALOG10], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfEISCommonAssessmentv2];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNS_udfEISCommonAssessmentv2 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfEISCommonAssessmentv2 AS src
								WHERE tgt.[EISCommonAssessmentv2_ID] = src.[EISCommonAssessmentv2_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNS_udfEISCommonAssessmentv2 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNS_udfEISCommonAssessmentv2 AS src
								WHERE tgt.[EISCommonAssessmentv2_ID] = src.[EISCommonAssessmentv2_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNS_udfEISCommonAssessmentv2
							(
								[EISCommonAssessmentv2_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [Invalid_Date], [Invalid_Flag_ID], [Invalid_Staff_Name], [Invalid_Reason], [OriginalAuthorID], [StartDate], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldCAARMSID], [fldCAARMSrateID], [fldCAARMSratecomm], [fldpatstatID], [fldpsydate1], [fldpsydate2], [fldpsydate3], [fldpsydate4], [fldcomorbradioID], [fldautisticchkID], [fldepilepsychkID], [fldothrchkID], [fldheadinjchkID], [fldThyroidchkID], [flddiabeteschkID], [fldsubmisckID], [fldcomorbRead], [fldcomorbothercomm], [fldServices], [fldexserAMHTID], [fldexseryouthoffID], [fldexserCAMHSID], [fldexserinpatwardID], [fldexserdrugalcID], [fldexserothrID], [fldExtServRead], [fldextServcomm], [fldposdelID], [fldposcondisorgID], [fldposhallbehID], [fldposexciteID], [fldposgrandID], [fldpossuspID], [fldposhostID], [fldnegbluntID], [fldnegemowithID], [fldnegpoorrapID], [fldnegpasssocwithID], [fldnegdiffabsID], [fldneglackspontID], [fldnegsterthinkID], [fldsltsofasID], [fldintcodedets], [fldintsumm], [fldmenhlthsatID], [fldaddhlpmenhlthID], [fldaddhlpdetsmenhlth], [fldperhlthsatID], [fldaddhlpperhlthID], [fldaddhlpdetsperhlth], [fldjobsatID], [fldaddhlpjobID], [fldaddhlpdetsjob], [fldaccomsatID], [fldaddhlpaccomID], [fldaddhlpdetsaccom], [fldleisactsatID], [fldaddhlpleisactID], [fldaddhlpdetsleisact], [fldfriendsatID], [fldaddhlpfriendID], [fldaddhlpdetsfriend], [fldpartfamsatID], [fldaddhlpfamsatID], [fldaddhlpdetsfamsat], [fldpersafesatID], [fldaddhlppersafeID], [fldaddhlpdetspersafe], [fldmedsatID], [fldaddhlpmedID], [fldaddhlpdetsmed], [fldprachlpsatID], [fldaddhlpID], [fldaddhlpdets], [fldmenhlthconsultsatID], [fldaddhlpmenhlthconsultID], [fldaddhlpdetsmenhlthconsult], [fldqprbtrmyslfID], [fldqprchncsID], [fldqprposrelID], [fldqprprtsocID], [fldqprassertID], [fldqprlifepurpID], [fldqprexpchngbtrID], [fldqprpastevntsID], [fldqprmotbtrID], [fldqprpostngsID], [fldqprundrstndmyslfID], [fldqprchrgoflifeID], [fldqprengwlifeID], [fldqprcontmylifeID], [fldqprtimeienjyID], [fldEIPdate0], [fldEIPdrop0ID], [fldEIPdate1], [fldEIPdrop1ID], [fldEIPdate2], [fldEIPdrop2ID], [fldEIPdate3], [fldEIPdrop3ID], [fldEIPdate4], [fldEIPdrop4ID], [fldEIPdate5], [fldEIPdrop5ID], [fldEIPdate6], [fldEIPdrop6ID], [fldEIPdate7], [fldEIPdrop7ID], [fldEIPdate8], [fldEIPdrop8ID], [fldEIPdate9], [fldEIPdrop9ID], [fldEIPdate10], [fldEIPdrop10ID], [fldEIPdate11], [fldEIPdrop11ID], [fldEIPdate12], [fldEIPdrop12ID], [fldEIPdate13], [fldEIPdrop13ID], [fldEIPdate14], [fldEIPdrop14ID], [fldEIPdate15], [fldEIPdrop15ID], [fldEIPdate16], [fldEIPdrop16ID], [flgAssessType], [flgCAARMS], [flgcomorbchk], [flgcomorbothr], [flgintcodedets], [flgExtServ], [flgDIALOG0], [flgDIALOG1], [flgDIALOG2], [flgDIALOG3], [flgDIALOG4], [flgDIALOG5], [flgDIALOG6], [flgDIALOG7], [flgDIALOG8], [flgDIALOG9], [flgDIALOG10], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm], [fldEnteredDate], [fldEnteredTime], [StartTime]
							)
							SELECT src.[EISCommonAssessmentv2_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[Invalid_Date], src.[Invalid_Flag_ID], src.[Invalid_Staff_Name], src.[Invalid_Reason], src.[OriginalAuthorID], src.[StartDate], src.[ReplanRequested], src.[DocumentGroupIdentifier], src.[PreviousCNObjectID], src.[fldCAARMSID], src.[fldCAARMSrateID], src.[fldCAARMSratecomm], src.[fldpatstatID], src.[fldpsydate1], src.[fldpsydate2], src.[fldpsydate3], src.[fldpsydate4], src.[fldcomorbradioID], src.[fldautisticchkID], src.[fldepilepsychkID], src.[fldothrchkID], src.[fldheadinjchkID], src.[fldThyroidchkID], src.[flddiabeteschkID], src.[fldsubmisckID], src.[fldcomorbRead], src.[fldcomorbothercomm], src.[fldServices], src.[fldexserAMHTID], src.[fldexseryouthoffID], src.[fldexserCAMHSID], src.[fldexserinpatwardID], src.[fldexserdrugalcID], src.[fldexserothrID], src.[fldExtServRead], src.[fldextServcomm], src.[fldposdelID], src.[fldposcondisorgID], src.[fldposhallbehID], src.[fldposexciteID], src.[fldposgrandID], src.[fldpossuspID], src.[fldposhostID], src.[fldnegbluntID], src.[fldnegemowithID], src.[fldnegpoorrapID], src.[fldnegpasssocwithID], src.[fldnegdiffabsID], src.[fldneglackspontID], src.[fldnegsterthinkID], src.[fldsltsofasID], src.[fldintcodedets], src.[fldintsumm], src.[fldmenhlthsatID], src.[fldaddhlpmenhlthID], src.[fldaddhlpdetsmenhlth], src.[fldperhlthsatID], src.[fldaddhlpperhlthID], src.[fldaddhlpdetsperhlth], src.[fldjobsatID], src.[fldaddhlpjobID], src.[fldaddhlpdetsjob], src.[fldaccomsatID], src.[fldaddhlpaccomID], src.[fldaddhlpdetsaccom], src.[fldleisactsatID], src.[fldaddhlpleisactID], src.[fldaddhlpdetsleisact], src.[fldfriendsatID], src.[fldaddhlpfriendID], src.[fldaddhlpdetsfriend], src.[fldpartfamsatID], src.[fldaddhlpfamsatID], src.[fldaddhlpdetsfamsat], src.[fldpersafesatID], src.[fldaddhlppersafeID], src.[fldaddhlpdetspersafe], src.[fldmedsatID], src.[fldaddhlpmedID], src.[fldaddhlpdetsmed], src.[fldprachlpsatID], src.[fldaddhlpID], src.[fldaddhlpdets], src.[fldmenhlthconsultsatID], src.[fldaddhlpmenhlthconsultID], src.[fldaddhlpdetsmenhlthconsult], src.[fldqprbtrmyslfID], src.[fldqprchncsID], src.[fldqprposrelID], src.[fldqprprtsocID], src.[fldqprassertID], src.[fldqprlifepurpID], src.[fldqprexpchngbtrID], src.[fldqprpastevntsID], src.[fldqprmotbtrID], src.[fldqprpostngsID], src.[fldqprundrstndmyslfID], src.[fldqprchrgoflifeID], src.[fldqprengwlifeID], src.[fldqprcontmylifeID], src.[fldqprtimeienjyID], src.[fldEIPdate0], src.[fldEIPdrop0ID], src.[fldEIPdate1], src.[fldEIPdrop1ID], src.[fldEIPdate2], src.[fldEIPdrop2ID], src.[fldEIPdate3], src.[fldEIPdrop3ID], src.[fldEIPdate4], src.[fldEIPdrop4ID], src.[fldEIPdate5], src.[fldEIPdrop5ID], src.[fldEIPdate6], src.[fldEIPdrop6ID], src.[fldEIPdate7], src.[fldEIPdrop7ID], src.[fldEIPdate8], src.[fldEIPdrop8ID], src.[fldEIPdate9], src.[fldEIPdrop9ID], src.[fldEIPdate10], src.[fldEIPdrop10ID], src.[fldEIPdate11], src.[fldEIPdrop11ID], src.[fldEIPdate12], src.[fldEIPdrop12ID], src.[fldEIPdate13], src.[fldEIPdrop13ID], src.[fldEIPdate14], src.[fldEIPdrop14ID], src.[fldEIPdate15], src.[fldEIPdrop15ID], src.[fldEIPdate16], src.[fldEIPdrop16ID], src.[flgAssessType], src.[flgCAARMS], src.[flgcomorbchk], src.[flgcomorbothr], src.[flgintcodedets], src.[flgExtServ], src.[flgDIALOG0], src.[flgDIALOG1], src.[flgDIALOG2], src.[flgDIALOG3], src.[flgDIALOG4], src.[flgDIALOG5], src.[flgDIALOG6], src.[flgDIALOG7], src.[flgDIALOG8], src.[flgDIALOG9], src.[flgDIALOG10], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm], src.[fldEnteredDate], src.[fldEnteredTime], src.[StartTime]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[udfEISCommonAssessmentv2] AS src
							INNER JOIN (SELECT wrk.[EISCommonAssessmentv2_ID] FROM mrr_wrk.CNS_udfEISCommonAssessmentv2 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNS_udfEISCommonAssessmentv2 AS tgt
										WHERE wrk.[EISCommonAssessmentv2_ID] = tgt.[EISCommonAssessmentv2_ID]
									)
								) MissingRecs ON (MissingRecs.[EISCommonAssessmentv2_ID] = src.[EISCommonAssessmentv2_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNS_udfEISCommonAssessmentv2
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNS_udfEISCommonAssessmentv2

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
