SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE  FUNCTION [dbo].[fn_RSCaseEventBeforeCaseTypeName]
	(
		@CaseRef uniqueidentifier,
		@Ref uniqueIdentifier, 
		@Type varChar(120)
	)
RETURNS varChar(240)
AS
	BEGIN
	Return(Select ct.Name 
	from mrr.ADA_CaseEvents ce 
	join mrr.ADA_CaseAudit ca on ca.CaseRef = @CaseRef and ca.CaseAuditRef = ce.BeforeCaseAuditRef 
	join mrr.ADA_Casetype ct on ct.CaseTypeRef = ca.CaseTypeRef 
	where ce.CaseRef = @CaseRef and ce.Ref = @Ref and ce.EventType = @Type)
		
	END




GO
