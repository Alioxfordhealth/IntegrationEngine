SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Run the check metadata procedures for all current Mirror tables.

Test:
EXECUTE [mrr].[CheckAll]

History:
03/07/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[CheckAll]
AS
DECLARE @MirrorTableName NVARCHAR(128),
        @SQL NVARCHAR(MAX);

DECLARE [MirrorCursor] CURSOR FORWARD_ONLY LOCAL READ_ONLY FOR
SELECT [ChkTable].[TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES] [ChkTable]
WHERE [ChkTable].[TABLE_SCHEMA] = 'mrr_tbl'
      AND [ChkTable].[TABLE_TYPE] = 'BASE TABLE'
ORDER BY [ChkTable].[TABLE_NAME];

OPEN [MirrorCursor];

FETCH NEXT FROM [MirrorCursor]
INTO @MirrorTableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @MirrorTableName;
    EXECUTE [mrr].[CheckMirrorTable] @MirrorTableName;
    FETCH NEXT FROM [MirrorCursor]
    INTO @MirrorTableName;
END;

CLOSE [MirrorCursor];

DEALLOCATE [MirrorCursor];



GO
