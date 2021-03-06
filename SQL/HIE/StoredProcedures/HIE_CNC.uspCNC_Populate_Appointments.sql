SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [HIE_CNC].[uspCNC_Populate_Appointments]
AS

/*
test Script:

EXEC HIE_CNC.uspCNC_Populate_Appointments

select * from  [HIE_CNC].[tblCNC_Appointments]

select * from [dbo].[TableTracker]

*/


DECLARE @ExtractDate DATETIME = GETDATE();

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_Appointments'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[TableTracker] WHERE TABLE_NAME = 'tblCNC_Appointments'),0)
SET @LoadId = @LoadId + 1

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

	TRUNCATE TABLE [HIE_CNC].[tblCNC_Appointments]

	INSERT INTO [HIE_CNC].[tblCNC_Appointments]
	SELECT [Appointment_ID]
		  ,[Patient_ID]
		  ,[Appointment_DateTime]
		  ,[UpdatedDate]
		  ,[Clinic_Community_Indicator]
		  ,[Appointment_Type]
		  ,[Location]
		  ,[HCPName]
		  ,[Face_to_Face_Indicator]
		  ,[Deleted]
		  , 0 AS [ContainsInvalidChar]
		  , @LoadId
	FROM [HIE_CNC].[vwCNC_Appointments]
	WHERE [UpdatedDate] > @Max_Date

	
	-- delete from Tracker table 
	DECLARE @newRecords INT

	SET @newRecords = (SELECT COUNT(*) FROM [HIE_CNC].[tblCNC_Appointments] WHERE LoadID = @LoadId)

	IF @newRecords > 0
	BEGIN 
		INSERT INTO [dbo].[TableTracker] VALUES ('HIE_CNC', 'tblCNC_Appointments',@ExtractDate, (SELECT ISNULL(MAX([UpdatedDate]),GETDATE()) FROM [HIE_CNC].[tblCNC_Appointments]), @LoadId, @newRecords)
	END

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

 
GO
