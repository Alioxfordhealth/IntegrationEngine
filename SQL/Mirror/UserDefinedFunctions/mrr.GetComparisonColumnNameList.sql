SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


/*==========================================================================================================================================
Notes:


Test:

DECLARE @ColumnNameList NVARCHAR(MAX)

SET @ColumnNameList =  mrr.GetComparisonColumnNameList('CNC_tblTeamMember');

SELECT @ColumnNameList

History:
11/04/2018 OBMH\Steve.Nicoll Initial version.

==========================================================================================================================================*/

CREATE FUNCTION [mrr].[GetComparisonColumnNameList]
(
    @MirrorTableName NVARCHAR(128)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

    SET @MirrorTableName = REPLACE(REPLACE(@MirrorTableName, '[', ''), ']', '');

    RETURN STUFF(
           (
               SELECT ', [' + COLUMN_NAME + ']'
               FROM INFORMATION_SCHEMA.COLUMNS ColumnList
               WHERE ColumnList.TABLE_SCHEMA = 'mrr_tbl'
                     AND ColumnList.TABLE_NAME = @MirrorTableName
                     AND ColumnList.DATA_TYPE NOT IN ( 'text', 'ntext', 'xml', 'image' )
               ORDER BY ORDINAL_POSITION ASC
               FOR XML PATH('')
           ),
           1,
           2,
           ''
                );

END;


GO
