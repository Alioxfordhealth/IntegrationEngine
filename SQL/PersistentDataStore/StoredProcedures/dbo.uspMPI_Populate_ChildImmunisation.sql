SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE PROCEDURE [dbo].[uspMPI_Populate_ChildImmunisation]

as

/*
==============
Test script:
==============


*/

Declare @updated_dttm datetime = ISNULL((SELECT MAX(MaxUpdateTime) FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'School_Immunisation'),'1 Jan 1900')

DECLARE @LoadId int = ISNULL((SELECT MAX(LoadID) FROM [dbo].[tblPDS_TableTracker] WHERE TABLE_NAME = 'School_Immunisation'),0)
SET @LoadId = @LoadId + 1
PRINT @LoadId

-- Delete temporary tables if exists 
IF OBJECT_ID('dbo.tmpTemplateSubmission', 'U') IS NOT NULL
DROP TABLE dbo.tmpTemplateSubmission

IF OBJECT_ID('dbo.tmpTemplate', 'U') IS NOT NULL
DROP TABLE dbo.tmpTemplate



IF OBJECT_ID('CHIS.tblChildImmunisation', 'U') IS NULL
    BEGIN 

        SET ANSI_NULLS ON
        SET QUOTED_IDENTIFIER ON
        SET ANSI_PADDING ON
		
        CREATE TABLE  CHIS.tblChildImmunisation(
					Id VARCHAR(100),
					Patient_ID VARCHAR(100),
					CareNotesPatient_ID	INT ,
					ImmunisationPartNo INT,
					ImmunisationPartDescription VARCHAR(100),
					TreatmentCentre VARCHAR(100),
					GivenBy	VARCHAR(100),
					DateOccurred DATE,
					Outcome VARCHAR(50),
					WhereGiven	VARCHAR(50),
					BatchNumber VARCHAR(50),
					BatchExpiryDate DATE DEFAULT NULL,
					[Route]	VARCHAR(100),
					[SITE]	VARCHAR(100),
					[Comments] VARCHAR(255),
					CreatedDateTime datetime,
					LoadID int
				)
				ON  [PRIMARY]

        set ansi_padding off
    end
--ELSE
--    BEGIN 
--        TRUNCATE TABLE CHIS.tblChildImmunisation;
--    END;

print '1'

