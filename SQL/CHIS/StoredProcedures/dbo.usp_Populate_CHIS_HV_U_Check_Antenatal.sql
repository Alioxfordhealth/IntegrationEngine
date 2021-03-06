SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

-- This report incorporates HV Antenatal Contact and KPI HV Antenatal Letter
-- Antenatal letter sent Taken from the [dbo].[udfOHFTCYPHVMaternalAntenatalAssessment] table
-- Antenatal contact (Visit) taken from the same table
-- TO select Mopther with Child
-- To run on 04

CREATE PROCEDURE [dbo].[usp_Populate_CHIS_HV_U_Check_Antenatal]
AS

/*
test Script:
=================
EXEC [dbo].[Populate_CHIS_HV_U_Check_Antenatal] '17 Sep 2018','21 Sep 2018'


Development Comments:
=====================
Part 1 - Read the maximum Update datetime for TABLE_NAME = 'Antenatal' from [chis].[tblCHIS_TableTracker] and generate new load id (previous load id  + 1)
Part 2 - Truncate and populate table chis.tblCHIS_HV_U_Check_Antenatal
Part 3 - log the new data load info to [chis].[tblCHIS_TableTracker] including the new maximum Update datetime and load id


*/

DECLARE @Max_Date DATETIME;

SET @Max_Date =	ISNULL((SELECT MAX(MaxUpdateTime) FROM [CHIS].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'Antenatal'),'1 Jan 1900');


DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [CHIS].[tblCHIS_TableTracker] WHERE TABLE_NAME = 'Antenatal'),0)
SET @LoadId = @LoadId + 1

