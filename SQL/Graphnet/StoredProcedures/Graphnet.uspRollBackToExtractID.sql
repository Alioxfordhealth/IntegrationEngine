SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Rollback to Graphnet to a selected ExtractID (as held in Graphnet_Config.ExtractTracker) so that the next Graphnet run will gather updates
from after that extract.
FK constraint on Graphnet_Config.TableTracker will ensure that that table will also ohave related records removed via a ON DELETE CASCADE
clause.

Can also selectively just rollback one table but that will not log the event as a full rollback.

Test:

EXECUTE [Graphnet].[RollBackToExtractID] 2
EXECUTE [Graphnet].[RollBackToExtractID] 1, 'Alerts'

History:
21/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [Graphnet].[uspRollBackToExtractID]
    @RollBackToExtractID BIGINT,
    @TableName NVARCHAR(128) = NULL
AS
BEGIN

    IF @TableName IS NULL
    BEGIN
        DELETE FROM [Graphnet_Config].[ExtractTracker]
        WHERE [ExtractID] > @RollBackToExtractID;

        UPDATE [Graphnet_Config].[ExtractTracker]
        SET [RolledBackToOn] = SYSDATETIME()
        WHERE [ExtractID] = @RollBackToExtractID;
    END;
    ELSE
    BEGIN

        DELETE FROM [Graphnet_Config].[TableTracker]
        WHERE [TABLE_NAME] = @TableName
              AND [ExtractID] > @RollBackToExtractID;

    END;

END;

GO
