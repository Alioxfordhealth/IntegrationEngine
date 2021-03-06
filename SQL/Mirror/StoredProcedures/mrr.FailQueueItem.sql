SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

/*==========================================================================================================================================
Mark a queue item as failed.

Test:

EXECUTE [mrr].[FailQueueItem] 9515

History:
29/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[FailQueueItem] @QueueID BIGINT
AS
BEGIN TRANSACTION;

UPDATE [mrr_config].[ProcessingQueue]
SET [ItemStatus] = 'Failed',
    [ItemStatusChangeDate] = SYSDATETIME()
WHERE [QueueID] = @QueueID
      AND [ItemStatus] <> 'Completed'; -- Do not attempt to fail an item if it has already completed.

COMMIT TRANSACTION;

GO
