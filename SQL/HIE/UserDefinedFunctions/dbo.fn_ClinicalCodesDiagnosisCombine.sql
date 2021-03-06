SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- Name:    fClinicalCodesDiagnosisCombine
--
-- Purpose: This function takes a consultation ref and looks at the 
-- consultationTemplateAnswer table, and returns the diagnosis codes for a given cons
--
-- Returns: a varchar(8000) containing all clinical codes for a consultation
--
-- 07/10/2005	mpt		Initial version
---------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fn_ClinicalCodesDiagnosisCombine] (@ConsultationRef AS UNIQUEIDENTIFIER)
RETURNS VARCHAR(8000)
AS
BEGIN
  DECLARE @Code AS VARCHAR(28)
  DECLARE @Description AS VARCHAR(150)
  DECLARE @FullList AS VARCHAR(8000)
  
  SET @FullList = ''
  
  -- use a cursor to step through the clinical codes for this consultation allowing us to 
  -- combine them into one string
  DECLARE CodesCursor CURSOR FAST_FORWARD
    FOR
     SELECT cta.Code, ISNULL(cch.description,'') 
      FROM mrr.ADA_consultationTemplateAnswer cta
      LEFT JOIN mrr.ADA_clinicalCodeHotlist cch ON cch.Code = cta.Code
      WHERE cta.Ref = @ConsultationRef AND QuestionRef IS NULL -- questionRef is null to ensure we only get clinical codes - not clinical templates
  OPEN CodesCursor
  FETCH NEXT FROM CodesCursor INTO @Code, @Description
  
  -- ensure we don't go over the varchar max length too
  WHILE @@fetch_status = 0 AND LEN(@FullList) < 7844
  BEGIN
    -- build up the list of allergies
    SET @FullList = @FullList + @Code + ' ' + @Description + CHAR(13) + CHAR(10)
    
    -- check for overflow of @FullList
    IF (LEN(@FullList) > 7844)
    BEGIN
      CLOSE CodesCursor
      DEALLOCATE CodesCursor
      RETURN @FullList
    END      
  
    FETCH NEXT FROM CodesCursor INTO @Code, @Description
  END
  
  CLOSE CodesCursor
  DEALLOCATE CodesCursor
  
  RETURN @FullList
END

GO
