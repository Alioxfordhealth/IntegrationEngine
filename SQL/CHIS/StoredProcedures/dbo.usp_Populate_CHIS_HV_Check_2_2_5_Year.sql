SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE  PROCEDURE [dbo].[usp_Populate_CHIS_HV_Check_2_2_5_Year]
--(
--    @StaDate DATETIME,
--    @EndDate DATETIME
--)
AS 
/*
test Script:
EXEC [dbo].[Populate_CHIS_HV_Check_2_2_5_Year] '17 Sep 2018','21 Sep 2018'
SELECT * FROM [chis].[tblCHIS_TableTracker] 


Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = '2_2.5_Year' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.tblCHIS_HV_Check_2_2_5_Year
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id
*/


DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '2_2.5_Year'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '2_2.5_Year'), 0)
SET @LoadId = @LoadId + 1



--ALTER TABLE chis.tblCHIS_HV_Check_2_2_5_Year ADD LoadID int 

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

			TRUNCATE TABLE chis.tblCHIS_HV_Check_2_2_5_Year
			
			SELECT * 
			INTO #Temp_TwoYearHVReview
			FROM (	SELECT [CarenotesPatientId]
							, D.[NHS_Number] AS 'NHS_Number' 
							, [LongName] 
							, CASE WHEN [OutcomeDesc] IS NULL THEN 'Unoutcomed' ELSE [OutcomeDesc]  END AS 'Two_Year_Review' 
							, [DateOutcome] AS 'Date_of_TwoYearReview' 
							, DATEDIFF (MONTH, D.[Date_Of_Birth], [DateOutcome]) AS 'Months_to_2yrR' 
							, reviewlocationdesc 
							, ROW_NUMBER() OVER(PARTITION BY CarenotesPatientId ORDER BY case when [OutcomeCode] in ('as','hrcom') then 0 else 1 end asc,[DateOutcome] asc) as rn
					FROM [dbo].[ReportPatientReview] R  WITH ( NOLOCK ) 
					LEFT JOIN [mrr].[CNC_tblPatient] D  WITH ( NOLOCK ) 
						ON R.CarenotesPatientId = RIGHT (D.Patient_ID, 6) 
						--ON R.CarenotesPatientId = RIGHT (D.[Dim_Client_BK], 6) AND D.EPR_System = 'CNS_CH'
					WHERE LongName LIKE  '%2-2.5 Year Health Visiting Review%' 
					AND [OutcomeDesc] in ('Completed','Did Not Attend','Declined','Refused')
			) AS X WHERE rn = 1
			;


			-- -- To extract all those Children on RiO who have had a  2-2.5 year review as not all were migrated
			-- SELECT  null AS 'CarenotesPatientID'
			--         , [Client_NNN] AS 'NHS_Number'
			--         , NULL AS 'LongName'
			--		 , 'Completed RiO' AS 'Two_Year_Review'
			--		 , NULL AS 'Date_of_TwoYearReview'
			--         , [UA2YrAD_AssessmentDate] AS 'Date_Ages_and_Stages_Completed'
			--		 , [AgesaandStagesCompleted] AS 'Ages_and_Stages'
			--         , [Months_to_2yrR]
			--		 , 'null' as 'reviewlocationdesc'
			--INTO  #Temp_RIO2yrReview
			--FROM [OXH_EDM_DW].[RIOCH].[JoW_HV_ChildKPIDataV2] A

			--WHERE NOT EXISTS (SELECT NHS_Number
			--                   FROM 
			--				   #Temp_TwoYearHVReview T
			--				   WHERE A.Client_NNN = T.NHS_Number)
			--				   AND
			--					[UA2YrAD_AssessmentDate] IS NOT NULL


			--SELECT * FROM #Temp_RIO2yrReview
			--,
			-- To obtain the answer to the Ages and Stages Questionnaire
			-- There are three different boxes in the form that the HV could fill in (although they are only supposed
			-- to fill in the first box) so there are three snomed codes, one for each box.  
			-- The first (by date) form completed is the one taken.



			SELECT * 
			INTO #Temp_AgesandStagesQuestion
			FROM  (	SELECT 
						 pr.LongName
						 , pr.CarenotesPatientId
						 , pr.DateOutcome,pcc.EventDate
						 , SnomedValue AS 'Ages_and_Stages'
						 , ROW_NUMBER() OVER(PARTITION BY pr.CarenotesPatientId ORDER BY pr.DateOutcome asc, SnomedValue Desc) AS RN
					FROM [dbo].[ReportPatientReview] pr
					JOIN [mrr].[ACCNC_PatientClinicalCode] pcc  WITH ( NOLOCK )
						ON pr.ConsultationId = pcc.EventId
					WHERE pr.LongName LIKE  '%2-2.5 Year Health Visiting Review%'
					AND pcc.SnomedCode IN ('448615001','702481008','951851000000104')
			) AS X
			 WHERE RN = 1
			;

			 SELECT T.*,
					CASE WHEN A.Ages_and_Stages IS NULL THEN 'Not Completed' ELSE A.Ages_and_Stages END AS 'Ages_and_Stages',
					A.EventDate AS 'Date_Ages_and_Stages_Completed'
			INTO #Temp_TwoyrWithQuestion
			FROM #Temp_TwoYearHVReview T 
			LEFT OUTER JOIN #Temp_AgesandStagesQuestion A ON T.CarenotesPatientId = A.CarenotesPatientId

  
			;
			 -- TO Join all above together to obtain one table with Mother and Baby details and whether
			 -- a  2-2.5 year Review has been completed

			 SELECT * 
			 INTO #Temp_FINAL2Year 
			 FROM 
			(
			SELECT CarenotesPatientID,
				   NHS_Number,
				   Two_Year_Review,
				   Ages_and_Stages,
				   Date_of_TwoYearReview,
				   Months_to_2yrR,
				   Date_Ages_and_Stages_Completed,
				   ReviewLocationDesc
   
			 FROM #Temp_TwoyrWithQuestion 

			-- UNION ALL

			-- SELECT CarenotesPatientID,
			--	   NHS_Number,
			--	   Two_Year_Review,
			--	   Ages_and_Stages,
			--	   Date_of_TwoYearReview,
			--	   Months_to_2yrR,
			--	   Date_Ages_and_Stages_Completed,
			--	   reviewlocationdesc

			--FROM  #Temp_RIO2yrReview
			) AS X

			where
			Date_of_TwoYearReview > @Max_Date -- BETWEEN @StaDate AND @EndDate
			AND Two_Year_Review = 'Completed'


			INSERT INTO chis.tblCHIS_HV_Check_2_2_5_Year ([NHS_Number] ,[forename] ,[surname] ,[Child_DOB] ,[Child_Gender] ,[Date_of_contact] ,[Review_Location_Desc] ,[Created_Dttm] ,[LoadID])
			SELECT  DISTINCT 
					tmp.NHS_Number
					, p.forename
					, p.surname
					, convert(date,p.date_of_birth) as 'Child_DOB'
					, CASE	WHEN p.Gender_ID = 0 then 'Not known'
							when p.Gender_ID = 1 then 'Not specified'
							when p.Gender_ID = 2 then 'Female'
							when p.Gender_ID = 3 then 'Male'
							when p.Gender_ID = 4 then 'Prefer not to say' 
					  END as 'Child_Gender'
					, convert(date,tmp.Date_of_TwoYearReview) as 'Date_of_contact'
					, tmp.ReviewLocationDesc
					, Date_of_TwoYearReview
					, @LoadId
			FROM	#Temp_FINAL2Year tmp
			LEFT JOIN	mrr.[CNC_tblPatient] p 
				ON tmp.NHS_Number = p.NHS_Number
			WHERE tmp.NHS_Number is not null

			--and
			--#Temp_FINAL2Year.NHS_Number not in ('7126272146') --remove obvious dq errors (based on dob)


			-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM chis.tblCHIS_HV_Check_2_2_5_Year WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [chis].[tblCHIS_TableTracker] VALUES ('2_2.5_Year', GETDATE()  , (SELECT ISNULL(MAX(Created_Dttm),GETDATE()) FROM chis.tblCHIS_HV_Check_2_2_5_Year), @LoadID)
			END 
 
			drop table #Temp_AgesandStagesQuestion
			drop table #Temp_TwoYearHVReview
			drop table #Temp_TwoyrWithQuestion
			drop table #Temp_FINAL2Year

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
GO
