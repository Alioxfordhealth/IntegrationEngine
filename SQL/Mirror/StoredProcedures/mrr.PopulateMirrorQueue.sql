SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Clears the previous run of the Mirror Layer from the queue and adds the next.
The queue will be read by SSIS to load the Mirror tables.

Test:

EXECUTE [mrr].[PopulateMirrorQueue]

History:
28/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[PopulateMirrorQueue]
AS
SET NOCOUNT ON;

/*==========================================================================================================================================
Variables you can configure.
==========================================================================================================================================*/
DECLARE @SampleSize INT
    = 3,                                     -- Set this to the number of audit record that should be sampled to get the average duration of a particular Mirror table load.
        @QueueType NVARCHAR(128) = 'Mirror'; -- Name of queue that processes Mirror tables.

/*==========================================================================================================================================
Internal variables that you will not usually change.
==========================================================================================================================================*/
DECLARE @TableName NVARCHAR(MAX),
        @SQL NVARCHAR(MAX)
    =   N'INSERT INTO [mrr_config].[ProcessingQueue]
			(
			[QueueType],
			[Item]
		) SELECT ''Mirror'' QueueType, [AllAudit].[TableName] Item FROM (',
        @AuditSQL NVARCHAR(MAX),
        @AuditSQLTemplate NVARCHAR(MAX) = N'SELECT ''<TableName>'' [TableName], AVG([AuditSample].[Duration]) [AverageDuration] FROM 
			(SELECT TOP <SampleSize> [Duration] FROM  [mrr_aud].[<TableName>]
			ORDER BY [StartTime] DESC) AuditSample';

/*==========================================================================================================================================
A cursor to select a list of all current Mirror tables.
==========================================================================================================================================*/			
DECLARE [MirrorCursor] CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
SELECT [AuditTable].[TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES] [AuditTable]
    INNER JOIN [INFORMATION_SCHEMA].[TABLES] [MirrorTable]
        ON ([MirrorTable].[TABLE_NAME] = [AuditTable].[TABLE_NAME])
WHERE [AuditTable].[TABLE_SCHEMA] = 'mrr_aud'
      AND [AuditTable].[TABLE_TYPE] = 'BASE TABLE'
      AND [MirrorTable].[TABLE_SCHEMA] = 'mrr_tbl'
      AND [MirrorTable].[TABLE_TYPE] = 'BASE TABLE';

/*==========================================================================================================================================
Build the SQl to populate the queue table.
==========================================================================================================================================*/
OPEN [MirrorCursor];

FETCH NEXT FROM [MirrorCursor]
INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @AuditSQL = @AuditSQLTemplate;
    SET @AuditSQL = REPLACE(REPLACE(@AuditSQL, '<TableName>', @TableName), '<SampleSize>', @SampleSize);
    SET @SQL = @SQL + @AuditSQL + N' UNION ALL '; --+ N' UNION ALL '
    --EXECUTE [sp_executesql] @stmt = @AuditSQL;
    FETCH NEXT FROM [MirrorCursor]
    INTO @TableName;
END;

CLOSE [MirrorCursor];
DEALLOCATE [MirrorCursor];

SET @SQL = LEFT(@SQL, LEN(@SQL) - 10) + N') [AllAudit] ORDER BY AverageDuration DESC, TableName ASC'; -- + ') [AllAudit]'

--PRINT '';
--PRINT LEFT(@SQL, 500);
--PRINT '';
--PRINT RIGHT(@SQL, 500);

/*==========================================================================================================================================
Clear out the previous Mirror run from the queue.
==========================================================================================================================================*/
DELETE FROM [mrr_config].[ProcessingQueue]
WHERE [QueueType] = @QueueType;

/*==========================================================================================================================================
Insert the Mirror queue items for the next run.
==========================================================================================================================================*/
EXECUTE [sp_executesql] @stmt = @SQL;



GO
