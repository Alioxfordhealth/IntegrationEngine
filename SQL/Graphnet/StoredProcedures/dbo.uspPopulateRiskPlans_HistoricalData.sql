SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE dbo.uspPopulateRiskPlans_HistoricalData
AS 


TRUNCATE TABLE [dbo].[RiskPlans_HistoricalData]

INSERT INTO [dbo].[RiskPlans_HistoricalData]
SELECT * FROM [Graphnet].[vwRiskPlans_HistoricalData]
GO
