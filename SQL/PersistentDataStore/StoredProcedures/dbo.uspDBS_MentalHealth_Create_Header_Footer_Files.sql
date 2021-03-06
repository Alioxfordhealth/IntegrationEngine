SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[uspDBS_MentalHealth_Create_Header_Footer_Files](
@folder varchar(1000),
@headerFooter VARCHAR(10)
)
AS
BEGIN TRY
	IF @headerFooter IN ('header','footer') 
	BEGIN
		--DECLARE @folder varchar(1000) = '''\\mhoxbit01\Extracts\DBS\'
		DECLARE @filename varchar(100) = 'MH_DBS_Extract_'+@headerFooter+'.csv'

		DECLARE @sql varchar(max)
		DECLARE @cnt BIGINT = (SELECT COUNT(*) FROM Mirror.mrr.CNS_tblPatient)

		DECLARE @header VARCHAR(100) = '0001011RNU           DBS           '+REPLACE(CONVERT(VARCHAR,GETDATE(),108),':','')+CONVERT(VARCHAR(8),GETDATE(), 112)+'00000001'+CAST(@cnt AS VARCHAR)
		DECLARE @footer VARCHAR(100) = '990101RNU           DBS           '+REPLACE(CONVERT(VARCHAR,GETDATE(),108),':','')+CONVERT(VARCHAR(8),GETDATE(), 112)+'00000001'+CAST(@cnt AS VARCHAR)


			SET @sql = '
			DECLARE @filename VARCHAR(255) = '''+@folder+@filename+'''
			DECLARE   @Object int
			DECLARE   @rc int
			DECLARE   @FileID Int

			EXEC @rc = sp_OACreate ''Scripting.FileSystemObject'', @Object OUT
			EXEC @rc = sp_OAMethod @Object , ''OpenTextFile'' , @FileID OUT , @Filename , 2 , 1
			EXEC @rc = sp_OAMethod @FileID , ''WriteLine'' , Null , '''+ CASE WHEN @headerFooter = 'header' THEN @header ELSE @footer END +'''
			EXEC @rc = dbo.sp_OADestroy @FileID

			DECLARE @Append BIT 

			SELECT  @Append = 0

			IF  @rc <> 0
			BEGIN 
				EXEC  @rc = dbo.sp_OAMethod @Object, ''SaveFile'',null,'' '' ,@Filename,@Append
			END 

			EXEC  @rc = dbo.sp_OADestroy @Object'

			PRINT (@sql)
			EXEC (@sql)
	END
    ELSE
	BEGIN
		RAISERROR ('Second parameter should be either "header" or "footer"', 0, 1) WITH NOWAIT
    END 
END TRY
BEGIN CATCH
	PRINT 'Second parameter should be either "header" or "footer"'
END CATCH
GO
