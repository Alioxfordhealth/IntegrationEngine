SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [mrr].[CopyMirrorSource]
    /*==========================================================================================================================================
Notes:
This procedure copies the structure of a named source table to the Mirror database, making sure that all the Mirror table requirements are met.
This procedure is designed to be run by the BuildMirror procedure but can be run standalone you will need to include all the required parameters.
More details at: http://ITKB/display/ITKB/Creating+a+new+Mirror+table

Parameters:
REQUIRED: 6 parameters (see below) 5 will normally come from mrr_config.SourceSystem or be manually overriden. The 6th parameter is the name of
the table to copy.
Names should NOT be quoted in []. We will do that in this procedure when required.

    @LinkedServer NVARCHAR(128): May be empty string and in that case the source database must reside on same instance as Mirror.
    @DatabaseName NVARCHAR(128): Required, not empty string.
    @SchemaName NVARCHAR(128): Required, not empty string.
    @TableName NVARCHAR(128): Required, not empty string.
    @TablePrefix NVARCHAR(10): Required, not empty string.
    @ChangeDetectionColumn NVARCHAR(128): Required, but may be empty string and in that case only a full loader can be built by generate proc.

OPTIONAL: Verbose = 'Y' will print out a running commentary that may be useful for troubleshooting.
Test:

EXECUTE mrr.CopyMirrorSource 'MHOXCARESQL01\MHOXCARESQL01', 'CareNotesOxfordLive', 'dbo', 'tblLocation', 'CNS_', 'Updated_Dttm'
EXECUTE mrr.CopyMirrorSource 'MHOXCARESQL01\MHOXCARESQL01', 'CareNotesOxfordLive', 'dbo', 'tblLocation', 'CNS_', 'Updated_Dttm', 'Y'
EXECUTE mrr.CopyMirrorSource 'MHOXCARESQL01\MHOXCARESQL01', 'CareNotesOxfordLive', 'dbo', 'testnopk', 'CNS_', '', 'Y'


History:
31/03/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/
    @LinkedServer NVARCHAR(128)
   ,@DatabaseName NVARCHAR(128)
   ,@SchemaName NVARCHAR(128)
   ,@TableName NVARCHAR(128)
   ,@TablePrefix NVARCHAR(10)
   ,@ChangeDetectionColumn NVARCHAR(128)
   ,@Verbose NVARCHAR(1) = N'N'
AS

-- We declare nvarchar(max) variables for the incoming parameters to avoid a bug with the EXEC @sql where concatenation with a nvarchar(n)
-- reduces the length to 8000 characters.
DECLARE @sql NVARCHAR(MAX) = ''
       ,@LinkedServerMax NVARCHAR(MAX) = @LinkedServer
       ,@DatabaseNameMax NVARCHAR(MAX) = @DatabaseName
       ,@SchemaNameMax NVARCHAR(MAX) = @SchemaName
       ,@TableNameMax NVARCHAR(MAX) = @TableName
       ,@TablePrefixMax NVARCHAR(MAX) = @TablePrefix
       ,@ChangeDetectionColumnMax NVARCHAR(MAX) = @ChangeDetectionColumn
       ,@ColumnList NVARCHAR(MAX)
       ,@PKList NVARCHAR(MAX)
       ,@MrrSchemaName NVARCHAR(MAX) = N'mrr_tbl'
       ,@Action NVARCHAR(20) = 'Created'
       ,@PkCount INT = 0;


BEGIN TRY

    -- create temporary working table for the column data.
    IF OBJECT_ID('tempdb..#TempColumnTable') IS NOT NULL
        DROP TABLE #TempColumnTable;

    CREATE TABLE #TempColumnTable
    (
        ColumnDef NVARCHAR(469) NULL
       ,COLUMN_NAME NVARCHAR(128) NULL
       ,TABLE_SCHEMA NVARCHAR(128) NULL
       ,TABLE_NAME NVARCHAR(128) NOT NULL
       ,DATA_TYPE NVARCHAR(128) NULL
       ,CHARACTER_MAXIMUM_LENGTH INT NULL
       ,NUMERIC_PRECISION TINYINT NULL
       ,NUMERIC_SCALE INT NULL
       ,COLLATION_NAME NVARCHAR(128) NULL
       ,ORDINAL_POSITION INT NULL
       ,pkCONSTRAINT_TYPE VARCHAR(11) NULL
       ,pkORDINAL_POSITION INT NULL
    );

    -- The following must not be empty strings...
    IF @DatabaseName = ''
        THROW 51020, 'Copy Table Error: A source database name is required but this procedure has been passed an empty string.', 1;
    IF @SchemaName = ''
        THROW 51030, 'Copy Table Error: A source table schema name is required but this procedure has been passed an empty string.', 1;
    IF @TableName = ''
        THROW 51040, 'Copy Table Error: A source table name is required but this procedure has been passed an empty string.', 1;
    IF @TablePrefix = ''
        THROW 51050, 'Copy Table Error: All Mirror tables should be assigned a prefix but this procedure has been passed an empty string.', 1;


    -- Gather the column information into the temporary table. TODO Consider moving to TVF for reuse in generate steps.
    SET @sql
        = 'WITH pkConstraint
    AS (SELECT keycol.COLUMN_NAME pkCOLUMN_NAME
              ,keycol.TABLE_SCHEMA pkTABLE_SCHEMA
              ,keycol.TABLE_NAME pkTABLE_NAME
              ,keycol.ORDINAL_POSITION pkORDINAL_POSITION
              ,cnstr.CONSTRAINT_TYPE pkCONSTRAINT_TYPE
        FROM ' + CASE
                     WHEN @LinkedServerMax = '' THEN
                         ''
                     ELSE
                         '[' + @LinkedServerMax + '].'
                 END + '[' + @DatabaseNameMax
          + '].INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS keycol
            INNER JOIN ' + CASE
                               WHEN '' IS NULL THEN
                                   ''
                               ELSE
                                   '[' + @LinkedServerMax + '].'
                           END + '[' + @DatabaseNameMax
          + '].INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS cnstr
                ON (
                       cnstr.CONSTRAINT_NAME = keycol.CONSTRAINT_NAME
                       AND cnstr.TABLE_SCHEMA = keycol.TABLE_SCHEMA
                       AND cnstr.TABLE_NAME = keycol.TABLE_NAME
                       AND cnstr.CONSTRAINT_TYPE = ''PRIMARY KEY''
                   ))
	INSERT INTO #TempColumnTable
    SELECT ''['' + cols.COLUMN_NAME + ''] '' + cols.DATA_TYPE
           + CASE
                 WHEN cols.DATA_TYPE LIKE ''%CHAR%'' OR cols.DATA_TYPE LIKE ''%BINARY%'' THEN
                     ''('' + CAST(CASE
                                    WHEN cols.CHARACTER_MAXIMUM_LENGTH = -1 THEN
                                        ''max''
                                    ELSE
                                        CAST(cols.CHARACTER_MAXIMUM_LENGTH AS NVARCHAR(30))
                                END AS NVARCHAR(30)) + '')''
                 WHEN cols.DATA_TYPE IN ( ''numeric'', ''decimal'' ) THEN
                     ''('' + CAST(cols.NUMERIC_PRECISION AS NVARCHAR(30)) + '', ''
                     + CAST(cols.NUMERIC_SCALE AS NVARCHAR(30)) + '')''
                 ELSE
                     ''''
             END
           + CASE --TODO Need to use source database collation in this logic - not the Mirror databse collation.
                 WHEN ISNULL(cols.COLLATION_NAME, CONVERT(VARCHAR, SERVERPROPERTY(''collation''))) <> CONVERT(
                                                                                                               VARCHAR
                                                                                                              ,SERVERPROPERTY(''collation'')
                                                                                                           ) THEN
                     '' COLLATE '' + cols.COLLATION_NAME
                 ELSE
                     ''''
             END + CASE
                       WHEN cols.COLUMN_NAME = ''' + @ChangeDetectionColumnMax
          + '''
                            OR pkConstraint.pkCONSTRAINT_TYPE = ''PRIMARY KEY'' THEN
                           '' NOT NULL''
                       ELSE
                           '' NULL''
                   END AS ColumnDef
              ,''['' + cols.COLUMN_NAME + '']''
			  ,cols.TABLE_SCHEMA
			  ,cols.TABLE_NAME
			  ,cols.DATA_TYPE
			  ,cols.CHARACTER_MAXIMUM_LENGTH
			  ,cols.NUMERIC_PRECISION
			  ,cols.NUMERIC_SCALE
			  ,cols.COLLATION_NAME
			  ,cols.ORDINAL_POSITION 
			  ,pkConstraint.pkCONSTRAINT_TYPE
			  ,pkConstraint.pkORDINAL_POSITION 
    FROM ' + CASE
                 WHEN @LinkedServerMax IS NULL THEN
                     ''
                 ELSE
                     '[' + @LinkedServerMax + '].'
             END + '[' + @DatabaseNameMax
          + '].INFORMATION_SCHEMA.COLUMNS AS cols
        LEFT OUTER JOIN pkConstraint
            ON (
                   pkConstraint.pkCOLUMN_NAME = cols.COLUMN_NAME
                   AND pkConstraint.pkTABLE_SCHEMA = cols.TABLE_SCHEMA
                   AND pkConstraint.pkTABLE_NAME = cols.TABLE_NAME
               )
    WHERE cols.TABLE_SCHEMA = ''' + @SchemaNameMax + '''
          AND cols.TABLE_NAME = ''' + @TableNameMax + '''
    ORDER BY cols.ORDINAL_POSITION ASC;';

    IF @Verbose = N'Y'
        PRINT @sql;

    EXECUTE (@sql);

    -- Get the column definitions.
    SET @ColumnList = STUFF((
                                SELECT ', ' + ColumnDef
                                FROM #TempColumnTable
                                ORDER BY ORDINAL_POSITION ASC
                                FOR XML PATH('')
                            )
                           ,1
                           ,2
                           ,''
                           );

    -- This is the template for the CREATE TABLE statement.
    SET @sql = 'CREATE TABLE <Mirror_Table>
		(
		<column_list>
		);';

    -- Substitute in the specific table name, column list etc for this mirror table.
    SET @sql
        = REPLACE(
                     REPLACE(
                                @sql
                               ,'<Mirror_Table>'
                               ,'[' + @MrrSchemaName + '].[' + @TablePrefixMax + @TableNameMax + ']'
                            )
                    ,'<column_list>'
                    ,@ColumnList
                 );
    IF @Verbose = N'Y'
        PRINT @sql;

    -- Before we create the mirror table we will get rid off any existing version of the mirror table.
    IF OBJECT_ID(@MrrSchemaName + '.' + @TablePrefixMax + @TableNameMax, 'U') IS NOT NULL
    BEGIN
        EXECUTE ('DROP TABLE [' + @MrrSchemaName + '].[' + @TablePrefixMax + @TableNameMax + ']');
        SET @Action = 'Recreated';
    END;

    -- Now create the mirror table.
    EXECUTE (@sql);

    -- Create a primary key - but only if there is one on the source table.
    IF EXISTS
    (
        SELECT NULL
        FROM #TempColumnTable
        WHERE pkCONSTRAINT_TYPE = 'PRIMARY KEY'
    )
    BEGIN
        -- Get the PK definition.
        SET @PKList = STUFF((
                                SELECT ', ' + COLUMN_NAME + ' ASC'
                                FROM #TempColumnTable
                                WHERE pkCONSTRAINT_TYPE = 'PRIMARY KEY'
                                ORDER BY ORDINAL_POSITION ASC
                                FOR XML PATH('')
                            )
                           ,1
                           ,2
                           ,''
                           );


        -- This is the template for the primary key.
        SET @sql
            = 'ALTER TABLE <Mirror_Table>
			ADD CONSTRAINT <pk_name>
				PRIMARY KEY CLUSTERED (<primary_key>);';

        SET @sql
            = REPLACE(
                         REPLACE(
                                    REPLACE(
                                               @sql
                                              ,'<Mirror_Table>'
                                              ,'[' + @MrrSchemaName + '].[' + @TablePrefixMax + @TableNameMax + ']'
                                           )
                                   ,'<pk_name>'
                                   ,'[pk' + @TablePrefixMax + @TableNameMax + ']'
                                )
                        ,'<primary_key>'
                        ,@PKList
                     );
        -- Now create the primary key.
        EXECUTE (@sql);
        IF @Verbose = N'Y'
            PRINT @sql;

    END;

    PRINT @Action + ' table [' + @MrrSchemaName + '].[' + @TablePrefixMax + @TableNameMax + ']';

    -- Tidy up.
    IF OBJECT_ID('tempdb..#TempColumnTable') IS NOT NULL
        EXECUTE ('DROP TABLE #TempColumnTable');

END TRY
BEGIN CATCH
    THROW;
END CATCH;

GO