--ALTER TABLE CHIS.tblCHIS_HV_U_Check_Antenatal ADD LoadID INT

			IF OBJECT_ID('dbo.tmpchis_MOTHERLINK','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_MOTHERLINK

			IF OBJECT_ID('dbo.tmpchis_REFS','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_REFS

			IF OBJECT_ID('dbo.tmpchis_CareNotesFORMV1','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_CareNotesFORMV1

			IF OBJECT_ID('dbo.tmpchis_CareNotesFORMV2','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_CareNotesFORMV2

			IF OBJECT_ID('dbo.tmpchis_AntenatalBoth','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_AntenatalBoth

			IF OBJECT_ID('dbo.tmpchis_CareNotesFORM','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_CareNotesFORM

			IF OBJECT_ID('dbo.tmpchis_FIRSTFORM','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_FIRSTFORM

			IF OBJECT_ID('dbo.tmpchis_SECONDFORM','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_SECONDFORM

			IF OBJECT_ID('dbo.tmpchis_AntenatalAssessCN','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_AntenatalAssessCN

			IF OBJECT_ID('dbo.tmpchis_TOGETHER','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_TOGETHER

			IF OBJECT_ID('dbo.tmpchis_FINAL','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_FINAL

			IF OBJECT_ID('dbo.tmpchis_ADDINSecondForm','U') IS NOT NULL 
			DROP TABLE dbo.tmpchis_ADDINSecondForm

SET NOCOUNT ON;

BEGIN TRY

	BEGIN TRANSACTION;

			TRUNCATE TABLE CHIS.tblCHIS_HV_U_Check_Antenatal;


			--WITH MOTHERLINK
			--AS (
			SELECT L.[Patient_ID] AS 'Mother_ID',
					   MP.[NHS_Number] AS 'Mother_NHS',
					   MP.[Surname] AS 'Mother_Surname',
					   MP.[Forename] AS 'Mother_Forename',
					   MP.[Date_Of_Birth] AS 'Mother_DoB',
					   L.[Linked_Patient_ID] AS 'Child_ID',
					   CP.[NHS_Number] AS 'Child_NHS',
					   CP.[Surname] AS 'Child_Surname',
					   CP.[Forename] AS 'Child_Forename',
					   CASE
						   WHEN CP.Gender_ID = 0 THEN
							   'Not known'
						   WHEN CP.Gender_ID = 1 THEN
							   'Not specified'
						   WHEN CP.Gender_ID = 2 THEN
							   'Female'
						   WHEN CP.Gender_ID = 3 THEN
							   'Male'
						   WHEN CP.Gender_ID = 4 THEN
							   'Prefer not to say'
					   END AS 'Child_Gender',
					   CP.[Date_Of_Birth] AS 'Child_DoB',
					   CONVERT(VARCHAR(7), CP.[Date_Of_Birth], 120) AS 'Birth_Month',
					   -- To show when baby reaches 9 weeks old when PN Mood Assessment should be completed by
					   DATEADD(DAY, 63, CP.[Date_Of_Birth]) AS 'BabiesDOB+63Days'
			INTO dbo.tmpchis_MOTHERLINK
				FROM mrr.[CNC_tblClientLink] L
					LEFT OUTER JOIN mrr.[CNC_tblPatient] MP
						ON L.[Patient_ID] = MP.[Patient_ID]
					LEFT OUTER JOIN mrr.[CNC_tblPatient] CP
						ON L.[Linked_Patient_ID] = CP.[Patient_ID]
				-- The relationship_ID 9 is Parent.  This pulls out all the parents with the ID of child linked to the parent ID
				WHERE L.[Relationship_ID] = 9
					  AND MP.[Date_Of_Death] IS NULL
					  AND CP.[Date_Of_Death] IS NULL
					  AND L.End_Date IS NULL
					  AND (MP.[Surname] NOT LIKE '%XX%Test%' OR MP.[Surname] NOT LIKE '%Do%Not%Use%')


			--ORDER BY CP.[Date_Of_Birth]
			--)    ,
				 -- To selectd all patients with an open referral to HV
			--REFS
			--AS (
				SELECT *
				INTO dbo.tmpchis_REFS
				FROM
				(
					SELECT  epi.Patient_ID --    R.[FCT_Referral_Client_BK],
						   , epi.Patient_ID AS 'Client_ID' -- RIGHT(R.[FCT_Referral_Client_BK], 6) AS 'Client_ID',
						   , epi.Referral_Received_Date -- R.[FCT_Referral_Date_Received],
						   , loc.Location_Name -- loc.Location_Name,
						   , ROW_NUMBER() OVER (PARTITION BY epi.Patient_ID
											  ORDER BY epi.Referral_Received_Date DESC
											 ) AS 'RN',
						   CASE
							   WHEN loc.Location_Name LIKE 'HVC%' THEN
								   'Central'
							   WHEN loc.Location_Name LIKE 'HVN%' THEN
								   'North'
							   WHEN loc.Location_Name LIKE 'HVS%' THEN
								   'South'
							   WHEN loc.Location_Name LIKE 'HVB BIC North Bicester' THEN
								   'North Bicester'
							   WHEN loc.Location_Name LIKE 'HV Family%' THEN
								   'Family Nurse Partnership'
							   ELSE
								   'Unknown'
						   END AS 'Area',
						   (CASE
								WHEN loc.Location_Name LIKE 'HVB BIC North Bicester' THEN
									'North Bicester'
								WHEN loc.Location_Name LIKE 'HVC  HEA%'
									 OR loc.Location_Name LIKE 'HVC HEA%' THEN
									'Headington'
								WHEN loc.Location_Name LIKE 'HVC  NOX%'
									 OR loc.Location_Name LIKE 'HVC NOX%' THEN
									'North Oxford'
								WHEN loc.Location_Name LIKE 'HVC IF%' THEN
									'Iffley'
								WHEN loc.Location_Name LIKE 'HVC SOX%' THEN
									'South Oxford'
								WHEN loc.Location_Name LIKE 'HVN BAN%' THEN
									'Banbury'
								WHEN loc.Location_Name LIKE 'HVN BIC%' THEN
									'Bicester'
								WHEN loc.Location_Name LIKE 'HVN CN%' THEN
									'Chipping Norton'
								WHEN loc.Location_Name LIKE 'HVN WIT%' THEN
									'Witney'
								WHEN loc.Location_Name LIKE 'HVS ABI%' THEN
									'Abingdon'
								WHEN loc.Location_Name LIKE 'HVS DID%' THEN
									'Didcot'
								WHEN loc.Location_Name LIKE 'HVS HEN%' THEN
									'Henley'
								WHEN loc.Location_Name LIKE 'HVS WAN%' THEN
									'Wantage'
								WHEN loc.Location_Name LIKE 'HV Family%' THEN
									'Family Nurse Partnership'
								ELSE
									'Unknown'
							END
						   ) AS Locality
						   --R.[FCT_Referral_Client_Responsible_Org_NatCode],
						   --R.[FCT_Referral_Client_Responsible_Org_NatDesc]
					FROM mrr.CNC_tblEpisode epi
					LEFT JOIN mrr.CNC_tblLocation loc
						ON epi.Location_ID = loc.Location_ID
					WHERE (
							  loc.Location_Name LIKE 'HV%'
							  OR loc.Location_Name LIKE 'zHV%'
								 AND loc.Location_Name NOT IN ( 'HV Childrens Centres', 'HV BCG',
																				  'HV Breast Feeding AN', 'HV Breast Feeding PN'
																				)
						  )
						  AND epi.Discharge_Date IS NULL
						  --AND epi.Patient_ID = 654672
				) AS X
				WHERE RN = 1
			--),
				 --SELECT * FROM REFS
				 -- TO pull out all Maternal Antenatal Assessment forms and whether an Antenatal letter has been sent
				 -- or Antenatal Visit Achieved from Carenotes
				 -- As Carenotes users are creating new forms instead of editing the original form, this needs to be 
				 -- negated for which is why there are several tables

			--CareNotesFORMV1
			--AS (
				SELECT AA.[Patient_ID],
					   P.[NHS_Number],
					   NULL AS 'Confirm_Flag_ID',
					   AA.[EstDueDate],
					   CASE
						   WHEN [LetterSentID] = 0 THEN
							   'No'
						   WHEN [LetterSentID] = 1 THEN
							   'Yes'
						   ELSE
							   'Not Known'
					   END AS 'Antenatal_Letter',
					   CASE
						   WHEN [AntenatalVisitAchievedID] = 0 THEN
							   'No'
						   WHEN [AntenatalVisitAchievedID] = 1 THEN
							   'Yes'
						   ELSE
							   'Form Not Completed'
					   END AS 'Antenatal_Visit',
					   AV.[UDP_AVNotAchieved_Desc] AS 'Reason_AV_Not_Achieved',
					   AA.[Create_Dttm]
				--ROW_NUMBER() OVER(PARTITION BY AA.[Patient_ID]  ORDER BY AA.[Create_Dttm] ASC) AS 'RN'
				INTO dbo.tmpchis_CareNotesFORMV1
				FROM mrr.[CNC_udfOHFTCYPHVMaternalAntenatalAssessment] AA
					LEFT OUTER JOIN mrr.[CNC_udpAVNotAchievedValues] AV
						ON AA.[ReasonNotAchievedID] = AV.[UDP_AVNotAchieved_ID]
					LEFT OUTER JOIN mrr.[CNC_tblPatient] P
						ON AA.[Patient_ID] = P.[Patient_ID]
			--),


			--CareNotesFORMV2
			--AS (
				SELECT AA.[Patient_ID],
					   P.[NHS_Number],
					   AA.[Confirm_Flag_ID],
					   AA.[fldHvMatAnAsmtEstDueDate],
					   CASE
						   WHEN [fldHvMatAnAsmtLetterSentID] = 0 THEN
							   'Not Assessed'
						   WHEN [fldHvMatAnAsmtLetterSentID] = 1 THEN
							   'Yes'
						   WHEN [fldHvMatAnAsmtLetterSentID] = 2 THEN
							   'No'
						   ELSE
							   'Not Known'
					   END AS 'Antenatal_Letter',
					   --[fldHvMatAnAsmtLetterSentText],
					   CASE
						   WHEN [fldHvMatAnAsmtAnVstAchievedID] = 0 THEN
							   'Not Assessed'
						   WHEN [fldHvMatAnAsmtAnVstAchievedID] = 1 THEN
							   'Yes'
						   WHEN [fldHvMatAnAsmtAnVstAchievedID] = 2 THEN
							   'No'
						   ELSE
							   'Form Not Completed'
					   END AS 'Antenatal_Visit',
					   AV.[UDP_AVNotAchieved_Desc] AS 'Reason_AV_Not_Achieved',
					   -- [fldHvMatAnAsmtAnVstAchievedTextID],
					   --AV.[UDP_AVNotAchieved_Desc] AS 'Reason_AV_Not_Achieved',
					   AA.[Create_Dttm]
				--ROW_NUMBER() OVER(PARTITION BY AA.[Patient_ID]  ORDER BY AA.[Create_Dttm] ASC) AS 'RN'
				INTO dbo.tmpchis_CareNotesFORMV2
				FROM mrr.[CNC_udfCYPHVMaternalAntenatalAssessmentV2] AA
					LEFT OUTER JOIN mrr.[CNC_udpAVNotAchievedValues] AV
						ON AA.[fldHvMatAnAsmtAnVstAchievedTextID] = AV.[UDP_AVNotAchieved_ID]
					LEFT OUTER JOIN mrr.[CNC_tblPatient] P
						ON AA.[Patient_ID] = P.[Patient_ID]
			--),


			--AntenatalBoth
			--AS (
			SELECT a.*
			INTO dbo.tmpchis_AntenatalBoth
			FROM (
					SELECT *
					FROM dbo.tmpchis_CareNotesFORMV1
					UNION ALL
					SELECT *
					FROM dbo.tmpchis_CareNotesFORMV2
				) a
			--),

			--CareNotesFORM
			--AS (
				SELECT A.*,
					   ROW_NUMBER() OVER (PARTITION BY [Patient_ID] ORDER BY [Create_Dttm] ASC) AS 'RN'
				INTO dbo.tmpchis_CareNotesFORM
				FROM dbo.tmpchis_AntenatalBoth A
			--),

			--FIRSTFORM
			--AS (
				SELECT *
				INTO dbo.tmpchis_FIRSTFORM
				FROM dbo.tmpchis_CareNotesFORM
				WHERE RN = 1
			--),
				 --SELECT * FROM FIRSTFORM

			--SECONDFORM
			--AS (
				SELECT *
				INTO dbo.tmpchis_SECONDFORM
				FROM dbo.tmpchis_CareNotesFORM
				WHERE RN > 1
			--),


			--ADDINSecondForm
			--AS (
				SELECT F.[Patient_ID],
					   F.[NHS_Number],
					   F.Antenatal_Letter,
					   CASE
						   WHEN S.RN = '2' THEN
							   S.Antenatal_Visit
						   WHEN S.RN = '3' THEN
							   S.Antenatal_Visit
						   ELSE
							   F.Antenatal_Visit
					   END AS 'Antenatal_Visit',
					   CASE
						   WHEN S.RN = '2' THEN
							   S.Reason_AV_Not_Achieved
						   WHEN S.RN = '3' THEN
							   S.Reason_AV_Not_Achieved
						   ELSE
							   F.Reason_AV_Not_Achieved
					   END AS 'Reason_AV_Not_Achieved',
					   CASE
						   WHEN S.RN = '2' THEN
							   S.[Create_Dttm]
						   WHEN S.RN = '3' THEN
							   S.Create_Dttm
						   ELSE
							   F.[Create_Dttm]
					   END AS 'Create_Dttm',
					   CASE
						   WHEN S.RN = '2' THEN
							   S.[Confirm_Flag_ID]
						   WHEN S.RN = '3' THEN
							   S.[Confirm_Flag_ID]
						   ELSE
							   F.[Confirm_Flag_ID]
					   END AS 'Confirm_Flag_ID'
				INTO dbo.tmpchis_ADDINSecondForm
				FROM dbo.tmpchis_FIRSTFORM F
					LEFT OUTER JOIN dbo.tmpchis_SECONDFORM S
						ON F.Patient_ID = S.Patient_ID
			--),


			--AntenatalAssessCN
			--AS (
				SELECT *
				INTO dbo.tmpchis_AntenatalAssessCN
				FROM
				(
					SELECT A.*,
						   ROW_NUMBER() OVER (PARTITION BY [Patient_ID] ORDER BY [Create_Dttm] DESC) AS 'RN'
					FROM dbo.tmpchis_ADDINSecondForm A
				) AS X
				WHERE RN = 1
			--),
				 --select * from AntenatalAssessCN where Patient_ID = '170679'
				 -- Rio Data has been excluded from this SSRS report as GO Live was more than a year ago
				 -- If RiO data is needed, use the SQL in the IR Folder IR 1736

			--CurrentAddress AS 
			--(
			--	SELECT Patient_ID, Post_Code, updated_Dttm, ROW_NUMBER() OVER (PARTITION BY Patient_ID ORDER BY updated_Dttm DESC) AS 'RN'
			--	FROM mrr.CNC_tblAddress
			--	WHERE ISNULL(End_Date,'') = ''
			--	),


			--TOGETHER
			--AS (
				SELECT M.Mother_ID,
					   M.Mother_NHS,
					   M.Mother_Surname,
					   M.Mother_Forename,
					   M.Mother_DoB,
					   M.Child_ID,
					   M.Child_NHS,
					   M.Child_Surname,
					   M.Child_Forename,
					   M.Child_Gender,
					   M.Child_DoB,
					   M.Birth_Month,
					   --D.Post_Code  AS Dim_Post_Code, -- D.[Dim_Post_Code],
					   R.Referral_Received_Date,  -- R.[FCT_Referral_Date_Received],
					   R.Location_Name,
					   R.Area,
					   R.Locality,
					   --CASE
					   --    WHEN LA.[Local_Authority_Code] IS NULL THEN
					   --        'Unknown'
					   --    ELSE
					   --        LA.[Local_Authority_Code]
					   --END AS 'Local_Authority_Code',
					   --CASE
					   --    WHEN LA.[Local_Authority_Name] IS NULL THEN
					   --        'Unknown'
					   --    ELSE
					   --        LA.[Local_Authority_Name]
					   --END AS 'Local_Authority_Name',
					   --R.[FCT_Referral_Client_Responsible_Org_NatCode],
					   --R.[FCT_Referral_Client_Responsible_Org_NatDesc],
					   --CASE
					   --    WHEN CC.[Postcode] IS NULL THEN
					   --        'Unknown'
					   --    ELSE
					   --        CC.[HV_Childrens_Centre]
					   --END AS 'Childrens_Centre',
					   CASE
						   WHEN
						   (
							   A.[Create_Dttm] < M.Child_DoB
							   AND DATEDIFF(WEEK, A.[Create_Dttm], M.Child_DoB)
						   BETWEEN 0 AND 40
						   ) THEN
							   A.Antenatal_Letter
						   ELSE
							   'Antenatal Form Missing'
					   END AS 'AnteNatal_Letter',
					   CASE
						   WHEN
						   (
							   A.[Create_Dttm] < M.Child_DoB
							   AND DATEDIFF(WEEK, A.[Create_Dttm], M.Child_DoB)
						   BETWEEN 0 AND 40
						   ) THEN
							   A.Antenatal_Visit
						   ELSE
							   'Antenatal Form Missing'
					   END AS 'AnteNatal_Visit',
					   CASE
						   WHEN
						   (
							   A.[Create_Dttm] < M.Child_DoB
							   AND DATEDIFF(WEEK, A.[Create_Dttm], M.Child_DoB)
						   BETWEEN 0 AND 40
						   ) THEN
							   A.Reason_AV_Not_Achieved
						   ELSE
							   'Antenatal Form Missing'
					   END AS 'Reason_AV_Not_Achieved',
					   CASE
						   WHEN A.[Confirm_Flag_ID] = 1 THEN
							   'Yes'
						   WHEN A.[Confirm_Flag_ID] = 0 THEN
							   'No'
						   ELSE
							   'Old Form'
					   END AS 'Form_Confirmed',
					   ROW_NUMBER() OVER (PARTITION BY M.Mother_NHS, M.Child_DoB ORDER BY M.Child_DoB DESC) AS 'RN',
					   A.Create_Dttm
				INTO dbo.tmpchis_TOGETHER
				FROM dbo.tmpchis_MOTHERLINK M
					LEFT OUTER JOIN dbo.tmpchis_REFS R
						ON M.Mother_ID = R.Client_ID
					LEFT OUTER JOIN dbo.tmpchis_AntenatalAssessCN A
						ON M.Mother_ID = A.Patient_ID
					--LEFT OUTER JOIN mrr.[CDA_EPR_Dim_Address] D
					--    ON M.Mother_ID = RIGHT(D.[Dim_Client_BK], 6)
					--       AND D.[Dim_Address_Current_Record] = 'Y'
					--       AND [EPR_System] = 'CNS_CH'
					--LEFT JOIN CurrentAddress D 
					--	ON D.Patient_ID = M.Mother_ID
					--	AND D.RN = 1
			
					--LEFT OUTER JOIN mrr.[CDI_REF_ODS_NHS_POSTCODE_DIRECTORY] LA
					--    ON D.[Dim_Post_Code] = LA.[Postcode]
					--LEFT OUTER JOIN [OXH_EDM_DW].[dbo].[HVChildrensCentre_BY_PostCode] CC
					--    ON D.[Dim_Post_Code] = CC.[Postcode]),
				 --SELECT * FROM TOGETHER 
				 --WHERE Mother_NHS = 6017249967
			--),


			--FINAL
			--AS (
				SELECT Mother_ID,
					   Mother_NHS,
					   Mother_Surname,
					   Mother_Forename,
					   Mother_DoB,
					   Child_ID,
					   Child_NHS,
					   Child_Surname,
					   Child_Forename,
					   Child_Gender,
					   Child_DoB,
					   Birth_Month,
					   --[Dim_Post_Code],
					   Referral_Received_Date , --[FCT_Referral_Date_Received],
					   T.Location_Name , --[FCT_Referral_Referral_Team_Desc],
					   Area,
					   Locality,
					   --Local_Authority_Code,
					   --Local_Authority_Name,
					   --[FCT_Referral_Client_Responsible_Org_NatCode],
					   --[FCT_Referral_Client_Responsible_Org_NatDesc],
					   --Childrens_Centre,
					   -- 27/02/2017 Email from Lucy Trywhitt.  If the Antenatal Form template is present, but not completed, then this is
					   -- to be classed as a 'Yes' in the Antental Letter column.  Agreed with service
					   CASE
						   WHEN AnteNatal_Letter = 'Antenatal Form Missing' THEN
							   'No'
						   ELSE
							   'Yes'
					   END AS 'AnteNatal_Letter',
					   AnteNatal_Visit,
					   CASE
						   WHEN AnteNatal_Visit = 'Yes' THEN
							   'Not Applicable'
						   WHEN AnteNatal_Visit = 'Form Not Completed' THEN
							   'Form Not Completed'
						   WHEN Reason_AV_Not_Achieved IS NULL THEN
							   'Reason Not Given'
						   ELSE
							   Reason_AV_Not_Achieved
					   END AS 'Reason_AV_Not_Achieved',
					   Form_Confirmed,
					   Create_Dttm
				INTO dbo.tmpchis_FINAL
				FROM dbo.tmpchis_TOGETHER T
				WHERE RN = 1
			--)
			--AND T.Mother_NHS = '4743547571'
			--WHERE [FCT_Referral_Referral_Team_Desc] IS NOT NULL


			SELECT DISTINCT
				   F.*,
				   CASE
					   WHEN AnteNatal_Letter LIKE '%yes%' THEN
						   1
					   ELSE
						   0
				   END AS 'Antenatal_Letter_Count',
				   CASE
					   WHEN AnteNatal_Visit LIKE '%yes%' THEN
						   1
					   ELSE
						   0
				   END AS 'Antental_Visit_Count',
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Antenatal Form Missing' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Antenatal Form Missing', -- No antental form has been created for this child
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Form Not Completed' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Form_Not_Completed',     -- Antental form not completed for Antenatal Visit AND Reason vist  not achived
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Declined Contact' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Declined',
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Baby born early' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Baby_Born_Early',
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Family moved away' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Moved_Away',
				   CASE
					   WHEN Reason_AV_Not_Achieved = 'Reason Not Given' THEN
						   1
					   ELSE
						   0
				   END AS 'Reason_Not_Given'               -- Antenatal Visit marked as NO but no reason for lack of visit given
			--Create_Dttm
			INTO #Temp_final
			FROM dbo.tmpchis_FINAL F
			--WHERE DATEDIFF (MONTH,Child_DoB,GETDATE()) BETWEEN 0 and 12
			WHERE Create_Dttm > @Max_Date --BETWEEN @StaDate AND @EndDate  -- 
				  AND AnteNatal_Visit = 'Yes';

			--quite a few antenatal forms missing?
			--check a few on front end that say they are missing for dq purposes
			--need to rewrite sql?
			--no way to link antenatal form to a specific child - report takes latest antenatal form for the mother and links to any child born in last 6 months
			--if she has had two children within a year you will get duplicates


			PRINT '1'

			INSERT INTO CHIS.tblCHIS_HV_U_Check_Antenatal([Mother_NHS],[Mother_Forename],[Mother_Surname],[Mother_DOB],[Date_of_contact],[Venue_of_visit],[Created_Dttm], LoadID)
			SELECT DISTINCT
				--Child_NHS,
				   #Temp_final.Mother_NHS,

										   --#Temp_final.Child_Forename,
										   --#Temp_final.Child_Surname,
				   #Temp_final.Mother_Forename,
				   #Temp_final.Mother_Surname,

										   --convert(date,#Temp_final.Child_DoB) as 'Child_DOB',
				   CONVERT(DATE, #Temp_final.Mother_DoB) AS 'Mother_DOB',

										   --#Temp_final.Child_Gender,

				   CONVERT(DATE, Create_Dttm) AS 'Date_of_contact',
				   '' AS 'Venue_of_visit', --not available on form
				   Create_Dttm,
				   @LoadID
			FROM #Temp_final;



			-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM CHIS.tblCHIS_HV_U_Check_Antenatal WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [CHIS].[tblCHIS_TableTracker]
				VALUES
				(   'Antenatal',  GETDATE() ,
					(
						SELECT ISNULL(MAX(Created_Dttm), GETDATE())
						FROM CHIS.tblCHIS_HV_U_Check_Antenatal
					), @LoadID);
			END 

		COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH;


IF OBJECT_ID('dbo.tmpchis_MOTHERLINK','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_MOTHERLINK

IF OBJECT_ID('dbo.tmpchis_REFS','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_REFS

IF OBJECT_ID('dbo.tmpchis_CareNotesFORMV1','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_CareNotesFORMV1

IF OBJECT_ID('dbo.tmpchis_CareNotesFORMV2','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_CareNotesFORMV2

IF OBJECT_ID('dbo.tmpchis_AntenatalBoth','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_AntenatalBoth

IF OBJECT_ID('dbo.tmpchis_CareNotesFORM','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_CareNotesFORM

IF OBJECT_ID('dbo.tmpchis_FIRSTFORM','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_FIRSTFORM

IF OBJECT_ID('dbo.tmpchis_SECONDFORM','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_SECONDFORM

IF OBJECT_ID('dbo.tmpchis_AntenatalAssessCN','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_AntenatalAssessCN

IF OBJECT_ID('dbo.tmpchis_TOGETHER','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_TOGETHER

IF OBJECT_ID('dbo.tmpchis_FINAL','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_FINAL

IF OBJECT_ID('dbo.tmpchis_ADDINSecondForm','U') IS NOT NULL 
DROP TABLE dbo.tmpchis_ADDINSecondForm

DROP TABLE #Temp_final;



GO
