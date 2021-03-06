SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Intended to be run at end of Build process to log the mapping between Mirror source and target tables. We need this info 
because the user may have overriden the default mapping.

Test:

EXECUTE [mrr].[UpdateSourceTargetMap] N'[MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].[dbo].[tblAlert]', N'CNC_tblAlert'

History:
26/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[UpdateSourceTargetMap]
    @SourceTableFullName NVARCHAR(512),
    @TargetTable NVARCHAR(128)
AS
MERGE INTO [mrr_config].[SourceTargetMap] [tgt]
USING
(
    SELECT @SourceTableFullName [SourceTable],
           @TargetTable [TargetTable]
) AS [src]
ON [src].[SourceTable] = [tgt].[SourceTableFullName]
WHEN MATCHED THEN
    UPDATE SET [tgt].[TargetTable] = [src].[TargetTable],
               [tgt].[LastBuiltOn] = SYSDATETIME()
WHEN NOT MATCHED THEN
    INSERT
    (
        [SourceTableFullName],
        [TargetTable],
        [LastBuiltOn]
    )
    VALUES
    ([src].[SourceTable], [src].[TargetTable], SYSDATETIME());



GO
