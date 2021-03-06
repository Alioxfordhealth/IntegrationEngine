SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- Name:    fInformationalOutcomesCommentsCombine
--
-- Purpose: This function takes a caseRef and looks at the EventInformationalOutcome table
-- and returns the concatenated text for all the comments
--
-- Returns: a varchar(8000) containing all the Allergies for a patient
--
-- 13/06/2006	mpt		Initial version
-- 13/08/2015   ke      Exclude obsolete informational outcomes
---------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fn_InformationalOutcomesCommentsCombine] (@caseRef AS UNIQUEIDENTIFIER)
RETURNS VARCHAR(8000)
AS
BEGIN

  DECLARE @FollowUp AS VARCHAR(75)
  DECLARE @Comments AS VARCHAR(500)
  DECLARE @FullList AS VARCHAR(8000)
  
  SET @FullList = ''
  
  -- use a cursor to step through the allergies for this patient allowing us to 
  -- combine them into one string
  DECLARE FollowUpCursor CURSOR FAST_FORWARD
    FOR
      SELECT inf.name, eo.summary 
	  FROM mrr.ADA_EventInformationalOutcome eo 
      JOIN mrr.ADA_case c ON c.caseRef = eo.caseRef
      JOIN mrr.ADA_informationalOutcomes inf ON inf.InformationalOutcomeRef = eo.InformationalOutcomeRef
      WHERE 
		c.caseRef = @caseRef AND c.cancelled = 0 AND eo.Obsolete = 0
  
  OPEN FollowUpCursor
  FETCH NEXT FROM FollowUpCursor INTO @FollowUp, @Comments
  
  -- ensure we don't go over the varchar max length too
  WHILE @@fetch_status = 0 AND LEN(@FullList) < 7224
  BEGIN
    -- build up the list of Informational Outcomes
    IF (@FollowUp IS NOT NULL)
      SET @FullList = @FullList + @FollowUp + ' - ' + @Comments + CHAR(13) + CHAR(10)
    
    FETCH NEXT FROM FollowUpCursor INTO @FollowUp, @Comments
  END
  
  CLOSE FollowUpCursor
  DEALLOCATE FollowUpCursor
  
  RETURN @FullList
END

GO
