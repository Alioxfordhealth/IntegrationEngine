SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW [mrr].[ADA_Patient] AS SELECT [PatientRef], [AddressRef], [Forename], [Surname], [SurnamePrefix], [MaidenPrefix], [Maiden], [Initials], [DOB], [HomePhone], [MobilePhone], [OtherPhone], [Sex], [AgeOnly], [NationalCode], [Obsolete], [LastEditByUserRef], [EditDate], [EthnicityRef], [HumanLanguageRef], [LocalLanguageSpoken], [NationalityRef], [NationalCodeSource], [EmailAddress], [OtherPhoneExtn], [ExcludeFromPSQ], [LastCaseDate], [IsTwin], [DemographicsSensitive], [NationalCodeSourceDatabase], [NationalCodeEditDate], [NationalCodeEditByUserRef], [LocalID], [NationalCodeExtraInfo], [HomePhonePrefix], [AllergyStatusCode], [ConditionStatusCode], [MedicationStatusCode], [LatestModificationDate] FROM [Mirror].[mrr_tbl].[ADA_Patient];

GO
