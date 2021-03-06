SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Gets the next waiting item from the queue and marks it as 'Running'.

Test:
DECLARE @QueueID BIGINT,
        @Item NVARCHAR(128);
EXECUTE [mrr].[StartNextQueueItem] @QueueID = @QueueID OUTPUT, 
                                   @Item = @Item OUTPUT,   
								   @StreamName = 'MirrorStream_1'  

PRINT CAST(@QueueID AS NVARCHAR(100)) + ': ' + @Item

History:
29/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [mrr].[StartNextQueueItem]
    @QueueType NVARCHAR(128) = 'Mirror',
    @QueueID BIGINT OUTPUT,
    @Item NVARCHAR(128) OUTPUT,
	@StreamName NVARCHAR(128)
AS
BEGIN TRANSACTION;

SET NOCOUNT ON 

SELECT TOP 1
       @QueueID = [QueueID],
       @Item = [Item]
FROM [mrr_config].[ProcessingQueue] WITH
    (UPDLOCK, READPAST)
WHERE [QueueType] = @QueueType
      AND [ItemStatus] = 'Waiting'
ORDER BY [QueueID];

UPDATE [mrr_config].[ProcessingQueue]
SET [ItemStatus] = 'Running',
    [ItemStatusChangeDate] = SYSDATETIME(),
	[StreamName] = @StreamName
WHERE [QueueID] = @QueueID;

COMMIT TRANSACTION;

GO
