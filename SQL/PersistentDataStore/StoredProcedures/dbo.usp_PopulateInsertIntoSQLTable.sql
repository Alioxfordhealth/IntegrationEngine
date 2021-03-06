SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_PopulateInsertIntoSQLTable](
@tableSchema VARCHAR(200),
@tableName VARCHAR(200)
)


/*


Change Log:
===========
FS 01-Nov-2019 changed the @tableSchema to dbo for the insert into script. and also added replace to change table prefix 'tbl' to 'udf'

TEST
======
EXEC [dbo].[usp_PopulateInsertIntoSQLTable] 'ORU_SRC','tblORU_OBX_Observation'

*/



AS
BEGIN

--DECLARE @tableName VARCHAR(200) = 'tblORU_OBX_Observation'
--DECLARE @tableSchema VARCHAR(200) = 'ORU_SRC'


DECLARE TablesCursor CURSOR FAST_FORWARD FOR 
SELECT column_name,data_type FROM information_schema.columns 
    WHERE table_name = @tableName

OPEN TablesCursor

DECLARE @string VARCHAR(8000) --for storing the first half of INSERT statement
DECLARE @stringData VARCHAR(8000) --for storing the data (VALUES) related statement
DECLARE @dataType VARCHAR(1000) --data types returned for respective columns

-- FS 1-Nov-2019
--SET @string='INSERT INTO '+@tableSchema+'.'+@tableName+'('
SET @string='INSERT INTO dbo.'+replace(@tableName,'tbl','udf')+'('

SET @stringData=''

DECLARE @colName VARCHAR(150)

FETCH NEXT FROM TablesCursor INTO @colName,@dataType

IF @@fetch_status<>0
    BEGIN
    print 'Table '+@tableSchema+'.'+@tableName+' not found, processing skipped.'
    close TablesCursor
    deallocate TablesCursor
    return
END

WHILE @@FETCH_STATUS=0
BEGIN
		IF @dataType in ('VARCHAR','char','nchar','VARCHAR')
		BEGIN
			SET @stringData=@stringData+'''''''''+
			['+@colName+']+'''''',''+'
		END
		ELSE
		IF @dataType in ('text','ntext') --if the datatype 
										 --is text or something else 
		BEGIN
			SET @stringData=@stringData+'''''''''+
			ISNULL(CAST('+@colName+' as VARCHAR(2000)),'''')+'''''',''+'
		END
		ELSE
		IF @dataType = 'money' --because money doesn't get CONVERTed from VARCHAR implicitly
		BEGIN
			SET @stringData=@stringData+'''CONVERT(money,''''''+
			ISNULL(CAST('+@colName+' as VARCHAR(200)),''0.0000'')+''''''),''+'
		END
		ELSE 
		IF @dataType='DATETIME'
		BEGIN
			SET @stringData=@stringData+'''CONVERT(DATETIME,''''''+
			ISNULL(CAST('+@colName+' as VARCHAR(200)),''0'')+''''''),''+'
		END
		ELSE 
		IF @dataType='image' 
		BEGIN
			SET @stringData=@stringData+'''''''''+
			ISNULL(CAST(CONVERT(varbinary,'+@colName+') 
			as VARCHAR(6)),''0'')+'''''',''+'
		END
		ELSE --presuming the data type is int,bit,numeric,decimal 
		BEGIN
			SET @stringData=@stringData+'''''''''+
			ISNULL(CAST('+@colName+' as VARCHAR(200)),''0'')+'''''',''+'
		END

		SET @string=@string+@colName+','


FETCH NEXT FROM TablesCursor INTO @colName,@dataType
END

CLOSE TablesCursor
DEALLOCATE TablesCursor


-- POPULATE dbo.tblInsertIntoScript table

BEGIN TRY
	BEGIN TRANSACTION;

			DECLARE @Query nVARCHAR(4000) -- provide for the whole query, 
										  -- you may increase the size
 
			SET @query ='INSERT INTO dbo.tblInsertIntoScript SELECT * FROM (SELECT '''+substring(@string,0,len(@string)) + ') 
			  VALUES(''+ ' + substring(@stringData,0,len(@stringData)-2)+'''+'')'' as script 
			  FROM '+@tableSchema+'.'+@tableName+' WHERE [Load_Dttm] > (ISNULL((SELECT MAX([MaxUpdateTime]) FROM [dbo].[tblORU_TableTracker] WHERE TABLE_NAME = '''+@tableSchema+'.'+@tableName+''' ),''1 Jan 1900'')) ) a'

			print @query

			exec sp_executesql @query --load and run the built query 


			--Update Table_TRACKER
			DECLARE @sql2 VARCHAR(max)

			SET @sql2 = '
						DECLARE @CrntMaxDttm DATETIME
						DECLARE @NewMaxDttm DATETIME


						SET @CrntMaxDttm = ISNULL((SELECT MAX([MaxUpdateTime]) FROM [dbo].[tblORU_TableTracker] WHERE TABLE_NAME = '''+@tableSchema+'.'+@tableName+''' ),''1 Jan 1900'')
						SET @NewMaxDttm = ISNULL((SELECT MAX([Load_Dttm]) FROM '+@tableSchema+'.'+@tableName+' ),''1 Jan 1900'')

						IF @CrntMaxDttm <> @NewMaxDttm 
						BEGIN 
							INSERT INTO [dbo].[tblORU_TableTracker] VALUES ('''+@tableSchema+'.'+@tableName+''' , GETDATE()  , @NewMaxDttm)
						END '
			EXEC (@sql2)

	COMMIT TRANSACTION; 


END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;



END 

GO
