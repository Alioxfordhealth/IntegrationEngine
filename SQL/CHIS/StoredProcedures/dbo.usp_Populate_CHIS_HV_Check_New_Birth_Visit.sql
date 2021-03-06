SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- To pull out all New Birth Reviews from Carenotes and add in Feeding at Review
CREATE   PROCEDURE [dbo].[usp_Populate_CHIS_HV_Check_New_Birth_Visit]
AS 

/*
test Script:
=============
EXEC [dbo].[Populate_CHIS_HV_Check_New_Birth_Visit] '17 Sep 2018','21 Sep 2018' 
SELECT * FROM [chis].[tblCHIS_TableTracker] 
--delete from [chis].[tblCHIS_TableTracker]  where TABLE_NAME = 'New_Birth_Visit'


Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = 'New_Birth_Visit' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.tblCHIS_HV_Check_New_Birth_Visit
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id


*/

DECLARE @Max_Date DATETIME

SET @Max_Date = ISNULL((SELECT MAX(MaxUpdateTime) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'New_Birth_Visit'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [chis].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'New_Birth_Visit'), 0)
SET @LoadId = @LoadId + 1

--ALTER TABLE chis.tblCHIS_HV_Check_New_Birth_Visit ADD LoadID int  

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

			TRUNCATE TABLE chis.tblCHIS_HV_Check_New_Birth_Visit

			SELECT * 
			INTO #Temp_NewBirthReview
			FROM (SELECT [CarenotesPatientId],
			[LongName],
			CASE WHEN [OutcomeDesc] IS NULL THEN 'Unoutcomed' ELSE OutcomeDesc END AS 'New_Birth_Review',
			[DateOutcome] AS 'Date_of_NewBirthReview',
			reviewlocationdesc as 'Venue_of_visit',
			ROW_NUMBER() OVER(PARTITION BY CarenotesPatientId ORDER BY case when [OutcomeCode] in ('as','hrcom') then 0 else 1 end asc,[DateOutcome] asc) as rn

			FROM  [dbo].[ReportPatientReview] WITH ( NOLOCK )

			WHERE LongName LIKE  '%New Baby Review%' 

			--AND CarenotesPatientId = 584774
			)AS X
			WHERE RN = 1
			--AND New_Birth_Review = 'Unoutcomed'

			PRINT '1'

			-- to identify feeding at New Birth Visit
			SELECT * 
			INTO #Temp_BreastFeedQuestion 
			FROM  (SELECT distinct
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
			  ELSE SnomedValue END AS 'Feeding_At_NBR',
			 ROW_NUMBER() OVER(PARTITION BY pr.CarenotesPatientId ORDER BY pr.DateOutcome asc) AS RN
			FROM   [dbo].[ReportPatientReview] pr

			JOIN [mrr].[ACCNC_PatientClinicalCode] pcc ON pr.ConsultationId = pcc.EventId
			join [bilivedb].[ApexSnomed].[dbo].[View_ConceptHierarchy] ch on ch.ConceptID=pcc.SnomedCode
			WHERE pr.ShortName LIKE '%New Baby Review%'
			AND pcc.SnomedCode in ('169740003','169743001','169741004','268472006')) AS X
			 WHERE RN = 1


			 PRINT '2'

			SELECT N.*,
				   Q.Feeding_At_NBR,
					D.NHS_Number AS 'NHS_Number',
					DATEDIFF (DAY,D.Date_Of_Birth,N.[Date_of_NewBirthReview]) AS 'Days_To_NB_Review' 
			INTO #Temp_NBRwithBF
			FROM #Temp_NewBirthReview N LEFT OUTER JOIN #Temp_BreastFeedQuestion Q ON N.CarenotesPatientId = Q.CarenotesPatientId
			--LEFT OUTER JOIN [OXH_EDM_LIVE].[dbo].[CDA_EPR_Dim_Client] D WITH ( NOLOCK ) ON N.CarenotesPatientId = RIGHT (D.[Dim_Client_BK], 6) AND D.EPR_System = 'CNS_CH'
			LEFT JOIN [mrr].[CNC_tblPatient] D  WITH ( NOLOCK ) 
						ON Q.CarenotesPatientId = RIGHT (D.Patient_ID, 6)
			WHERE N.Date_of_NewBirthReview  > @Max_Date --BETWEEN @StaDate AND @EndDate--

			PRINT '3'

			INSERT INTO chis.tblCHIS_HV_Check_New_Birth_Visit([NHS_Number] ,[forename] ,[surname] ,[Child_DOB] ,[Child_Gender] ,[Date_of_contact] ,[Breast_feeding_status] ,[Venue_of_visit] ,[Created_Dttm] ,[LoadID])
			select distinct
			#Temp_NBRwithBF.NHS_Number,

			p.forename,
			p.surname,
			convert(date,p.date_of_birth) as 'Child_DOB',

			case
			when p.Gender_ID = 0 then 'Not known'
			when p.Gender_ID = 1 then 'Not specified'
			when p.Gender_ID = 2 then 'Female'
			when p.Gender_ID = 3 then 'Male'
			when p.Gender_ID = 4 then 'Prefer not to say' end as 'Child_Gender',

			convert(date,#Temp_NBRwithBF.Date_of_NewBirthReview) as 'Date_of_contact',

			case when #Temp_NBRwithBF.Feeding_At_NBR like '%totally%' then 'T'
			when #Temp_NBRwithBF.Feeding_At_NBR like '%partially%' then 'P'
			when #Temp_NBRwithBF.Feeding_At_NBR like '%not%' then 'N'
			else null end as 'Breastfeeding status',

			#Temp_NBRwithBF.Venue_of_visit,
			Date_of_NewBirthReview,
			@LoadID
			from #Temp_NBRwithBF

			left join mrr.[CNC_tblPatient] p on #Temp_NBRwithBF.NHS_Number = p.NHS_Number;

			--where
			--#Temp_NBRwithBF.NHS_Number not in ('4731334039',
			--'4731150248',
			--'4744055206',
			--'7085436018',
			--'6266065746') --remove obvious dq errors (based on dob)

			-- update Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM chis.tblCHIS_HV_Check_New_Birth_Visit WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [chis].[tblCHIS_TableTracker] VALUES ('New_Birth_Visit', GETDATE()  , (SELECT ISNULL(MAX(Created_Dttm),GETDATE()) FROM chis.tblCHIS_HV_Check_New_Birth_Visit), @LoadId)
			END 
			


			drop table #Temp_NewBirthReview
			drop table #Temp_BreastFeedQuestion
			drop table #Temp_NBRwithBF

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;
GO
