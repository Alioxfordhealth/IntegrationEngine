SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
 
/*==========================================================================================================================================
Populate the materialized list of patients that are in scope for Graphnet. This should be executed at the start
of SSIS package.

Test:

EXECUTE [HIE_CNC].[uspCNC_PopulateInscopePatient]

History:
 

==========================================================================================================================================*/
CREATE PROCEDURE [HIE_CNC].[zzzuspCNC_PopulateInscopePatient]
AS
TRUNCATE TABLE [HIE_CNC].[CNC_InscopePatient];

INSERT INTO [HIE_CNC].[CNC_InscopePatient]
(
    [PatientNo]
)
SELECT [PatientNo]
FROM [HIE_CNC].[vwCNC_InscopePatient];

GO
