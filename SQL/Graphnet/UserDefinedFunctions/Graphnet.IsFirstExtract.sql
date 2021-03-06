SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Returns 'Y' if this is the first extract for the chosen table.

Test:

DECLARE @FirstExtract NCHAR(1);

SET @FirstExtract = [Graphnet].[IsFirstExtract]('Alerts');

SELECT @FirstExtract;


History:
22/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE FUNCTION [Graphnet].[IsFirstExtract]
(
    @TableName NVARCHAR(128)
)
RETURNS NCHAR(1)
AS
BEGIN

    DECLARE @FirstExtract NCHAR(1);

    IF EXISTS
    (
        SELECT NULL
        FROM [Graphnet_Config].[TableTracker]
        WHERE [TABLE_NAME] = @TableName
    )
        SET @FirstExtract = N'N';
    ELSE
        SET @FirstExtract = N'Y';

    RETURN @FirstExtract;
END;

GO
