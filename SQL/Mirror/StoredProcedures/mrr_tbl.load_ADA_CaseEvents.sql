SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

				/*==========================================================================================================================================
				Notes:
				Template for loading Mirror table in full load mode only.

				TODO Is this the right place for the transactions? Should transaction handling be external to this procedure?

				Test:

				EXECUTE mrr_tbl.load_ADA_CaseEvents
				EXECUTE mrr_tbl.load_ADA_CaseEvents 'F'

				History:
				11/04/2018 OBMH\Steve.Nicoll Initial version.

				==========================================================================================================================================*/

				CREATE PROCEDURE [mrr_tbl].[load_ADA_CaseEvents]
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

						--07/06/2019  FS added
						DECLARE @MaxDate DATETIME = ISNULL((SELECT MAX(CreationDate)  FROM mrr_tbl.ADA_CaseEvents ),'1 Jan 1900')

						IF OBJECT_ID('dbo.tmpADACaseEvents6789','U') IS NOT NULL
						DROP TABLE dbo.tmpADACaseEvents6789

						SELECT EventRef
						INTO dbo.tmpADACaseEvents6789
						FROM [MHOXCARESQL01\MHOXCARESQL01].Adastra3Oxford.dbo.[CaseEvents] 
						WHERE CreationDate > @MaxDate

						-- 07/06/2019 FS changes 
						--TRUNCATE TABLE mrr_tbl.ADA_CaseEvents;
						DELETE FROM mrr_tbl.ADA_CaseEvents
						FROM mrr_tbl.ADA_CaseEvents pat
						WHERE EXISTS (SELECT 1 FROM dbo.tmpADACaseEvents6789 tmp WHERE tmp.EventRef = pat.EventRef)


						INSERT INTO mrr_tbl.ADA_CaseEvents
						(
							[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						)
						SELECT c.[EventRef], [CaseRef], [EventType], [EntryDate], [StartDate], [FinishDate], [Summary], [Ref], [UserComments], [UserRef], [UserDescription], [SyncRequired], [EventDescription], [MasterEventRef], [CaseStatus], [Obsolete], [ObsoleteByRef], [ObsoleteByDescription], [ObsoleteDate], [ObsoleteMasterEventRef], [CreationDate], [LocationRef], [Editable], [CaseAuditRef], [BeforeCaseAuditRef], [AremoteDeviceRef], [SessionRef]
						FROM [MHOXCARESQL01\MHOXCARESQL01].[Adastra3Oxford].[dbo].[CaseEvents] c
						INNER JOIN dbo.tmpADACaseEvents6789 tmp ON  tmp.EventRef = c.EventRef;

						SET @Inserted = @@ROWCOUNT;
						SET @Deleted = @Inserted; -- TODO This is not right but as we do TRUNCATE rather than DELETE it is the best we can do for now.

						--	Update audit table.
						SET @EndTime = GETDATE();

						INSERT INTO mrr_aud.ADA_CaseEvents
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
						COMMIT TRANSACTION; -- INSERT INTO mrr_aud.ADA_CaseEvents

					END TRY
					--Catch if transaction open roll it back.
					BEGIN CATCH
						IF @@TRANCOUNT > 0
							ROLLBACK TRANSACTION;
							THROW;
					END CATCH;

				END;
				
GO
