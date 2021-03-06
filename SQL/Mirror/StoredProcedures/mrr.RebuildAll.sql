SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Use this procedure to rebuild all current mirror tables.

Test:

EXECUTE [mrr].[RebuildAll]

History:
26/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[RebuildAll]
AS
DECLARE @SourceTableFullName NVARCHAR(512);

DECLARE [SourceTables] CURSOR LOCAL READ_ONLY STATIC FORWARD_ONLY FOR
SELECT [SourceTableFullName]
FROM [mrr_config].[SourceTargetMap]
    INNER JOIN [INFORMATION_SCHEMA].[TABLES]
        ON ([TABLE_NAME] = [TargetTable])
WHERE [TABLE_SCHEMA] = 'mrr_tbl'
      AND [TABLE_TYPE] = 'BASE TABLE';

OPEN [SourceTables];

FETCH NEXT FROM [SourceTables]
INTO @SourceTableFullName;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        EXECUTE [mrr].[BuildMirror] @SourceTableFullName = @SourceTableFullName;
    END TRY
    BEGIN CATCH
        PRINT 'Rebuild of ' + @SourceTableFullName + ' failed.';
    END CATCH;

    FETCH NEXT FROM [SourceTables]
    INTO @SourceTableFullName;

END;

CLOSE [SourceTables];

DEALLOCATE [SourceTables];

GO
