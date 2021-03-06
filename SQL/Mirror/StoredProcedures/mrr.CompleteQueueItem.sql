SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Mark a queue item as complete.

Test:

EXECUTE [mrr].[CompleteQueueItem] 2

History:
29/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[CompleteQueueItem] @QueueID BIGINT
AS
BEGIN TRANSACTION;

UPDATE [mrr_config].[ProcessingQueue]
SET [ItemStatus] = 'Completed',
    [ItemStatusChangeDate] = SYSDATETIME()
WHERE [QueueID] = @QueueID;

COMMIT TRANSACTION;

GO
