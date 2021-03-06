SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE  PROCEDURE [dbo].[usp_Populate_CNS_InscopePatientVisit]
AS

DECLARE @Max_Date DATETIME

SET @Max_Date = (	SELECT MAX([MaxUpdateTime]) 
					FROM [dbo].[tblHL7_TableTracker] 
					WHERE [SourceSystem] = 'CNS'
					AND TABLE_NAME = 'CNS_PatientVisit')

BEGIN TRY

	BEGIN TRANSACTION;

		TRUNCATE TABLE [dbo].[CNS_tblInscopePatientVisit]

		--Load New Data
		INSERT INTO  [dbo].[CNS_tblInscopePatientVisit]
		SELECT scope.Patient_ID
			, scope.Episode_ID
			, scope.Ward_Stay_ID
			, scope.WardStay_Updated_Dttm
		FROM [dbo].[vwCNS_InscopePatientVisit] scope
		WHERE scope.WardStay_Updated_Dttm > @Max_Date
		AND (scope.Actual_Start_Dttm > @Max_Date OR scope.Actual_End_Dttm > @Max_Date)


		--Load failed to send data
		INSERT INTO  [dbo].[CNS_tblInscopePatientVisit]
		SELECT W.Patient_ID
			, CND.Episode_ID
			, W.Ward_Stay_ID
			, W.Updated_Dttm AS WardStay_Updated_Dttm
		FROM mrr.CNS_tblWardStay AS W
		INNER JOIN mrr.CNS_tblCNDocument CND 
			ON W.Ward_Stay_ID = CND.CN_Object_ID
			AND Object_Type_ID = 82
		LEFT JOIN mrr.CNS_tblEpisode e
			ON cnd.Episode_ID = e.Episode_ID
		WHERE EXISTS (SELECT 1 FROM [dbo].[tblHL7_SendTracker_PatientVisit] pv WHERE pv.PV_ID LIKE 'MH%' AND W.Ward_Stay_ID = REPLACE(REPLACE(REPLACE(REPLACE(pv.PV_ID,'MH-',''),'-A01',''),'-A02',''),'-A03',''))
		AND NOT EXISTS (SELECT 1 FROM [dbo].[CNS_tblInscopePatientVisit] pv WHERE pv.Ward_Stay_ID = W.Ward_Stay_ID)



	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH

GO
