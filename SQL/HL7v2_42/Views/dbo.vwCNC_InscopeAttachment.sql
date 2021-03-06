SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON


CREATE VIEW  [dbo].[vwCNC_InscopeAttachment]
AS 

WITH MaxDttm AS
(SELECT ISNULL([MaxUpdateTime],'1 Jan 1900') AS [MaxUpdateTime] FROM [dbo].[tblHL7_TableTracker] WHERE SourceSystem = 'CNC' AND TABLE_NAME = 'CNC_tblAttachment')

SELECT  att.Attachment_ID, af.Attachment_File_ID , 'CNC' AS SourceSystem, p.Patient_ID, prac.Practice_Code

FROM mrr.CNC_tblAttachment		att
	LEFT OUTER JOIN [MHOXCARESQL01\MHOXCARESQL01].CareNotesOxfordLive.dbo.tblAttachmentFile af 
		ON af.Attachment_ID = att.Attachment_ID
INNER JOIN MaxDttm 
	ON CONVERT(VARCHAR(23)
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
              ) > MaxDttm.[MaxUpdateTime] 
LEFT OUTER JOIN mrr.CNC_tblPatient								p 
		ON p.Patient_ID = att.Patient_ID
LEFT OUTER JOIN mrr.CNC_tblGPDetail								gpd
		ON gpd.Patient_ID = p.Patient_ID 
		AND att.Doc_Date BETWEEN gpd.Start_Date 
		AND COALESCE(gpd.End_Date, '20991231')
	LEFT OUTER JOIN mrr.CNC_tblPractice							prac 
		ON prac.Practice_ID = gpd.Practice_ID
LEFT JOIN mrr.CNC_tblAttachmentStatusValues			asv
	ON asv.Attachment_Status_ID = att.Attachment_Status_ID
WHERE asv.Attachment_Status_Desc LIKE '%Approved%'
AND prac.Practice_Code IS NOT NULL 
AND prac.Practice_Code NOT LIKE 'V9%'
AND p.Patient_Name LIKE '%XX%TEST%' 

GO
