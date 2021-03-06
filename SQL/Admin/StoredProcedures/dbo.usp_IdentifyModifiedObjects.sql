SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE PROCEDURE [dbo].[usp_IdentifyModifiedObjects]

AS
BEGIN

DECLARE @sql VARCHAR(1000)
DECLARE @DBName varchar(100)
DECLARE @IdentityColumn varchar(100)

-- temporary table to capture all current modified dates for all objects

IF OBJECT_ID('dbo.tmpObjctModifiedDttm','U') IS NOT NULL
DROP TABLE dbo.tmpObjctModifiedDttm

CREATE TABLE dbo.tmpObjctModifiedDttm(
[Database] VARCHAR(50) NOT NULL,
[Schema] VARCHAR(50) NOT NULL,
ObjectName VARCHAR(150) NOT NULL,
[ObjectID] VARCHAR(150) NOT NULL,
ObjectType VARCHAR(150) NOT NULL,
CreateDttm DATETIME,
ModifiedDttm DATETIME
)

-- table to hold the object needs to be pushed to GitHub 

IF OBJECT_ID('dbo.tblObjects_ToPushToGitHub','U') IS NULL
BEGIN 
	CREATE TABLE dbo.tblObjects_ToPushToGitHub(
	[Database] VARCHAR(50) NOT NULL,
	[Schema] VARCHAR(50) NOT NULL,
	ObjectName VARCHAR(150) NOT NULL,
	[ObjectID] VARCHAR(150) NOT NULL,
	ObjectType VARCHAR(150) NOT NULL,
	CreateDttm DATETIME,
	ModifiedDttm DATETIME
	)
END
ELSE
BEGIN
	TRUNCATE TABLE dbo.tblObjects_ToPushToGitHub
END 


--====================================================
-- Identify current modified DateTime for all objects
--====================================================
DECLARE DatabaseName CURSOR FOR
  
SELECT [name] FROM sys.databases
WHERE [name] NOT IN ('master','tempdb','model','msdb','SSISDB','BoardDashboard')
             
OPEN DatabaseName
 
FETCH NEXT FROM DatabaseName
INTO @DBName
 
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @sql = 'insert into dbo.tmpObjctModifiedDttm 
				SELECT '''+@DBName + ''',s.name AS [Schema], o.[name], o.[object_id], o.[type_desc], o.create_date, o.modify_date FROM ['+@DBName+'].sys.objects o LEFT JOIN ['+@DBName+'].sys.schemas s ON o.schema_id = s.schema_id WHERE type_desc  IN (''SQL_SCALAR_FUNCTION'',''SQL_STORED_PROCEDURE'',''USER_TABLE'',''VIEW'') AND LEFTo.[name],3) NOT IN (''tmp'');'
	PRINT @sql 
	EXEC (@sql)
 
FETCH NEXT FROM DatabaseName
INTO  @DBName
END
CLOSE DatabaseName
DEALLOCATE DatabaseName

-- Add JOBS
insert into dbo.tmpObjctModifiedDttm 
SELECT 'Jobs' AS [Datebase]
	, 'msdb' AS [Schema]  
	, [name] ObjectName 
	, job_id AS [ObjectID] 
	, 'Jobs' AS ObjectType 
	, date_created AS CreateDttm 
	, date_modified AS ModifiedDttm 
FROM msdb.dbo.sysjobs


-- Identify MODIFIED Objects since last PUSH to be pushed to GitHub

INSERT INTO dbo.tblObjects_ToPushToGitHub
SELECT new.* FROM dbo.tmpObjctModifiedDttm new
LEFT JOIN [dbo].[tblObjects_LatestModificationDates] old
ON new.ObjectID = old.ObjectID
AND new.[Database] = old.[Database]
AND new.[Schema] = old.[Schema]
WHERE  new.ModifiedDttm > old.ModifiedDttm 

-- identify NEW Object created since last PUSH 
INSERT INTO dbo.tblObjects_ToPushToGitHub
SELECT new.* FROM dbo.tmpObjctModifiedDttm new
WHERE NOT EXISTS (	SELECT 1 FROM [dbo].[tblObjects_LatestModificationDates] old
					WHERE new.ObjectID = old.ObjectID
					AND new.[Database] = old.[Database]
					AND new.[Schema] = old.[Schema]
				)

-- delete objects that has a new modified dates 
DELETE FROM [dbo].[tblObjects_LatestModificationDates] 
FROM [dbo].[tblObjects_LatestModificationDates] old
WHERE EXISTS (	SELECT 1 FROM dbo.tblObjects_ToPushToGitHub new
					WHERE new.ObjectID = old.ObjectID
					AND new.[Database] = old.[Database]
					AND new.[Schema] = old.[Schema]
				)

-- insert new objects with new modification Dttm
INSERT INTO [dbo].[tblObjects_LatestModificationDates]
SELECT * FROM dbo.tblObjects_ToPushToGitHub


IF OBJECT_ID('dbo.tmpObjctModifiedDttm','U') IS NOT NULL
DROP TABLE dbo.tmpObjctModifiedDttm


END 
GO
