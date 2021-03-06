SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table incrementally.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CNC_udfHeartFailurev4
				EXECUTE mrr_tbl.load_CNC_udfHeartFailurev4 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CNC_udfHeartFailurev4]
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
							SELECT COUNT(*) FROM mrr_tbl.CNC_udfHeartFailurev4
						);

						--	Load working table from source.
						BEGIN TRANSACTION; -- INSERT INTO mrr_wrk.CNC_udfHeartFailurev4

						TRUNCATE TABLE mrr_wrk.CNC_udfHeartFailurev4;

						INSERT INTO mrr_wrk.CNC_udfHeartFailurev4
						(
							[HeartFailurev4_ID], [Updated_Dttm]
						)
						SELECT [HeartFailurev4_ID], [Updated_Dttm]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[udfHeartFailurev4];

						--	How many records in working table?
						SET @WorkingCount = @@ROWCOUNT;

						COMMIT TRANSACTION; -- INSERT INTO mrr_wrk.CNC_udfHeartFailurev4

						--	If 0 records in target or ABS(nW-nT) > Threshold force a Truncate/Insert. --TODO not ideal test but achievable without slowing the procedure down too much.
						IF ABS(@WorkingCount - @OriginalTargetCount) >= CAST((@OriginalTargetCount * @Threshold / 100) AS INTEGER)
							SET @LoadType = 'F';

						BEGIN TRANSACTION; -- Start transaction for the load and audit.

						--	We now do either a full (F) reload of the target or an incremental (I) load depending on what has been requested or how much data is changing.
						IF @LoadType = 'F'
						BEGIN
							--	Full load target from source.

							TRUNCATE TABLE mrr_tbl.CNC_udfHeartFailurev4;

							INSERT INTO mrr_tbl.CNC_udfHeartFailurev4
							(
								[HeartFailurev4_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldService], [fldServEmail], [fldServTele], [fldSessionTypeID], [fldPatInfo], [fldDNACPRID], [fldResearchDiscussedID], [fldProjDiscussedID], [fldResProjDetails], [fldLVSDID], [fldEjectFrac], [fldEchoOutcomesID], [fldchkIschaemicID], [fldchkDCMID], [fldchkCardiomyopathyID], [fldchknonLVSDID], [fldchkValvularID], [fldchkAlchCardiomyopID], [fldchkCongHeartID], [fldchkUnknownID], [fldchkHypertenseID], [fldchkRestCardiomyopID], [fldchkInhHeartID], [fldchkOtherID], [fldAeitologyOther], [fldIschHeartID], [fldIschHeartDetails], [fldValveDiseaseID], [fldValveDiseaseDetails], [fldHypertensionID], [fldHypertensionDetails], [fldArrhythmiaID], [fldArrhythmiaDetails], [fldDiabetesID], [fldDiabetesDetails], [fldChronKidDiseaseID], [fldChronKidDiseaseDetails], [fldAsthmaID], [fldAsthmaDetails], [fldCOPDID], [fldCOPDDetails], [fldCerebroAccID], [fldCerebroAccDetails], [fldPeriVascDiseaseID], [fldPeriVascDiseaseDetails], [fldAnaemiaID], [fldAnaemiaDetails], [fldOthrMedHist], [fldDeviceID], [fldDeviceDate], [fldDeviceDetails], [fldCoroAngioID], [fldCoroAngioDetails], [fldPCIID], [fldPCIDetails], [fldCABGID], [fldCABGDetails], [flddrug1ID], [flddose1], [fldfreq1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldfreq2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldfreq3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldfreq4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldfreq5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldfreq6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldfreq7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldfreq8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldfreq9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldfreq10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldfreq11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldfreq12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldfreq13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldfreq14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldfreq15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldfreq16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldfreq17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldfreq18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldfreq19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldfreq20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldfreq21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldfreq22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldfreq23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldfreq24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldfreq25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldFutureMeds], [fldHeartFailMed], [fldOthrRelMed], [fldBreathlessness], [fldMobLimit], [fldOrthopnoea], [fldPND], [fldOedema], [fldAscites], [fldChest], [fldCough], [fldFldIntake], [fldAngina], [fldPalpitations], [fldDizziness], [fldFatigue], [fldECGFind], [fldCardiacRehabID], [fldCBTRevID], [fldWeight], [fldSittingBP], [fldStandingBP], [fldHeartRythID], [fldPulse], [fldResp], [fldSpO2], [fldTemp], [fldNYHAID], [fldMUST], [fldBraden], [fldDetsPlanAction], [flgchknewform], [flgchkDNACPR], [flgchkAetiologyOther], [flgchkIschHeart], [flgchkValveDisease], [flgchkHypertension], [flgchkArrhythmia], [flgchkDiabetes], [flgchkChronKidDisease], [flgchkAsthma], [flgchkCOPD], [flgchkCerebroAcc], [flgchkPeriVascDisease], [flgchkAnaemia], [flgchkCoroAngio], [flgchkPCI], [flgchkCABG], [flgchkResearch], [flgchkDevice], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT [HeartFailurev4_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldService], [fldServEmail], [fldServTele], [fldSessionTypeID], [fldPatInfo], [fldDNACPRID], [fldResearchDiscussedID], [fldProjDiscussedID], [fldResProjDetails], [fldLVSDID], [fldEjectFrac], [fldEchoOutcomesID], [fldchkIschaemicID], [fldchkDCMID], [fldchkCardiomyopathyID], [fldchknonLVSDID], [fldchkValvularID], [fldchkAlchCardiomyopID], [fldchkCongHeartID], [fldchkUnknownID], [fldchkHypertenseID], [fldchkRestCardiomyopID], [fldchkInhHeartID], [fldchkOtherID], [fldAeitologyOther], [fldIschHeartID], [fldIschHeartDetails], [fldValveDiseaseID], [fldValveDiseaseDetails], [fldHypertensionID], [fldHypertensionDetails], [fldArrhythmiaID], [fldArrhythmiaDetails], [fldDiabetesID], [fldDiabetesDetails], [fldChronKidDiseaseID], [fldChronKidDiseaseDetails], [fldAsthmaID], [fldAsthmaDetails], [fldCOPDID], [fldCOPDDetails], [fldCerebroAccID], [fldCerebroAccDetails], [fldPeriVascDiseaseID], [fldPeriVascDiseaseDetails], [fldAnaemiaID], [fldAnaemiaDetails], [fldOthrMedHist], [fldDeviceID], [fldDeviceDate], [fldDeviceDetails], [fldCoroAngioID], [fldCoroAngioDetails], [fldPCIID], [fldPCIDetails], [fldCABGID], [fldCABGDetails], [flddrug1ID], [flddose1], [fldfreq1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldfreq2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldfreq3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldfreq4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldfreq5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldfreq6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldfreq7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldfreq8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldfreq9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldfreq10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldfreq11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldfreq12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldfreq13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldfreq14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldfreq15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldfreq16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldfreq17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldfreq18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldfreq19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldfreq20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldfreq21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldfreq22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldfreq23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldfreq24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldfreq25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldFutureMeds], [fldHeartFailMed], [fldOthrRelMed], [fldBreathlessness], [fldMobLimit], [fldOrthopnoea], [fldPND], [fldOedema], [fldAscites], [fldChest], [fldCough], [fldFldIntake], [fldAngina], [fldPalpitations], [fldDizziness], [fldFatigue], [fldECGFind], [fldCardiacRehabID], [fldCBTRevID], [fldWeight], [fldSittingBP], [fldStandingBP], [fldHeartRythID], [fldPulse], [fldResp], [fldSpO2], [fldTemp], [fldNYHAID], [fldMUST], [fldBraden], [fldDetsPlanAction], [flgchknewform], [flgchkDNACPR], [flgchkAetiologyOther], [flgchkIschHeart], [flgchkValveDisease], [flgchkHypertension], [flgchkArrhythmia], [flgchkDiabetes], [flgchkChronKidDisease], [flgchkAsthma], [flgchkCOPD], [flgchkCerebroAcc], [flgchkPeriVascDisease], [flgchkAnaemia], [flgchkCoroAngio], [flgchkPCI], [flgchkCABG], [flgchkResearch], [flgchkDevice], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[udfHeartFailurev4];

							SET @Inserted = @@ROWCOUNT;

						END;
						--	Else load target incrementally...
						ELSE
						BEGIN

							--	Delete from target where target PK not in working table. --TODO We can save time by doing deletes and updated together but then we wouldn not be able to report separate counts for deleted/updated/inserted.
							DELETE tgt
							FROM mrr_tbl.CNC_udfHeartFailurev4 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_udfHeartFailurev4 AS src
								WHERE tgt.[HeartFailurev4_ID] = src.[HeartFailurev4_ID]
							);
							--	How many deleted?
							SET @Deleted = @@ROWCOUNT;

							--	Delete from target where working table PK & ChangeDetectionColumn not in target.
							DELETE tgt
							FROM mrr_tbl.CNC_udfHeartFailurev4 AS tgt
							WHERE NOT EXISTS
							(
								SELECT NULL
								FROM mrr_wrk.CNC_udfHeartFailurev4 AS src
								WHERE tgt.[HeartFailurev4_ID] = src.[HeartFailurev4_ID] AND tgt.[Updated_Dttm] = src.[Updated_Dttm]
							);
							--	How many updated?
							SET @Updated = @@ROWCOUNT;

							--		Insert into Target from source where working table PK & ChangeDetectionColumn not in target.
							INSERT INTO mrr_tbl.CNC_udfHeartFailurev4
							(
								[HeartFailurev4_ID], [Patient_ID], [Confirm_Flag_ID], [Confirm_Date], [Confirm_Time], [Confirm_Staff_Name], [Confirm_Staff_Job_Title], [OriginalAuthorID], [fldEnteredDate], [fldEnteredTime], [StartDate], [StartTime], [ReplanRequested], [DocumentGroupIdentifier], [PreviousCNObjectID], [fldService], [fldServEmail], [fldServTele], [fldSessionTypeID], [fldPatInfo], [fldDNACPRID], [fldResearchDiscussedID], [fldProjDiscussedID], [fldResProjDetails], [fldLVSDID], [fldEjectFrac], [fldEchoOutcomesID], [fldchkIschaemicID], [fldchkDCMID], [fldchkCardiomyopathyID], [fldchknonLVSDID], [fldchkValvularID], [fldchkAlchCardiomyopID], [fldchkCongHeartID], [fldchkUnknownID], [fldchkHypertenseID], [fldchkRestCardiomyopID], [fldchkInhHeartID], [fldchkOtherID], [fldAeitologyOther], [fldIschHeartID], [fldIschHeartDetails], [fldValveDiseaseID], [fldValveDiseaseDetails], [fldHypertensionID], [fldHypertensionDetails], [fldArrhythmiaID], [fldArrhythmiaDetails], [fldDiabetesID], [fldDiabetesDetails], [fldChronKidDiseaseID], [fldChronKidDiseaseDetails], [fldAsthmaID], [fldAsthmaDetails], [fldCOPDID], [fldCOPDDetails], [fldCerebroAccID], [fldCerebroAccDetails], [fldPeriVascDiseaseID], [fldPeriVascDiseaseDetails], [fldAnaemiaID], [fldAnaemiaDetails], [fldOthrMedHist], [fldDeviceID], [fldDeviceDate], [fldDeviceDetails], [fldCoroAngioID], [fldCoroAngioDetails], [fldPCIID], [fldPCIDetails], [fldCABGID], [fldCABGDetails], [flddrug1ID], [flddose1], [fldfreq1], [fldroute1ID], [fldprsbr1ID], [fldcomm1], [flddrug2ID], [flddose2], [fldfreq2], [fldroute2ID], [fldprsbr2ID], [fldcomm2], [flddrug3ID], [flddose3], [fldfreq3], [fldroute3ID], [fldprsbr3ID], [fldcomm3], [flddrug4ID], [flddose4], [fldfreq4], [fldroute4ID], [fldprsbr4ID], [fldcomm4], [flddrug5ID], [flddose5], [fldfreq5], [fldroute5ID], [fldprsbr5ID], [fldcomm5], [flddrug6ID], [flddose6], [fldfreq6], [fldroute6ID], [fldprsbr6ID], [fldcomm6], [flddrug7ID], [flddose7], [fldfreq7], [fldroute7ID], [fldprsbr7ID], [fldcomm7], [flddrug8ID], [flddose8], [fldfreq8], [fldroute8ID], [fldprsbr8ID], [fldcomm8], [flddrug9ID], [flddose9], [fldfreq9], [fldroute9ID], [fldprsbr9ID], [fldcomm9], [flddrug10ID], [flddose10], [fldfreq10], [fldroute10ID], [fldprsbr10ID], [fldcomm10], [flddrug11ID], [flddose11], [fldfreq11], [fldroute11ID], [fldprsbr11ID], [fldcomm11], [flddrug12ID], [flddose12], [fldfreq12], [fldroute12ID], [fldprsbr12ID], [fldcomm12], [flddrug13ID], [flddose13], [fldfreq13], [fldroute13ID], [fldprsbr13ID], [fldcomm13], [flddrug14ID], [flddose14], [fldfreq14], [fldroute14ID], [fldprsbr14ID], [fldcomm14], [flddrug15ID], [flddose15], [fldfreq15], [fldroute15ID], [fldprsbr15ID], [fldcomm15], [flddrug16ID], [flddose16], [fldfreq16], [fldroute16ID], [fldprsbr16ID], [fldcomm16], [flddrug17ID], [flddose17], [fldfreq17], [fldroute17ID], [fldprsbr17ID], [fldcomm17], [flddrug18ID], [flddose18], [fldfreq18], [fldroute18ID], [fldprsbr18ID], [fldcomm18], [flddrug19ID], [flddose19], [fldfreq19], [fldroute19ID], [fldprsbr19ID], [fldcomm19], [flddrug20ID], [flddose20], [fldfreq20], [fldroute20ID], [fldprsbr20ID], [fldcomm20], [flddrug21ID], [flddose21], [fldfreq21], [fldroute21ID], [fldprsbr21ID], [fldcomm21], [flddrug22ID], [flddose22], [fldfreq22], [fldroute22ID], [fldprsbr22ID], [fldcomm22], [flddrug23ID], [flddose23], [fldfreq23], [fldroute23ID], [fldprsbr23ID], [fldcomm23], [flddrug24ID], [flddose24], [fldfreq24], [fldroute24ID], [fldprsbr24ID], [fldcomm24], [flddrug25ID], [flddose25], [fldfreq25], [fldroute25ID], [fldprsbr25ID], [fldcomm25], [fldFutureMeds], [fldHeartFailMed], [fldOthrRelMed], [fldBreathlessness], [fldMobLimit], [fldOrthopnoea], [fldPND], [fldOedema], [fldAscites], [fldChest], [fldCough], [fldFldIntake], [fldAngina], [fldPalpitations], [fldDizziness], [fldFatigue], [fldECGFind], [fldCardiacRehabID], [fldCBTRevID], [fldWeight], [fldSittingBP], [fldStandingBP], [fldHeartRythID], [fldPulse], [fldResp], [fldSpO2], [fldTemp], [fldNYHAID], [fldMUST], [fldBraden], [fldDetsPlanAction], [flgchknewform], [flgchkDNACPR], [flgchkAetiologyOther], [flgchkIschHeart], [flgchkValveDisease], [flgchkHypertension], [flgchkArrhythmia], [flgchkDiabetes], [flgchkChronKidDisease], [flgchkAsthma], [flgchkCOPD], [flgchkCerebroAcc], [flgchkPeriVascDisease], [flgchkAnaemia], [flgchkCoroAngio], [flgchkPCI], [flgchkCABG], [flgchkResearch], [flgchkDevice], [User_Created], [Create_Dttm], [User_Updated], [Updated_Dttm]
							)
							SELECT src.[HeartFailurev4_ID], src.[Patient_ID], src.[Confirm_Flag_ID], src.[Confirm_Date], src.[Confirm_Time], src.[Confirm_Staff_Name], src.[Confirm_Staff_Job_Title], src.[OriginalAuthorID], src.[fldEnteredDate], src.[fldEnteredTime], src.[StartDate], src.[StartTime], src.[ReplanRequested], src.[DocumentGroupIdentifier], src.[PreviousCNObjectID], src.[fldService], src.[fldServEmail], src.[fldServTele], src.[fldSessionTypeID], src.[fldPatInfo], src.[fldDNACPRID], src.[fldResearchDiscussedID], src.[fldProjDiscussedID], src.[fldResProjDetails], src.[fldLVSDID], src.[fldEjectFrac], src.[fldEchoOutcomesID], src.[fldchkIschaemicID], src.[fldchkDCMID], src.[fldchkCardiomyopathyID], src.[fldchknonLVSDID], src.[fldchkValvularID], src.[fldchkAlchCardiomyopID], src.[fldchkCongHeartID], src.[fldchkUnknownID], src.[fldchkHypertenseID], src.[fldchkRestCardiomyopID], src.[fldchkInhHeartID], src.[fldchkOtherID], src.[fldAeitologyOther], src.[fldIschHeartID], src.[fldIschHeartDetails], src.[fldValveDiseaseID], src.[fldValveDiseaseDetails], src.[fldHypertensionID], src.[fldHypertensionDetails], src.[fldArrhythmiaID], src.[fldArrhythmiaDetails], src.[fldDiabetesID], src.[fldDiabetesDetails], src.[fldChronKidDiseaseID], src.[fldChronKidDiseaseDetails], src.[fldAsthmaID], src.[fldAsthmaDetails], src.[fldCOPDID], src.[fldCOPDDetails], src.[fldCerebroAccID], src.[fldCerebroAccDetails], src.[fldPeriVascDiseaseID], src.[fldPeriVascDiseaseDetails], src.[fldAnaemiaID], src.[fldAnaemiaDetails], src.[fldOthrMedHist], src.[fldDeviceID], src.[fldDeviceDate], src.[fldDeviceDetails], src.[fldCoroAngioID], src.[fldCoroAngioDetails], src.[fldPCIID], src.[fldPCIDetails], src.[fldCABGID], src.[fldCABGDetails], src.[flddrug1ID], src.[flddose1], src.[fldfreq1], src.[fldroute1ID], src.[fldprsbr1ID], src.[fldcomm1], src.[flddrug2ID], src.[flddose2], src.[fldfreq2], src.[fldroute2ID], src.[fldprsbr2ID], src.[fldcomm2], src.[flddrug3ID], src.[flddose3], src.[fldfreq3], src.[fldroute3ID], src.[fldprsbr3ID], src.[fldcomm3], src.[flddrug4ID], src.[flddose4], src.[fldfreq4], src.[fldroute4ID], src.[fldprsbr4ID], src.[fldcomm4], src.[flddrug5ID], src.[flddose5], src.[fldfreq5], src.[fldroute5ID], src.[fldprsbr5ID], src.[fldcomm5], src.[flddrug6ID], src.[flddose6], src.[fldfreq6], src.[fldroute6ID], src.[fldprsbr6ID], src.[fldcomm6], src.[flddrug7ID], src.[flddose7], src.[fldfreq7], src.[fldroute7ID], src.[fldprsbr7ID], src.[fldcomm7], src.[flddrug8ID], src.[flddose8], src.[fldfreq8], src.[fldroute8ID], src.[fldprsbr8ID], src.[fldcomm8], src.[flddrug9ID], src.[flddose9], src.[fldfreq9], src.[fldroute9ID], src.[fldprsbr9ID], src.[fldcomm9], src.[flddrug10ID], src.[flddose10], src.[fldfreq10], src.[fldroute10ID], src.[fldprsbr10ID], src.[fldcomm10], src.[flddrug11ID], src.[flddose11], src.[fldfreq11], src.[fldroute11ID], src.[fldprsbr11ID], src.[fldcomm11], src.[flddrug12ID], src.[flddose12], src.[fldfreq12], src.[fldroute12ID], src.[fldprsbr12ID], src.[fldcomm12], src.[flddrug13ID], src.[flddose13], src.[fldfreq13], src.[fldroute13ID], src.[fldprsbr13ID], src.[fldcomm13], src.[flddrug14ID], src.[flddose14], src.[fldfreq14], src.[fldroute14ID], src.[fldprsbr14ID], src.[fldcomm14], src.[flddrug15ID], src.[flddose15], src.[fldfreq15], src.[fldroute15ID], src.[fldprsbr15ID], src.[fldcomm15], src.[flddrug16ID], src.[flddose16], src.[fldfreq16], src.[fldroute16ID], src.[fldprsbr16ID], src.[fldcomm16], src.[flddrug17ID], src.[flddose17], src.[fldfreq17], src.[fldroute17ID], src.[fldprsbr17ID], src.[fldcomm17], src.[flddrug18ID], src.[flddose18], src.[fldfreq18], src.[fldroute18ID], src.[fldprsbr18ID], src.[fldcomm18], src.[flddrug19ID], src.[flddose19], src.[fldfreq19], src.[fldroute19ID], src.[fldprsbr19ID], src.[fldcomm19], src.[flddrug20ID], src.[flddose20], src.[fldfreq20], src.[fldroute20ID], src.[fldprsbr20ID], src.[fldcomm20], src.[flddrug21ID], src.[flddose21], src.[fldfreq21], src.[fldroute21ID], src.[fldprsbr21ID], src.[fldcomm21], src.[flddrug22ID], src.[flddose22], src.[fldfreq22], src.[fldroute22ID], src.[fldprsbr22ID], src.[fldcomm22], src.[flddrug23ID], src.[flddose23], src.[fldfreq23], src.[fldroute23ID], src.[fldprsbr23ID], src.[fldcomm23], src.[flddrug24ID], src.[flddose24], src.[fldfreq24], src.[fldroute24ID], src.[fldprsbr24ID], src.[fldcomm24], src.[flddrug25ID], src.[flddose25], src.[fldfreq25], src.[fldroute25ID], src.[fldprsbr25ID], src.[fldcomm25], src.[fldFutureMeds], src.[fldHeartFailMed], src.[fldOthrRelMed], src.[fldBreathlessness], src.[fldMobLimit], src.[fldOrthopnoea], src.[fldPND], src.[fldOedema], src.[fldAscites], src.[fldChest], src.[fldCough], src.[fldFldIntake], src.[fldAngina], src.[fldPalpitations], src.[fldDizziness], src.[fldFatigue], src.[fldECGFind], src.[fldCardiacRehabID], src.[fldCBTRevID], src.[fldWeight], src.[fldSittingBP], src.[fldStandingBP], src.[fldHeartRythID], src.[fldPulse], src.[fldResp], src.[fldSpO2], src.[fldTemp], src.[fldNYHAID], src.[fldMUST], src.[fldBraden], src.[fldDetsPlanAction], src.[flgchknewform], src.[flgchkDNACPR], src.[flgchkAetiologyOther], src.[flgchkIschHeart], src.[flgchkValveDisease], src.[flgchkHypertension], src.[flgchkArrhythmia], src.[flgchkDiabetes], src.[flgchkChronKidDisease], src.[flgchkAsthma], src.[flgchkCOPD], src.[flgchkCerebroAcc], src.[flgchkPeriVascDisease], src.[flgchkAnaemia], src.[flgchkCoroAngio], src.[flgchkPCI], src.[flgchkCABG], src.[flgchkResearch], src.[flgchkDevice], src.[User_Created], src.[Create_Dttm], src.[User_Updated], src.[Updated_Dttm]
							FROM [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[udfHeartFailurev4] AS src
							INNER JOIN (SELECT wrk.[HeartFailurev4_ID] FROM mrr_wrk.CNC_udfHeartFailurev4 wrk
									WHERE NOT EXISTS
									(
										SELECT NULL
										FROM mrr_tbl.CNC_udfHeartFailurev4 AS tgt
										WHERE wrk.[HeartFailurev4_ID] = tgt.[HeartFailurev4_ID]
									)
								) MissingRecs ON (MissingRecs.[HeartFailurev4_ID] = src.[HeartFailurev4_ID]);


							--	How many really inserted? ROWCOUNT = inserted + updated records.
							SET @Inserted = @@ROWCOUNT - @Updated;

						--		Truncate working table? --TODO decide.
						END;

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CNC_udfHeartFailurev4
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CNC_udfHeartFailurev4

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
						THROW;
					END CATCH;

				END;
				
GO
