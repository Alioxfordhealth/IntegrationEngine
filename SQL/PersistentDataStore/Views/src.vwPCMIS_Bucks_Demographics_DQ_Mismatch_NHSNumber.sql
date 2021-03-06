SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW [src].[vwPCMIS_Bucks_Demographics_DQ_Mismatch_NHSNumber]
AS
 WITH main AS 
( 
	SELECT (SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(FirstName),' ',''),'-',''),'''',''))
						+ SOUNDEX(REPLACE(REPLACE(REPLACE(UPPER(LastName),' ',''),'-',''),'''',''))
						+ CONVERT(VARCHAR(10),ISNULL(DOB,''),112 )
						--+ REPLACE(REPLACE(REPLACE(UPPER(Address1),' ',''),'-',''),'''','') 
						+ REPLACE(UPPER(PostCode),' ','')
			) ID
		, *
	FROM [mrr].[PCMSBCKS_PatientDetails]
	--WHERE NHSNumber IN ('6205463105','4340690538')
)
SELECT 	m1.	ID
	, m1.PatientID
	, m1.Title
	, m1.FirstName
	, m1.MiddleName
	, m1.LastName
	, m1.DOB
	, m1.NHSNumber
	, m1.Gender
	, m1.Address1
	, m1.Address2
	, m1.Address3
	, m1.TownCity
	, m1.County
	, m1.PostCode
	, m1.TelHome
	, m1.TelMobile
	, m1.TelWork
	, m1.Ethnicity
	, m1.Nationality
	, m1.FamilyName
	, m1.PreviousName
	, m1.PreviousAddress1
	, m1.PreviousAddress2
	, m1.PreviousAddress3
	, m1.PreviousTownCity
	, m1.PreviousCounty
	, m1.PreviousPostCode
	, m1.AccomodationType
	, m1.SingleOccupancy
	, m1.MaritalStatus
	, m1.MainLanguage
	, m1.Sexuality
	, m1.Mobility
	, m1.DateOfDeath
	, m1.Email
	, m1.Alerts
	, m1.Disability
	, m1.Reminders
	, m1.Religion
	, m1.DependantChildren
	, m1.ChildDetails1
	, m1.ChildDetails2
	, m1.ChildDetails3
	, m1.ChildDetails4
	, m1.ChildDetails5
	, m1.ChildDetails6
	, m1.ChildDetails7
	, m1.ChildDetails8
	, m1.ChildDetails9
	, m1.ChildDetails10
	, m1.CarerDetails1
	, m1.CarerDetails2
	, m1.CarerDetails3
	, m1.VoicemailHome
	, m1.VoicemailMobile
	, m1.VoicemailWork
	, m1.NHSNumberVerified
	, m1.TelGP
	, m1.PriorIllness
	, m1.PriorTreatment
	, m1.Medicated
	, m1.DateOfMedication
	, m1.EndOfMedication
	, m1.NotifyBySMS
	, m1.ArmedForcesCode
	, m1.LastNameAlias
	, m1.FirstNameAlias
	, m1.DisplayName
	, m1.Interpreter
	, m1.InterpreterLanguage
	, m1.PrimaryMUS
	, m1.IntIAPTConsent

FROM main m1
LEFT JOIN main m2 ON m1.ID = m2.ID
WHERE m1.NHSNumber <> m2.NHSNumber
AND m1.NHSNumber NOT IN ('0000000000','1111111111','2222222222','3333333333','4444444444','5555555555','6666666666','7777777777','8888888888','9999999999')

GO
