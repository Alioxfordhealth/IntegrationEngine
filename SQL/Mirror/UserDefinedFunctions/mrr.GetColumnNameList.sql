SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes: Crate a list of the column names in a Mirror table, each column optionally prefixed by an alias of your choice.


Test:

DECLARE @SourceTableFullName NVARCHAR(MAX)

SET @SourceTableFullName =  mrr.GetColumnNameList('CNC_tblTeamMember', 'src'); -- Or use, mrr.GetColumnNameList('CNC_tblTeamMember', DEFAULT); for no alias

SELECT @SourceTableFullName

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.
18/01/2019 OBMH\Steve.Nicoll Added optional alias name.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetColumnNameList]
(
    @MirrorTableName NVARCHAR(128),
    @AliasName NVARCHAR(128) = N''
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    IF ISNULL(@AliasName, '') <> ''
        SET @AliasName = @AliasName + '.';

    SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName, '[', ''), ']', '');

    RETURN STUFF(
           (
               SELECT ', ' + @AliasName + '[' + COLUMN_NAME + ']'
               FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_SCHEMA = 'mrr_tbl'
                     AND TABLE_NAME = @MirrorTableName
               ORDER BY ORDINAL_POSITION ASC
               FOR XML PATH('')
           ),
           1,
           2,
           ''
                );

END;


GO
