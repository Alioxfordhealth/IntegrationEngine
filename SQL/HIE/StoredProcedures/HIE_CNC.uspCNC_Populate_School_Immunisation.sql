SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [HIE_CNC].[uspCNC_Populate_School_Immunisation]
--(
--    @StaDate DATETIME,
--    @EndDate DATETIME
--)
AS

/*
test Script:

EXEC [dbo].[Populate_CHIS_School_Immunisations]


SELECT * FROM [chis].[tblCHIS_TableTracker] 

*/


DECLARE @Max_Date DATETIME
SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'School_Immunisation'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'School_Immunisation'),0)
SET @LoadId = @LoadId + 1



SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [HIE_CNC].[tblCNC_School_Immunisation]

		INSERT INTO [HIE_CNC].[tblCNC_School_Immunisation]
		SELECT [NHSNumber]
			  ,[Surname]
			  ,[Forename]
			  ,[DateOfBirth]
			  ,[Gender]
			  ,[DateAttended]
			  ,[Venue]
			  ,[VaccineName]
			  ,[Site]
			  ,[BatchNumber]
			  ,1--@LoadId
		  FROM [HIE_CNC].[vwCNC_School_Immunisation]

		-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNC].[tblCNC_School_Immunisation] WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [dbo].[TableTracker] values ('HIE_CNC', 'School_Immunisation', getdate() , (select max([DateAttended]) from [HIE_CNC].[tblCNC_School_Immunisation] WHERE ISNULL([DateAttended],'' ) != ''), @LoadId, @newRecords)
			END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH
GO
