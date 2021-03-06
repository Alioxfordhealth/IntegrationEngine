SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspDBS_Load_MentalHealth_DBSFiles]
AS

DECLARE @sql VARCHAR(MAX)
DECLARE @cnt VARCHAR(10) = ISNULL((SELECT NumberOfRecord + 1 FROM [dbo].[tblDBSExtractsAudit] WHERE ExtractID = (SELECT MAX(ExtractID) FROM [dbo].[tblDBSExtractsAudit] WHERE DataSource = 'CNS') ),0)

SET @sql = '
BEGIN TRY
	BEGIN TRANSACTION;

	TRUNCATE TABLE [src_DBS].[tblCNS_DBSTraceReturnedFile]

	BULK INSERT [src_DBS].[vwCNS_DBSTraceReturnedFile]
			FROM ''\\mhoxbit01\Extracts\DBS\DBSResponse\MH_DBS_IE_Extract_Final.csv''
			WITH
		(    CODEPAGE =  ''1252''
			, FIRSTROW = 2
			, LASTROW = '+@cnt+'
			,  FIELDTERMINATOR = ''","''
			, ROWTERMINATOR = ''0x0a''
		)
	COMMIT TRANSACTION

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
'
PRINT @sql 
EXEC (@sql)


GO
