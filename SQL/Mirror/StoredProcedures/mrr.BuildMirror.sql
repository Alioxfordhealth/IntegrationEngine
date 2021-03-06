SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON




CREATE PROCEDURE [mrr].[BuildMirror]
    /*==========================================================================================================================================
Notes:
This procedure creates the associated database objects required to load a Mirror table using our standard load mechanism. You tell it the
full path to the source table and it will try to take it from there and build everything needed - but to do this, the source system must be one 
that is declared in mrr_config.SourceSystem.
For special cases, and more refined control over what is built, you can individually call the procedures that are called by this procedure but
that is not the recommended approach as it will hinder future maintainability.

Once these objects are built, the related view can be copied to the database that needs to access the Mirror table. The view will refer back to the
Mirror database. Currently, we only support moving the Mirror view to a different database on the same instance as the Mirror database.

More details at: http://ITKB/display/ITKB/Creating+a+new+Mirror+table

Paremeters:

REQUIRED: TargetTableName (The 4-part name for the source table, a 3-part name will mean that the source is expected to be found on the same instance as the Mirror database.)
OPTIONAL: Prefix override (A string that will prefix the table name in the Mirror database. If not set, we will attempt to derive the prefix from the source table name - this is the normal usage.)
OPTIONAL: ChangeDetectionColumn (The name of the source column whose value always changes when the record changes. For CareNotes this is the Updated_Dtm column. If not set, we will attempt to derive this from the source table name - this is the normal usage.)

Test example:

EXECUTE mrr.BuildMirror 'MHOXCARESQL01\MHOXCARESQL01.CareNotesOxfordLive.dbo.tblLocation';
EXECUTE mrr.BuildMirror '[MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordLive].[dbo].[tblLocation]';
EXECUTE mrr.BuildMirror 'MHOXCARESQL01\MHOXCARESQL01.CareNotesOxfordLive.dbo.tblPatient', '', '', 'Y';
EXECUTE mrr.BuildMirror 'MHOXCARESQL01\MHOXCARESQL01.CareNotesOxfordLive.dbo.testnopk', '', '', 'Y';

History:
26/03/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/
    @SourceTableFullName NVARCHAR(512),
    @Prefix NVARCHAR(10) = N'',                 -- If set, this overrides the default Mirror table prefix that is derived from the source system config.
    @ChangeDetectionColumn NVARCHAR(128) = N'', -- If set, this overrides the default from the source system config.
    @Verbose NVARCHAR(1) = N'N'
AS
SET NOCOUNT ON;

DECLARE @ParsingName NVARCHAR(512) = @SourceTableFullName,
        @DefaultPrefix NVARCHAR(10),
        @DefaultChangeDetectionColumn NVARCHAR(128),
        @LinkedServer NVARCHAR(128),
        @SourceDB NVARCHAR(128),
        @SourceSchema NVARCHAR(128),
        @SourceTable NVARCHAR(128),
        @NumberOfNameParts INT,
        @MirrorTable NVARCHAR(128);

BEGIN TRY

    -------------------------------------------------------------------------------------------------------------
    -- Work out the target table name (the name of the table in the Mirror database) and the change detection column.
    -------------------------------------------------------------------------------------------------------------

    -- Strip out [] quotes. TODO This does not allow for '.' character within quoted parts - unlikely but potential bug.
    SET @ParsingName = REPLACE(REPLACE(@ParsingName, '[', ''), ']', '');

    -- Work out if we have a 3 or 4-part named table (anything else will be an error).
    SET @NumberOfNameParts = LEN(@ParsingName) - LEN(REPLACE(@ParsingName, '.', '')) + 1;

    -- There must be 3 or 4 parts to the name.
    IF @NumberOfNameParts NOT IN ( 3, 4 )
        THROW 51000, 'The source table must either be specified in 3 or 4 part naming. e.g <LinkedServer>.<Database>.<Schema>.<TableName>.', 1;

    -- If 4-part naming get the linked server name.
    IF @NumberOfNameParts = 4
    BEGIN
        SET @LinkedServer = SUBSTRING(@ParsingName, 1, CHARINDEX('.', @ParsingName) - 1);
        SET @ParsingName = SUBSTRING(@ParsingName, CHARINDEX('.', @ParsingName) + 1, LEN(@ParsingName));
    END;

    -- Parse the remaining parts of the name.
    SET @SourceDB = SUBSTRING(@ParsingName, 1, CHARINDEX('.', @ParsingName) - 1);
    SET @ParsingName = SUBSTRING(@ParsingName, CHARINDEX('.', @ParsingName) + 1, LEN(@ParsingName));

    SET @SourceSchema = SUBSTRING(@ParsingName, 1, CHARINDEX('.', @ParsingName) - 1);
    SET @SourceTable = SUBSTRING(@ParsingName, CHARINDEX('.', @ParsingName) + 1, LEN(@ParsingName));

    IF @Verbose = 'Y'
        PRINT 'Linked Server = ' + @LinkedServer;

    IF @Verbose = 'Y'
        PRINT 'Source DB = ' + @SourceDB;

    IF @Verbose = 'Y'
        PRINT 'Source Schema = ' + @SourceSchema;

    IF @Verbose = 'Y'
        PRINT 'Source Table = ' + @SourceTable;

    -- Unless both the prefix and Change Control Column have been overridden in the procedure call we must have a
    -- Source System configuration.
    IF (
           @Prefix = N''
           OR @ChangeDetectionColumn = N''
       )
       AND NOT EXISTS
    (
        SELECT NULL
        FROM [mrr_config].[SourceSystem]
        WHERE [LinkedServer] = @LinkedServer
              AND [DatabaseName] = @SourceDB
              AND [SchemaName] = @SourceSchema
    )
        THROW 51010, 'The source system has not been defined in mrr_config.SourceSystem and the prefix/change control column has not been overridden in the call to BuildMirror.', 1;

    SELECT @DefaultPrefix = [TablePrefix],
           @DefaultChangeDetectionColumn = [ChangeDetectionColumn]
    FROM [mrr_config].[SourceSystem]
    WHERE [LinkedServer] = @LinkedServer
          AND [DatabaseName] = @SourceDB
          AND [SchemaName] = @SourceSchema;

    -- Work out what the Mirror table prefix should be. If it was passed as a parameter, we will just take that.
    IF @Prefix = ''
        SET @Prefix = @DefaultPrefix;

    IF @Verbose = 'Y'
        PRINT 'Prefix = ' + @Prefix;

    -- Work out what the Mirror table change detection column should be. If it was passed as a parameter, we will just take that.
    IF @ChangeDetectionColumn = ''
        SET @ChangeDetectionColumn = @DefaultChangeDetectionColumn;

    IF @Verbose = 'Y'
        PRINT 'Change Detection Column = ' + @ChangeDetectionColumn;

    SET @MirrorTable = @Prefix + @SourceTable;

    -------------------------------------------------------------------------------------------------------------
    -- Create the Mirror table in the Mirror database using the original source table as a template.
    -------------------------------------------------------------------------------------------------------------
    -- Copy the table structure from the source system
    EXECUTE [mrr].[CopyMirrorSource] @LinkedServer = @LinkedServer,
                                     @DatabaseName = @SourceDB,
                                     @SchemaName = @SourceSchema,
                                     @TableName = @SourceTable,
                                     @TablePrefix = @Prefix,
                                     @ChangeDetectionColumn = @ChangeDetectionColumn,
                                     @Verbose = @Verbose;


    -------------------------------------------------------------------------------------------------------------
    -- Create the Mirror table using the original source table as a template.
    -------------------------------------------------------------------------------------------------------------
    EXECUTE [mrr].[GenerateMirrorObjects] @MirrorTable = @MirrorTable,                     -- nvarchar(255)
                                          @ChangeDetectionColumn = @ChangeDetectionColumn, -- nvarchar(255)
                                          @Verbose = @Verbose;


    -------------------------------------------------------------------------------------------------------------
    -- Create the loader for theMirror table. This will be an incremental loader unless there is no PK or
    -- change detection column on the source - in which case a simple TRUNCATE/INSERT loader will  be built.
    -------------------------------------------------------------------------------------------------------------
    EXECUTE [mrr].[GenerateLoadProcedure] @MirrorTableName = @MirrorTable;


    -------------------------------------------------------------------------------------------------------------
    -- Create the reconciliation procedure for theMirror table.
    -------------------------------------------------------------------------------------------------------------
    EXECUTE [mrr].[GenerateReconcileProcedure] @MirrorTableName = @MirrorTable;


    -------------------------------------------------------------------------------------------------------------
    -- If we got this far, log the mapping between the source table and target.
    -------------------------------------------------------------------------------------------------------------
    EXECUTE [mrr].[UpdateSourceTargetMap] @SourceTableFullName = @SourceTableFullName,
                                          @TargetTable = @MirrorTable;

END TRY
BEGIN CATCH
    THROW;
END CATCH;

-------------------------------------------------------------------------------------------------------------
-- The End.
-------------------------------------------------------------------------------------------------------------



GO
