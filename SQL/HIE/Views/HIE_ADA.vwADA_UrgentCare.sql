SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [HIE_ADA].[vwADA_UrgentCare]

AS 
SELECT  DISTINCT c.CaseRef
          , P.Forename + ' ' +P.Surname		AS Patient
          , c.CaseNo						AS 'Caseno'
          , P.Sex							AS Gender
          , P.DOB
          , FLOOR(DATEDIFF(DAY, P.DOB,  c.activeDate) / 365.25) AS Age
          , P.NationalCode					AS [NHSNumber]
          , ser.Name						AS [ServiceName]

          , CASE WHEN ISNULL(c.ContactPhone,'')	!= '' THEN c.ContactPhone 
				 WHEN ISNULL(P.MobilePhone,'')	!= '' THEN P.MobilePhone 
				 WHEN ISNULL(P.HomePhone,'')	!= '' THEN P.HomePhone 
				ELSE P.OtherPhone 
			END AS [CurrentPhone]
          
           , CASE WHEN ISNULL(cAdrs.Building,'')		!= '' THEN         cAdrs.Building			ELSE ''	END + 
             CASE WHEN ISNULL(cAdrs.BuildingExtension,'')!= ''THEN  ', ' + cAdrs.BuildingExtension	ELSE ''	END + 
             CASE WHEN ISNULL(cAdrs.Street,'')			!= '' THEN  ', ' + cAdrs.Street				ELSE ''	END +
             CASE WHEN ISNULL(cAdrs.Locality,'')		!= '' THEN  ', ' + cAdrs.Locality			ELSE ''	END +
             CASE WHEN ISNULL(cAdrs.Town,'')			!= '' THEN  ', ' + cAdrs.Town				ELSE ''	END +
             CASE WHEN ISNULL(cAdrs.County,'')			!= '' THEN  ', ' + cAdrs.County				ELSE ''	END +
             CASE WHEN ISNULL(cAdrs.Postcode,'')		!= '' THEN  ', ' + cAdrs.Postcode			ELSE ''	END AS [CurrentAddress]

           , CASE WHEN ISNULL(hAdrs.Building,'')		!= '' THEN         hAdrs.Building			ELSE ''	END + 
             CASE WHEN ISNULL(hAdrs.BuildingExtension,'')!= ''THEN  ', ' + hAdrs.BuildingExtension	ELSE ''	END + 
             CASE WHEN ISNULL(hAdrs.Street,'')			!= '' THEN  ', ' + hAdrs.Street				ELSE ''	END +
             CASE WHEN ISNULL(hAdrs.Locality,'')		!= '' THEN  ', ' + hAdrs.Locality			ELSE ''	END +
             CASE WHEN ISNULL(hAdrs.Town,'')			!= '' THEN  ', ' + hAdrs.Town				ELSE ''	END +
             CASE WHEN ISNULL(hAdrs.County,'')			!= '' THEN  ', ' + hAdrs.County				ELSE ''	END +
             CASE WHEN ISNULL(hAdrs.Postcode,'')		!= '' THEN  ', ' + hAdrs.Postcode			ELSE ''	END AS [HomeAddress]

              , P.HomePhone
              , cType.Name								AS [CaseType]
              , loc.Name								AS [Location]
              , CASE WHEN relToCaller.Name IS NULL THEN 'Patient' ELSE relToCaller.Name END AS [CallOrigin]
              , c.Summary								AS [ReportedCondition]
              , prov.Surname + ', ' +  prov.Forename	AS [AdastraConsultBy]
              , prov.ProviderType						AS [Role]
              , con.StartDate							AS [Consult Start]
              , dbo.fn_RSCaseEventBeforeCaseTypeName(c.caseRef, con.consultationRef, 'OLC')	AS 'StartingType' 
              , dbo.fn_RSCaseEventCaseTypeName(c.caseRef, con.consultationRef, 'OLC')		AS 'EndingType'
              , con.EndDate								AS [ConsultEnd]
              , con.History
              , con.Examination
              , con.Diagnosis
              , con.Treatment
              , dbo.fn_RSPrescriptionCombine(con.consultationRef)				AS 'Prescriptions'
              , dbo.fn_ClinicalCodesDiagnosisCombine(con.consultationRef)		AS 'ClinicalCodes'
              , dbo.fn_InformationalOutcomesCommentsCombine(c.caseRef)			AS 'InformationalOutcomes'

       FROM mrr.ADA_case c 
		LEFT JOIN mrr.ADA_Consultation con		ON con.caseRef = c.caseRef AND con.Obsolete = 0
		LEFT JOIN mrr.ADA_Patient		P		ON c.PatientRef = P.PatientRef
		LEFT JOIN mrr.ADA_Service		ser		ON ser.serviceref = c.serviceref
		LEFT JOIN mrr.ADA_Address		cAdrs	ON cAdrs.addressRef = c.CurrentLocationRef
		LEFT JOIN mrr.ADA_Address		hAdrs	ON hAdrs.addressRef = P.AddressRef
		LEFT JOIN mrr.ADA_Casetype		cType	ON cType.CaseTypeRef = c.CaseTypeRef
		LEFT JOIN mrr.ADA_Location		loc		ON loc.LocationRef = c.LocationRef
		LEFT JOIN mrr.ADA_RelationshipToCaller relToCaller	ON relToCaller.RelationshipRef = c.CallerRelationshipRef
		LEFT JOIN mrr.ADA_Provider		prov	ON prov.ProviderRef = con.ProviderRef
		LEFT JOIN mrr.ADA_CaseEvents cEvnts ON c.CaseRef = cEvnts.CaseRef
		LEFT JOIN mrr.ADA_adaEventTypes cEventTypes ON cEvnts.EventType = cEventTypes.EventType
		WHERE c.confidential = 0
		AND c.Testcall = 0 -- Exclude test calls
		AND P.Surname NOT LIKE '%XX%test%'
		AND P.Surname NOT LIKE '%Adastra%'
		AND P.Surname NOT LIKE '%Do%NOT%USE'
		AND P.Forename NOT LIKE '%XX%test%'
		AND P.Forename NOT LIKE '%Adastra%'
		AND P.Forename NOT LIKE '%Do%NOT%USE'
		AND cEventTypes.CompletionEvent = 1




GO
