SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON




CREATE VIEW  [hl7].[vw_CNS_Attachment]
AS

SELECT att.Attachment_ID
	, af.Attachment_File_ID
	, CONVERT(VARCHAR(23)
             , (
                   SELECT MAX(Updated_Dttm)
                   FROM
                   (
                       VALUES
                           (att.Updated_Dttm)
                         , (af.Updated_Dttm)
                   ) AS alldates (Updated_Dttm)
               )
             , 21
              )                             AS UpdatedDate
	, 'CNS'									AS sourceSystem 
	, att.Doc_Date							AS DocumentDate
	, 'CarenotesMH'							AS MsgSender
	, 'Docman'								AS MsgRecipient
	, 'Nhs'									AS IdType
	, inscope.NHS_Number					AS IdValue
	, 'CU'									AS PersonNameType
	, inscope.Surname 
	, inscope.Forename 
	, inscope.Date_Of_Birth 
	, inscope.Gender_ID 
	, inscope.GP_Code						AS RecpHcpCode
	, inscope.GP_Name						AS RecpHcpDescription
	, inscope.Practice_Code					AS RecpPracticeCode
	, inscope.Practice_Name					AS RecpPracticeName
	, s_auth.Consultant_GMC_Code			AS SendHCPCode
	, s_auth.Staff_Name						AS SendHCPDesc
	, l.Location_Name						AS SendDepartment
	, 'RNU'									AS OrgCode
	, 'Oxford Health'						AS OrgName
	, af.Attachment_ID						AS DocumentID
	, gdcv.General_Document_Category_Desc	AS ReportType
	, e.Start_Date							AS EventDate
	, e.Discharge_Date						AS EventDateEnd
	, att.Doc_Date							AS DocCreationDate
	, af.Attachment_File_Name
	, att.Doc_Title
	, af.Attachment_File_Body
	, 'MH'+'_'+CAST(af.Attachment_ID AS VARCHAR)+'_'+CAST(af.Attachment_File_ID AS VARCHAR)+'_'+inscope.Practice_Code AS IntegratedDocumentID
	,  REPLACE(SUBSTRING(RIGHT(Attachment_File_Name,5),CHARINDEX('.',RIGHT(Attachment_File_Name,5)),5),'.','') AS FileExtension

FROM [dbo].[CNS_tblInscopeAttachments]					inscope
	INNER JOIN mrr.CNS_tblAttachment								att
		ON att.Attachment_ID = inscope.Attachment_ID
		AND inscope.SourceSystem = 'CNS'
	INNER JOIN [MHOXCARESQL01\MHOXCARESQL01].CareNotesOxfordLive.dbo.tblAttachmentFile af 
		ON af.Attachment_File_ID = inscope.Attachment_File_ID
	LEFT OUTER JOIN mrr.CNS_tblGeneralDocumentCategoryValues		 gdcv
		 ON gdcv.General_Document_Category_ID = att.General_Document_Category_ID
	LEFT OUTER JOIN mrr.CNS_tblStaff								s_auth 
		ON s_auth.Staff_ID = att.Doc_Author_Staff_ID
	--LEFT OUTER JOIN mrr.CNS_tblPatient								p 
	--	ON p.Patient_ID = att.Patient_ID
	--LEFT OUTER JOIN mrr.CNS_tblGPDetail								gpd
	--	ON gpd.Patient_ID = p.Patient_ID 
	--	AND gpd.End_Date IS NULL
		--AND att.Doc_Date BETWEEN gpd.Start_Date 
		--AND COALESCE(gpd.End_Date, '20991231')
	--LEFT OUTER JOIN mrr.CNS_tblGP									gp 
	--	ON gp.GP_ID = gpd.GP_ID
	--LEFT OUTER JOIN mrr.CNS_tblGPPractice							gpp 
	--	ON gpp.GP_ID = gp.GP_ID
	--LEFT OUTER JOIN mrr.CNS_tblPractice								prac 
	--	ON prac.Practice_ID = gpd.Practice_ID
	LEFT OUTER JOIN mrr.CNS_tblLocation								l 
		ON s_auth.Staff_Loc_ID = l.Location_ID
	LEFT OUTER JOIN mrr.CNS_tblCNDocument							cn 
		ON att.Object_Type_ID = cn.Object_Type_ID 
		AND att.Attachment_ID = cn.CN_Object_ID 
		AND cn.Patient_ID = inscope.Patient_ID
	LEFT OUTER JOIN mrr.CNS_tblEpisode								e 
		ON cn.Episode_ID = e.Episode_ID 
		AND e.Patient_ID = inscope.Patient_ID

WHERE (af.Attachment_File_Name LIKE '%.doc'
		OR af.Attachment_File_Name LIKE '%.docx'
		OR af.Attachment_File_Name LIKE '%.pdf')


GO
