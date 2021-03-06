SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

CREATE VIEW  [hl7].[vw_CNC_Attachment]
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
              )                                            AS UpdatedDate
	, 'MH'									AS sourceSystem 
	, att.Doc_Date							AS DocumentDate
	, 'CarenotesMH'							AS MsgSender
	, 'Docman'								AS MsgRecipient
	, 'Nhs'									AS IdType
	, p.NHS_Number							AS IdValue
	, 'CU'									AS PersonNameType
	, p.Surname 
	, p.Forename 
	, p.Date_Of_Birth 
	, p.Gender_ID 
	, gp.GP_Code							AS RecpHcpCode
	, IIF(ISNULL(gp.First_Name, '')='', gp.Last_Name, gp.First_Name + ' ' + gp.Last_Name) AS RecpHcpDescription
	, prac.Practice_Code					AS RecpPracticeCode
	, prac.Practice_Name					AS RecpPracticeName
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
	, 'MH'+'_'+CAST(af.Attachment_ID AS VARCHAR)+'_'+prac.Practice_Code AS IntegratedDocumentID
	,  REPLACE(SUBSTRING(RIGHT(Attachment_File_Name,5),CHARINDEX('.',RIGHT(Attachment_File_Name,5)),5),'.','') AS FileExtension

FROM mrr.CNC_tblAttachment											att
	INNER JOIN dbo.vwCNC_InscopeAttachment							inscope
		ON att.Attachment_ID = inscope.Attachment_ID
		AND inscope. SourceSystem = 'CNC'
	LEFT OUTER JOIN [MHOXCARESQL01\MHOXCARESQL01].CareNotesOxfordLive.dbo.tblAttachmentFile af 
		ON af.Attachment_ID = att.Attachment_ID
	LEFT OUTER JOIN mrr.CNC_tblGeneralDocumentCategoryValues		 gdcv
		 ON gdcv.General_Document_Category_ID = att.General_Document_Category_ID
	LEFT OUTER JOIN mrr.CNC_tblStaff								s_auth 
		ON s_auth.Staff_ID = att.Doc_Author_Staff_ID
	LEFT OUTER JOIN mrr.CNC_tblPatient								p 
		ON p.Patient_ID = att.Patient_ID
	LEFT OUTER JOIN mrr.CNC_tblGPDetail								gpd
		ON gpd.Patient_ID = p.Patient_ID 
		AND att.Doc_Date BETWEEN gpd.Start_Date 
		AND COALESCE(gpd.End_Date, '20991231')
	LEFT OUTER JOIN mrr.CNC_tblGP									gp 
		ON gp.GP_ID = gpd.GP_ID
	--LEFT OUTER JOIN mrr.CNC_tblGPPractice							gpp 
	--	ON gpp.GP_ID = gp.GP_ID
	LEFT OUTER JOIN mrr.CNC_tblPractice								prac 
		ON prac.Practice_ID = gpd.Practice_ID
	LEFT OUTER JOIN mrr.CNC_tblLocation								l 
		ON s_auth.Staff_Loc_ID = l.Location_ID
	LEFT OUTER JOIN mrr.CNC_tblCNDocument							cn 
		ON att.Object_Type_ID = cn.Object_Type_ID 
		AND att.Attachment_ID = cn.CN_Object_ID 
		AND cn.Patient_ID = p.Patient_ID
	LEFT OUTER JOIN mrr.CNC_tblEpisode								e 
		ON cn.Episode_ID = e.Episode_ID 
		AND e.Patient_ID = p.Patient_ID

WHERE (af.Attachment_File_Name LIKE '%.doc'
		OR af.Attachment_File_Name LIKE '%.docx'
		OR af.Attachment_File_Name LIKE '%.pdf')
	--AND af.Attachment_ID = 5752321

GO
