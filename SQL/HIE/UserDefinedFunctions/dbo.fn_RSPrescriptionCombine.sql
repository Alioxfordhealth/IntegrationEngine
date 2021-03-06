SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

 
-- prescription details
-- Name:    fPrescriptionsCombine
--
-- Purpose: This function takes a ConsultationRef and looks at the ConsultationPrescriptionItem
-- table and returns the concatenated text for all the item prescribed for this case
--
-- Returns: a varchar(8000) containing all Prescribed Drugs
--
-- 18/11/2005	mpt		Initial version
---------------------------------------------------------------------------------
CREATE FUNCTION [dbo].[fn_RSPrescriptionCombine] (@ConsultationRef AS UNIQUEIDENTIFIER)
RETURNS VARCHAR(8000)
AS
BEGIN
  declare @DrugName as varchar(256)
--  declare @Prep as varchar(256)
  declare @Dosage as varchar(256)
  declare @Qty as decimal(9,2)
  DECLARE @Issue AS VARCHAR(256)
--  declare @Strength as varchar(256)

  DECLARE @FullList AS VARCHAR(8000)
  SET @FullList = ''
  
  -- use a cursor to step through the prescriptions and combine them into one string
  DECLARE PrescriptionCursor CURSOR FAST_FORWARD
    FOR
		SELECT 
		drugName, 
		dosage, 
		qty, 
		CASE 
		WHEN ItemType = 'S' AND esi.EventStockIssuedRef IS NOT NULL AND esii.IssueType = 'I' THEN ' - prescribed and issued from stock, BatchNo :' + esii.batchNo 
		WHEN ItemType = 'S' AND esi.EventStockIssuedRef IS NOT NULL AND esii.IssueType = 'R' THEN ' - prescribed from stock and marked as no longer required'
		WHEN itemType = 'S' THEN ' - prescribed from stock ' 
		ELSE '' END AS 'Issue'
		FROM mrr.ADA_ConsultationPrescriptionItem cpi 
		JOIN mrr.ADA_consultation con ON con.consultationRef = cpi.consultationRef 
		LEFT JOIN mrr.ADA_CaseEvents ceCon ON ceCon.CaseRef = con.CaseRef AND ceCon.EventType = 'OLC' AND ceCon.Ref = @ConsultationRef 
		LEFT JOIN mrr.ADA_CaseEvents ceS ON ceS.CaseRef = con.CaseRef AND ceS.MasterEventRef = ceCon.eventRef AND ceS.EventType = 'STOCKISSUE' 
		LEFT JOIN mrr.ADA_EventStockIssued esi ON esi.CaseRef = con.CaseRef AND esi.EventStockIssuedRef = ceS.Ref 
		LEFT JOIN mrr.ADA_EventStockIssuedItem esii ON esii.EventStockIssuedRef = esi.EventStockIssuedRef AND esii.StockItemRef = cpi.StockItemRef 
		WHERE cpi.consultationRef = @ConsultationRef
  
  OPEN PrescriptionCursor
  FETCH NEXT FROM PrescriptionCursor INTO @DrugName, @Dosage, @Qty, @Issue
  
  DECLARE @QtyStr AS VARCHAR(20)

  -- ensure we don't go over the varchar max length too
  WHILE @@fetch_status = 0 AND LEN(@FullList) < 7000
  BEGIN
    
    SET @QtyStr = @Qty
    SET @FullList = @FullList + @DrugName + ' ' + @Dosage + ' ' + @QtyStr + ' ' + @Issue + ' '
    + CHAR(13) + CHAR(10)
    
    FETCH NEXT FROM PrescriptionCursor INTO @DrugName, @Dosage, @Qty, @Issue
  END
  
  CLOSE PrescriptionCursor
  DEALLOCATE PrescriptionCursor
  
  RETURN @FullList
END

 

GO
