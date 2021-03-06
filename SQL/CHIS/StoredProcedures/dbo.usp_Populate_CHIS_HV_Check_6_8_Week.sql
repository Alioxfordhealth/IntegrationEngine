SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To extract all Children who have had a 6 - 8 Week Review completed
-- This is found in the Child Health Module
-- The Row_NUmber SQL is to order the 6 - 8 Week Review by whether it has been completed and the date to make
-- sure only those completed and the first one of these for each child is extracted
-- ch.preferredterm is used as AH&C haven't populated SnomedValue correctly

--CREATE VIEW [mrr].[ACCNC_PatientClinicalCode] AS SELECT [PatientId], [EventId], [TemplateSubmissionIdx], [SnomedCode], [SnomedValue], [EventDate], [_idx], [_createdDate], [_expiredDate], [Id], [_version], [EventTypeId], [GroupId], [Numeric], [Unit], [SectionGroupId] FROM [OHMirror].[Mirror].[mrr_tbl].[ACCNC_PatientClinicalCode];

CREATE PROCEDURE [dbo].[usp_Populate_CHIS_HV_Check_6_8_Week]
AS

/*
test Script:
=============
EXEC [dbo].[Populate_CHIS_HV_Check_6_8_Week] '17 Sep 2018','21 Sep 2018'
SELECT * FROM [chis].[tblCHIS_TableTracker] 

Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = '6_8_Week' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.tblCHIS_HV_Check_6_8_Week
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id

*/

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '6_8_Week'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = '6_8_Week'), 0)
SET @LoadId = @LoadId + 1


SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

			--ALTER TABLE chis.tblCHIS_HV_Check_6_8_Week ADD LoadID INT  

			TRUNCATE TABLE chis.tblCHIS_HV_Check_6_8_Week 


			SELECT * 
			INTO #Temp_SixtoEightWeekHVReview
			FROM (SELECT [CarenotesPatientId],
								   D.[NHS_Number] AS 'NHS_Number',
								   [LongName],
								   CASE WHEN [OutcomeDesc] IS NULL THEN 'Unoutcomed' ELSE OutcomeDesc END AS 'Six_to_Eight_Week_Review',
								   [DateOutcome] AS 'Date_of_SixtoEightWeekReview',
								   reviewlocationdesc,

								   ROW_NUMBER() OVER(PARTITION BY CarenotesPatientId ORDER BY case when [OutcomeCode] in ('as','hrcom') then 0 else 1 end asc,[DateOutcome] asc) as rn,
								   DATEDIFF (WEEK,D.[Date_Of_Birth],R.[DateOutcome]) AS 'Weeks_To_6to8_Review'
								  FROM [dbo].[ReportPatientReview] R  WITH ( NOLOCK )
								  --LEFT JOIN [OXH_EDM_LIVE].[dbo].[CDA_EPR_Dim_Client] D  WITH ( NOLOCK ) ON R.CarenotesPatientId = RIGHT (D.[Dim_Client_BK], 6) AND D.EPR_System = 'CNS_CH'
								  LEFT JOIN [mrr].[CNC_tblPatient] D 
									ON R.CarenotesPatientId = RIGHT (D.Patient_ID, 6)
								  WHERE LongName LIKE  '%6-8 Week Health Visiting Review%' 
									--	 AND [OutcomeCode] in ('as','hrcom')
  
			)AS X
			WHERE RN = 1
			;
 

			SELECT *
			INTO #Temp_BreastQ 
			FROM (SELECT distinct
			pr.ShortName,
			 pr.CarenotesPatientId,
			 pr.DateOutcome,
			 pcc.EventDate,
			 SnomedValue,
			 snomedcode,
			 ch.preferredterm,
			 CASE WHEN SnomedValue IS NULL AND ch.preferredterm = 'Infant bottle fed' THEN 'Not at all breastfed'
			  WHEN SnomedValue IS NULL AND ch.preferredterm = 'Breastfeeding with supplement' THEN 'Partially breastfed'
			  WHEN SnomedValue IS NULL AND ch.preferredterm = 'Breast fed' THEN 'Totally breastfed'
			  ELSE SnomedValue END AS 'Feeding',
			 ROW_NUMBER() OVER(PARTITION BY pr.CarenotesPatientId ORDER BY pr.DateOutcome asc) AS RN
			FROM  [dbo].[ReportPatientReview] pr

			JOIN [mrr].[ACCNC_PatientClinicalCode] pcc ON pr.ConsultationId = pcc.EventId
			join [bilivedb].[ApexSnomed].[dbo].[View_ConceptHierarchy] ch on ch.ConceptID=pcc.SnomedCode
			WHERE pr.ShortName LIKE  '%6-8 Week Health Visiting Review%'
			AND pcc.SnomedCode in ('169743001','169741004','268472006')) AS X
			WHERE RN = 1
			;


			SELECT S.CarenotesPatientId,
			S.NHS_Number,

				   S.Six_to_Eight_Week_Review,
				   S.Date_of_SixtoEightWeekReview,
				   S.Weeks_To_6to8_Review,
				   BF.Feeding AS 'Feeding_at_6to8',
				   s.ReviewLocationDesc
	  
			INTO #Temp_SixtoEightWithFeed
			FROM #Temp_SixtoEightWeekHVReview S 
			LEFT OUTER JOIN #Temp_BreastQ BF 
			ON S.CarenotesPatientId = BF.CarenotesPatientId

			where
			Date_of_SixtoEightWeekReview > @Max_Date -- BETWEEN @StaDate AND @EndDate -- 
			AND Six_to_Eight_Week_Review = 'Completed'


			INSERT INTO chis.tblCHIS_HV_Check_6_8_Week([NHS_Number] ,[forename] ,[surname] ,[Child_DOB] ,[Child_Gender] ,[Date_of_contact] ,[Breast_Feeding_Status] ,[Review_Location_Desc] ,[Created_Dttm] ,[LoadID])
			select distinct
			#Temp_SixtoEightWithFeed.NHS_Number,

			p.forename,
			p.surname,
			convert(date,p.date_of_birth) as 'Child_DOB',

			case
			when p.Gender_ID = 0 then 'Not known'
			when p.Gender_ID = 1 then 'Not specified'
			when p.Gender_ID = 2 then 'Female'
			when p.Gender_ID = 3 then 'Male'
			when p.Gender_ID = 4 then 'Prefer not to say' end as 'Child_Gender',

			convert(date,#Temp_SixtoEightWithFeed.Date_of_SixtoEightWeekReview) as 'Date_of_contact',

			case when #Temp_SixtoEightWithFeed.Feeding_at_6to8 like '%totally%' then 'T'
			when #Temp_SixtoEightWithFeed.Feeding_at_6to8 like '%partially%' then 'P'
			when #Temp_SixtoEightWithFeed.Feeding_at_6to8 like '%not%' then 'N'
			else null end as 'Breastfeeding status',

			#Temp_SixtoEightWithFeed.ReviewLocationDesc,
			Date_of_SixtoEightWeekReview,
			@LoadId
			from #Temp_SixtoEightWithFeed

			left join mrr.[CNC_tblPatient] p on #Temp_SixtoEightWithFeed.NHS_Number = p.NHS_Number

			--where
			--#Temp_SixtoEightWithFeed.NHS_Number not in ('4744130747',
			--'4185542224') --remove obvious dq errors (based on dob)

			-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM chis.tblCHIS_HV_Check_6_8_Week WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [chis].[tblCHIS_TableTracker] VALUES ('6_8_Week', GETDATE() , (SELECT ISNULL(MAX(Created_Dttm),GETDATE()) FROM chis.tblCHIS_HV_Check_6_8_Week), @LoadId)
			END 

			

			drop table #Temp_SixtoEightWeekHVReview
			drop table #Temp_BreastQ
			drop table #Temp_SixtoEightWithFeed

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;

GO
