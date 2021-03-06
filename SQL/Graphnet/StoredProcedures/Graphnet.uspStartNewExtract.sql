SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
/*==========================================================================================================================================
Start a new Graphnet extract. Note that this also initialises the list of in scope patients.

Test:

EXECUTE [Graphnet].[uspStartNewExtract]

History:
21/06/2018 OBMH\Steve.Nicoll  Initial version.

==========================================================================================================================================*/
CREATE PROCEDURE [Graphnet].[uspStartNewExtract]
AS
INSERT INTO [Graphnet_Config].[ExtractTracker]
(
    [LastExtracted],
    [RolledBackToOn]
)
VALUES
(   SYSDATETIME(), -- LastExtracted - datetime2(7)
    NULL           -- RolledBackToOn - datetime2(7)
    );

EXECUTE [Graphnet].[uspPopulateInscopePatient];



GO