BEGIN TRY

	BEGIN TRANSACTION;

			--SELECT  * 
			--INTO dbo.tmpTemplateSubmission
			--FROM   [mrr].[ACCNC_TemplateSubmission]   TmpSubm
			--WHERE  TmpSubm.Obsolete = 0
			--and TmpSubm._expiredDate is NULL
			--AND TmpSubm.EventDate >= '1 Jan 2018'

			-- FS 12 Feb 2019 
			WITH ID_Max AS 
			(
				SELECT Id, MAX(_idx) _idx
				FROM [mrr].[ACCNC_TemplateSubmission] 
				GROUP BY Id
			)
			SELECT  TmpSubm.* 
			INTO dbo.tmpTemplateSubmission
			FROM   [mrr].[ACCNC_TemplateSubmission]   TmpSubm
			INNER JOIN ID_Max 
				ON ID_Max.Id = TmpSubm.Id
				AND ID_Max._idx = TmpSubm._idx
			WHERE  TmpSubm.Obsolete = 0
			and TmpSubm._expiredDate is NULL
			--AND TmpSubm.EventDate >= '1 Jan 2018'
			AND TmpSubm._createdDate > @updated_dttm
			--AND TmpSubm.PatientId IN ('E57A883B-72E6-468E-9561-43954B12B070')

			print '2'

			CREATE UNIQUE CLUSTERED INDEX idx_tmpTemplateSubmission_ID ON dbo.tmpTemplateSubmission (id)
			CREATE INDEX idx_tmpTemplateSubmission_TemplateId ON dbo.tmpTemplateSubmission (TemplateId)

			PRINT '3'

			SELECT DISTINCT  T.* 
			INTO dbo.tmpTemplate
			FROM [mrr].[ACCNC_Template] T -- [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template T
			 INNER JOIN dbo.tmpTemplateSubmission TS ON T.Id = TS.TemplateId -- EXISTS (SELECT 1 FROM dbo.tmpTemplateSubmission TS WHERE T.Id = TS.TemplateId)
			WHERE T.TemplateVersion is null

			print '4'
			
			CREATE UNIQUE CLUSTERED INDEX idx_tmpTemplate_ID ON dbo.tmpTemplate (id)

			PRINT '5'
			--;with tmpTemplateSubmission as 
			--(
			--SELECT  * 
			--FROM   [mrr].[ACCNC_TemplateSubmission] TmpSubm -- [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission   TmpSubm
			--WHERE  TmpSubm.Obsolete = 0
			--and TmpSubm._expiredDate is NULL
			--AND TmpSubm.EventDate >= '1 Jan 2018'
			----AND TmpSubm.PatientId IN ('E57A883B-72E6-468E-9561-43954B12B070')

			--)
			;WITH    MainImms AS 
			(SELECT DISTINCT TmpSubm.Id,PatImm.ImmunisationOutcomeId
					, PatImm.PatientId
					, CarenotesPatientId	= CHRec.CarenotesPatientId 
					, ImmunisationPartNo	= ImmPart.PartNumber
					, ImmunisationPartDesc	= ImmDef.LongName
					, TreatmentCentre		= CHCent.Name--CommHealth.Location_Name
					, GivenBy				= staff.Staff_Name
					, DateOccurred			= PatImm.DateOutcome
					, Outcome				= ImmOut.Description
					, BatchNumber			=  CASE WHEN TmpSubm.Text LIKE '%Batch number%' THEN CASE WHEN CHARINDEX('Batch number',TmpSubm.Text) > 0 THEN SUBSTRING(SUBSTRING(TmpSubm.Text,CHARINDEX('Batch number',TmpSubm.Text)+15,30),0,CHARINDEX(',',(SUBSTRING(TmpSubm.Text,CHARINDEX('Batch number',TmpSubm.Text)+15,30)))) END
													ELSE CASE WHEN TmpSubm.Text <> '[]' THEN REPLACE(REPLACE(LEFT(SUBSTRING(TmpSubm.Text,CHARINDEX(',{answer:',TmpSubm.Text,5)+1,LEN(TmpSubm.Text)),CHARINDEX(',',SUBSTRING(TmpSubm.Text,CHARINDEX(',{answer:',TmpSubm.Text,5)+1,LEN(TmpSubm.Text)))-1),'{answer:',''),'"','') END
												END 
					, [BatchExpiryDate]		= LEFT(REPLACE(TmpSubm.Date,'[{answer:',''),10) 
					--[Site] = CASE WHEN [text] LIKE '%Site%' AND text NOT LIKE '% Rio %'   THEN REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING(SUBSTRING(Text,CHARINDEX('{answer:"',Text)+9,70),0,CHARINDEX('"',(SUBSTRING(Text,CHARINDEX('{answer:"',Text)+9,70)))),'RiO body site set to ''Anterolateral thigh''',''),'RiO body site set to ''Upper arm''',''),'RiO body site set to ''Not applicable''',''),'RiO body site set to ''Right upper arm''','') END
					, PatImm.[CreatedDateTime]
				FROM [mrr].[CCH_PatientImmunisation] PatImm -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.PatientImmunisation  PatImm
					INNER JOIN [mrr].[CCH_ChildHealthRecord] CHRec -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ChildHealthRecord  CHRec
						ON CHRec.Id = PatImm.PatientId AND CHRec.ExpiredDateTime IS NULL
					INNER JOIN [mrr].[CCH_ImmunisationPart] ImmPart -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ImmunisationPart  ImmPart
						ON ImmPart.Id = PatImm.ImmunisationPartId
					INNER JOIN [mrr].[CCH_ImmunisationDefinition] ImmDef -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ImmunisationDefinition  ImmDef
						ON ImmDef.Id = ImmPart.ImmunisationDefinitionId
					LEFT JOIN [mrr].[CCH_ChildHealthCentre] CHCent -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ChildHealthCentre  CHCent 
						ON CHCent.Id = PatImm.CentreId AND CHCent.ExpiredDateTime IS NULL
					--LEFT JOIN [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].dbo.tblLocation CommHealth
					--	ON CommHealth.Location_ID = CHCent.CarenotesTeamId
					LEFT JOIN mrr.CNC_tblStaff staff -- [MHOXCARESQL01\MHOXCARESQL01].[CareNotesOxfordCCHealthLive].dbo.tblStaff staff
						ON staff.Staff_ID = PatImm.OutcomedByStaffId
					LEFT JOIN [mrr].[CCH_ImmunisationOutcome] ImmOut -- [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ImmunisationOutcome  ImmOut
						ON  ImmOut.Id = PatImm.ImmunisationOutcomeId	
						AND ImmOut.ExpiredDateTime IS NULL
					INNER JOIN   dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/  TmpSubm
						ON  TmpSubm.TemplateId = ImmPart.GivenConsultationTemplateId
						AND TmpSubm.PatientId = PatImm.PatientId
						and TmpSubm.Obsolete = 0
						and TmpSubm._expiredDate is NULL
					--INNER JOIN [MHOXCARESQL01\MHOXCARESQL01].[CNChildHealth-OxfordCCHealth-Live].dbo.ChildHealthRecord chr
					--	ON chr.Id = PatImm.PatientId AND chr.ExpiredDateTime is NULL
					WHERE PatImm.CreatedDateTime > @updated_dttm
					AND PatImm.ExpiredDateTime IS NULL
					AND PatImm.Removed = 0
					and TmpSubm.Obsolete = 0
					AND ImmOut.ImmunisationOutcomeType = 0 
					and TmpSubm._expiredDate is NULL
					--AND TmpSubm.text NOT LIKE '% Rio %'
					--and TmpSubm.Id = 'BEF4453F-EA10-46D8-B0B5-6868F05E441C'--'CEF7152E-159F-4D4B-D773-4C00719770F0'--'6B947AB0-9A25-42BC-E27C-F1CE454A5F48'--'6AFE2968-9E09-471B-CEBE-7499FB63AB8F'
					--and PatImm.PatientId = '66BD39D2-5DE4-40CD-9644-128B7D88300D'
					--and chr.CarenotesPatientId = 689833
			)

		INSERT INTO CHIS.tblChildImmunisation(Id, Patient_ID,CareNotesPatient_ID,ImmunisationPartNo,ImmunisationPartDescription,TreatmentCentre,GivenBy,DateOccurred,Outcome,BatchNumber,BatchExpiryDate,CreatedDateTime, LoadID)

			SELECT
				Id
				, PatientId
				, CarenotesPatientId
				, ImmunisationPartNo
				, ImmunisationPartDesc
				, TreatmentCentre
				, GivenBy
				, DateOccurred
				, Outcome
				, CASE WHEN LEN(BatchNumber) <= 10 and LEFT(LTRIM(RTRIM(BatchNumber)),1) != '[' THEN  BatchNumber END  BatchNumber
				, cast(NULLIF(REPLACE(BatchExpiryDate,'[]',''),'') AS DATE)   BatchExpiryDate
				, CreatedDateTime
				, @LoadId
			FROM MainImms

			print '6'

			-- delete from Tracker table 
			DECLARE @newRecords INT

			SET @newRecords = (SELECT COUNT(*) FROM CHIS.tblChildImmunisation WHERE LoadID = @LoadId)

			IF @newRecords > 0
			BEGIN 
				INSERT INTO [dbo].[tblPDS_TableTracker] values ('School_Immunisation', getdate() , (select max(CreatedDateTime) from chis.tblChildImmunisation), @LoadId)
			END 


			-- Populate Site, Route and WhereGiven Columns

			DECLARE @WhereGiven varchar(50) 
			DECLARE @Roue varchar(20)
			DECLARE @Site varchar(20)
			DECLARE @id VARCHAR(100)

 
			declare @Question1 varchar(40), @Answer1 varchar(40), @Question2 varchar(40), @Answer2 varchar(40), @Question3 varchar(40), @Answer3 varchar(40), @Count int,  @Len INT

			DECLARE MyCursor CURSOR FOR 

			SELECT DISTINCT Id FROM CHIS.tblChildImmunisation
			WHERE LoadID = @LoadId
			--WHERE Patient_ID = 'e57a883b-72e6-468e-9561-43954b12b070'

			OPEN MyCursor

			FETCH NEXT FROM MyCursor 

			INTO @id   


			while @@fetch_status = 0

			begin 
			--PRINT @id
			
					--PRINT '-A'

					set @Len = (select LEN(Combobox) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
					join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
					on T.Id = TS.TemplateId
					where TS.Id = @id
					and TS.Obsolete = 0
					and TS._expiredDate is NULL
					and T.TemplateVersion is null)

					--PRINT 'A'

					set @Count = (select (LEN(Combobox) - LEN(REPLACE(Combobox, 'id:', '')))/LEN('id:') from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
					join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
					on T.Id = TS.TemplateId
					where TS.Id = @id
					and TS.Obsolete = 0
					and TS._expiredDate is NULL
					and T.TemplateVersion is null)
					
					--PRINT 'B'

					set @Question1 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox)-2)),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
					join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
					on T.Id = TS.TemplateId
					where TS.Id = @id
					and TS.Obsolete = 0
					and TS._expiredDate is NULL
					and T.TemplateVersion is null)
					
					--PRINT 'C'

					if @Count = 6
					BEGIN
						set @Answer1 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,@Len/8))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'D'

						set @Question2 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,@Len/5))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'E'

						set @Answer2 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,(@Len/2)))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'F'

						set @Question3 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,3*(@Len/5)))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'G'

						set @Answer3 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,6*(@Len/8)))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						and TS.Obsolete = 0
						and TS._expiredDate is null
						and T.TemplateVersion is null)
					end
					else if @Count = 4
					BEGIN
						set @Answer1 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,@Len/5))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'H'

						set @Question2 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,@Len/2))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)

					--PRINT 'I'

						set @Answer2 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,3*(@Len/5)))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						
					--PRINT 'J'

						set @Question3 = 'None'
						set @Answer3 = 'None'
					end
					else if @Count = 2
					BEGIN
					
					--PRINT 'K'

						set @Answer1 = (select left(right(Combobox,(len(Combobox)-charindex('id:',Combobox,@Len/2))-2),36) from  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on T.Id = TS.TemplateId
						where TS.Id = @id
						AND TS.Obsolete = 0
						AND TS._expiredDate is NULL
						and T.TemplateVersion is null)
						set @Question2 = 'None'
						set @Answer2 = 'None'
						set @Question3 = 'None'
						set @Answer3 = 'None'
					end
					else
					BEGIN
                    
					--PRINT 'L'

						set @Question1 = 'None'
						set @Answer1 = 'None'
						set @Question2 = 'None'
						set @Answer2 = 'None'
						set @Question3 = 'None'
						set @Answer3 = 'None'
					end


		
					--PRINT 'M'

					update ci
					set ci.WhereGiven = case when @Answer1 = 'None' then '' else left(right(Definition,(len(Definition)-charindex(@Answer1,Definition)-45)),charindex('"',right(Definition,(len(Definition)-charindex(@Answer1,Definition)-45)))-1) end,
						ci.Route	=	case when @Answer2 = 'None' then '' else left(right(Definition,(len(Definition)-charindex(@Answer2,Definition)-45)),charindex('"',right(Definition,(len(Definition)-charindex(@Answer2,Definition)-45)))-1) end,
						ci.Site		= case when @Answer3 = 'None' then '' else left(right(Definition,(len(Definition)-charindex(@Answer3,Definition)-45)),charindex('"',right(Definition,(len(Definition)-charindex(@Answer3,Definition)-45)))-1) end 
					from CHIS.tblChildImmunisation ci
					inner join  dbo.tmpTemplateSubmission /* [MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.TemplateSubmission*/ TS
						on TS.Id = ci.Id
						and TS.Obsolete = 0
						and TS._expiredDate is null
					inner join  dbo.tmpTemplate /*[MHOXCARESQL01\MHOXCARESQL01].[Apex-Clinical-OxfordCCHealth-Live].dbo.Template*/ T
						on	 T.Id = TS.TemplateId
					where ci.Id = @id
					and T.TemplateVersion is null
					and Definition like '%'+@Question1+'%'


			fetch next from MyCursor 

			into   @id
			end 
			close MyCursor
			deallocate MyCursor

 

			-- SELECT DISTINCT   p.Patient_ID, p.NHS_Number, P.Surname, p.Forename, p.Date_Of_Birth,  prac.Practice_Name, /*sc.National_School_Code,*/TreatmentCentre School,ci.ImmunisationPartDescription Vaccine_Name, ci.ImmunisationPartNo,ci.DateOccurred AS Date_Given,
			-- ci.GivenBy, ci.Outcome, ci.WhereGiven, ci.BatchNumber, ci.BatchExpiryDate, ci.Route, ci.SITE
			--FROM CHIS.tblChildImmunisation ci
			--LEFT JOIN mrr.CNC_tblPatient p
			--ON ci.CareNotesPatient_ID = p.Patient_ID
			----LEFT JOIN mrr.CNS_tblSchool sc ON  LTRIM(RTRIM(REPLACE( REPLACE(REPLACE(REPLACE(REPLACE(ci.TreatmentCentre,'''',''),'OXF-',''),'BER-',''),'SHNN',''),'SHNS','')))  = REPLACE(sc.School_Name,'''','')
			--LEFT JOIN mrr.CNC_tblGPDetail gp ON p.Patient_ID = gp.Patient_ID AND gp.End_Date IS NULL 
			--LEFT JOIN  mrr.CNC_tblPractice prac ON prac.Practice_ID = gp.Practice_ID
			--WHERE p.Patient_Name NOT LIKE '%XX%Test%%'
			--AND ci.DateOccurred BETWEEN '1 Mar 2018' AND '30 Apr 2018'

			--select * from CHIS.tblChildImmunisation
			--where LoadID = @LoadId

	COMMIT TRANSACTION; 

END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		THROW;
END CATCH


			-- Delete temporary tables if exists 
			if object_id('dbo.tmpTemplateSubmission', 'U') is not null
			drop table dbo.tmpTemplateSubmission

			if object_id('dbo.tmpTemplate', 'U') is not null
			drop table dbo.tmpTemplate
GO
