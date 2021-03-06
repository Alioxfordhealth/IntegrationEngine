SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_CCH_PatientReview
				EXECUTE mrr_tbl.load_CCH_PatientReview 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_CCH_PatientReview]
					-- Add the parameters for the stored procedure here
					@LoadType NVARCHAR(1) = 'F' -- I= Incremental, F=Truncate/Insert, value ignored for full load only loaders
				AS
				BEGIN
					DECLARE @Inserted INTEGER = 0,
							@Updated INTEGER = 0,
							@Deleted INTEGER = 0,
							@StartTime DATETIME2 = GETDATE(),
							@EndTime DATETIME2;

					-- SET NOCOUNT ON added to prevent extra result sets from
					-- interfering with statement count.
					SET NOCOUNT ON;
					--Try...
					BEGIN TRY
						BEGIN TRANSACTION;

						TRUNCATE TABLE mrr_tbl.CCH_PatientReview;

						INSERT INTO mrr_tbl.CCH_PatientReview
						(
							[Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ReviewDefinitionId], [ReviewOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [CentreId], [ReviewLocationId], [ConsultationId], [OriginalReviewId], [RemovalReasonId], [FromElectronicInterface], [ConsultationIdx], [IsScheduledBySystem], [ConsultationRevisionTag]
						)
						SELECT [Idx], [Id], [CreatedDateTime], [ExpiredDateTime], [CareNotesUserId], [ChildHealthClientVersion], [PatientId], [ReviewDefinitionId], [ReviewOutcomeId], [DateScheduled], [DateOutcome], [Removed], [OutcomedByStaffId], [CentreId], [ReviewLocationId], [ConsultationId], [OriginalReviewId], [RemovalReasonId], [FromElectronicInterface], [ConsultationIdx], [IsScheduledBySystem], [ConsultationRevisionTag]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].[dbo].[PatientReview];

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.CCH_PatientReview
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.CCH_PatientReview

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
