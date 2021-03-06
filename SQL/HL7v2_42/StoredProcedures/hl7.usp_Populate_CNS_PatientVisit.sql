SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 9-12 Month Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 9-12 Month Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted


CREATE PROCEDURE  [hl7].[usp_Populate_CNS_PatientVisit]
AS

/*
test Script:

EXEC [hl7].[usp_Populate_CNS_PatientVisit]


SELECT * FROM [dbo].[tblHL7_TableTracker]

*/

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNS_PatientVisit' AND SourceSystem = 'CNS'),0)
SET @LoadId = @LoadId + 1

DECLARE @MaxDate DATETIME =   ISNULL((SELECT MAX(MaxUpdateTime) FROM [dbo].[tblHL7_TableTracker] WHERE TABLE_NAME = 'CNS_PatientVisit' AND SourceSystem = 'CNS'),'1 Jan 1900')
--PRINT @MaxDate

BEGIN TRY

	BEGIN TRANSACTION;

		DELETE FROM [hl7].[tblPatientVisit]
		WHERE LEFT(PV_ID,2) = 'MH' 

		INSERT INTO [hl7].[tblPatientVisit] (
			   [PV_ID]
			  ,[SourceSystem]
			  ,[MPI_ID]
			  ,[Ward_Stay_ID]
			  ,[Patient_ID]
			  ,[Patient_Class]
			  ,[Ward_LocationID]
			  ,[Admission_Type]
			  ,[Consulting_GMC_Code]
			  ,[Consulting_Surname]
			  ,[Consulting_Forename]
			  ,[Admit_Source]
			  ,[Episode_ID]
			  ,[Discharge_Method]
			  ,[Discharge_Destination_ID]
			  ,[PV_Start]
			  ,[PV_End]
			  ,[Event_Type]
			  ,[WardStay_Updated_Dttm]
		)
		SELECT [PV_ID]
			,'MH' AS SourceSystem
			,[MPI_ID]
			,[Ward_Stay_ID]
			,[Patient_ID]
			,[Patient_Class]
			,[Ward_LocationID]
			,[Admission_Type]
			,[Consulting_GMC_Code]
			,[Consulting_Surname]
			,[Consulting_Forename]
			,[Admit_Source]
			,[Episode_ID]
			,[Discharge_Method]
			,[Discharge_Destination_ID]
			,[PV_Start]
			,[PV_End]
			,[Event_Type]
			,[WardStay_Updated_Dttm]
		FROM [hl7].[vw_CNS_PatientVisit] pv
		WHERE( CAST(pv.WardStay_Updated_Dttm AS DATETIME) > @MaxDate
		AND ( CAST(pv.[Ward_Start_Dttm] AS DATETIME) > @MaxDate 
			OR 
			CAST(pv.[Ward_End_Dttm] AS DATETIME) > @MaxDate 
			))
			OR EXISTS ( SELECT 1 FROM [dbo].[tblHL7_SendTracker_PatientVisit] tr WHERE tr.SourceSystem = 'MH' AND tr.PV_ID = pv.PV_ID AND tr.[SendResult] <> 'AA')


		DECLARE @NoOfRecords INT = @@ROWCOUNT
		IF @NoOfRecords > 0
		BEGIN 
			INSERT INTO [dbo].[tblHL7_TableTracker] 
				VALUES 
				(	  'CNS'
					, 'CNS_PatientVisit'
					, getdate() 
					, (SELECT ISNULL(MAX([WardStay_Updated_Dttm]),0) FROM [hl7].[tblPatientVisit] WHERE LEFT(PV_ID,2) = 'MH')
					, @LoadId
					,@NoOfRecords
				)
		END 

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
