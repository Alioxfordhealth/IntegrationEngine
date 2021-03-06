SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Populate each HIE table in turn. Runs sequencially so we should look to find
a parallel solution going forward.

Test: (best set this up as a SQL Agent job rather than run interactively.

EXECUTE dbo.uspPopulateAllTables

History:
24/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [dbo].[uspPopulateAllTables]
AS
DECLARE @TableName NVARCHAR(128);
DECLARE @Schema NVARCHAR(128);

DECLARE [HIETables] CURSOR LOCAL READ_ONLY STATIC FORWARD_ONLY FOR
SELECT TABLE_SCHEMA, [TABLE_NAME]
FROM [INFORMATION_SCHEMA].[TABLES]
WHERE [TABLE_SCHEMA] IN ('HIE_CNS','HIE_CNC') -- != 'HIE'
      AND [TABLE_TYPE] = 'BASE TABLE'
ORDER BY [TABLE_NAME];

OPEN [HIETables];

FETCH NEXT FROM [HIETables]
INTO @Schema, @TableName;


WHILE @@FETCH_STATUS = 0
BEGIN

    EXECUTE [dbo].[uspPopulateTable] @TableName = @TableName, 
									 @SourceViewSchema = @Schema,
									 @TargetTableSchema = @Schema,
									 @Verbose = 'Y';

    FETCH NEXT FROM [HIETables]
    INTO @Schema, @TableName;
END;


CLOSE [HIETables];
DEALLOCATE [HIETables];

GO
