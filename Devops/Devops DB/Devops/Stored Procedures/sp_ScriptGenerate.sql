



--DECLARE @ResultScript VARCHAR(MAX)
--EXEC Devops.sp_ScriptGenerate 'TEST','bimetadata',0,1
--EXEC Devops.sp_ScriptGenerate 'FTB','bimetadata',1,0
--SELECT @ResultScript


CREATE PROC [Devops].[sp_ScriptGenerate]( 
@EnvironmentName VARCHAR(50) ,
@DatabaseName VARCHAR(100),
@ISRestore BIT ,
@ISBackup  BIT
 )

AS
--Select *  from DEVOPS.RESTORELIST

BEGIN 




DECLARE @LoopCounter INT , @MaxCnt INT 
DECLARE @cmd NVARCHAR(500) 
DECLARE @backupPath NVARCHAR(500)
DECLARE @backupPathList NVARCHAR(500)
DECLARE @BackupFileName  VARCHAR(255)
DECLARE @NoofFiles INT
DECLARE @fileList TABLE (ID INT IDENTITY , backupFile NVARCHAR(255)) 
DECLARE @pBackupFile VARCHAR(1000)
DECLARE @pDSQL VARCHAR(MAX)
DECLARE @pDataFileLocation NVARCHAR(550);
DECLARE @pLogFileLocation NVARCHAR(550);
DECLARE @pLogicalDataFileName NVARCHAR(max);
DECLARE @pLogicalLogFileName NVARCHAR(max);
DECLARE @pDataFileName NVARCHAR(550);
DECLARE @pLogFileName NVARCHAR(550);
DECLARE @pDatabaseName NVARCHAR(550);
DECLARE @DiskName NVARCHAR(max);
DECLARE @LogFolder VARCHAR(1000);
DECLARE @DataFolder VARCHAR(1000);
DECLARE @BackupScript Varchar(MaX);
Declare @RecoveryMode VARCHAR(50)
DECLARE @RestoreSpace BIGINT;
DECLARE @CDC_Enabled VARCHAR(1000)
DECLARE @FileLists TABLE
    (
      [LogicalName] NVARCHAR(128) ,
      [PhysicalName] NVARCHAR(260) ,
      [Type] NCHAR(1) ,
      [FileGroupName] NVARCHAR(128) ,
      [Size] BIGINT ,
      [MaxSize] BIGINT ,
      [FileId] BIGINT ,
      [CreateLSN] DECIMAL(25, 0) ,
      [DropLSN] DECIMAL(25, 0) ,
      [UniqueId] UNIQUEIDENTIFIER ,
      [ReadOnlyLSN] DECIMAL(25, 0) ,
      [ReadWriteLSN] DECIMAL(25, 0) ,
      [BackupSizeInBytes] BIGINT ,
      [SourceBlockSize] INT ,
      [FileGroupId] INT ,
      [LogGroupGUID] UNIQUEIDENTIFIER ,
      [DifferentialBaseLSN] DECIMAL(25, 0) ,
      [DifferentialBaseGUID] UNIQUEIDENTIFIER ,
      [IsReadOnly] BIT ,
      [IsPresent] BIT ,
      [TDEThumbprint] VARBINARY(20)       
    );

DECLARE @ResultScriptLocal VARCHAR(MAX)

  --Get the Restore List

  IF (@ISRestore=1)
  BEGIN

	  --DROP TABLE #RestoreList

	    
		-- Get the restoreList based on EnvironmentName
		SELECT  IDENTITY(int, 1,1) AS Id ,  
		env.EnvironmentConfigID,  
		DatabaseName ,
		FileName   ,
		FilePath	,		
		IsRestore         ,
		IsBackup          ,
		NoofBackupFiles         ,
		OverrideExistingDB           ,
		SortOrder         ,
		AWOSetup		,
		LogFolder	,
		DataFolder ,
		isnull(RecoveryMode,'RECOVERY') as RecoveryMode 
		--case when isnull(RecoveryMode,0)=0 then 'RECOVERY' else 'NORECOVERY' end as RecoveryMode
		INTO  #RestoreList    FROM  Devops.BackupRestoreConfig Lst 
		INNER JOIN Devops.EnvironmentConfig env on Lst.EnvironmentConfigID= env.EnvironmentConfigID
		WHERE ISRESTORE =1  
		AND  env.EnvironmentName = @EnvironmentName
		AND  DatabaseName =@DatabaseName
		Order by SortOrder

		--SELECT *  from #RestoreList

		SELECT @LoopCounter = min(Id) , @MaxCnt = max(Id) 
		FROM #RestoreList  
  
				WHILE(@LoopCounter <= @MaxCnt)
					BEGIN
					   SELECT @backupPath = FilePath , @BackupFileName =FileName,@NoofFiles = NoofBackupFiles,@pDatabaseName=DatabaseName,@LogFolder=LogFolder,@DataFolder=DataFolder,@RecoveryMode=RecoveryMode
					   FROM #RestoreList WHERE Id = @LoopCounter
   
						SET @backupPathList = @backupPath + '\'+ @BackupFileName + '*.BAK'
   
   
					   -- 3 - get list of files 
						SET @cmd = 'DIR /b "' + @backupPathList + '"'

						INSERT INTO @fileList(backupFile) 
						EXEC master.sys.xp_cmdshell @cmd  

						SELECT   @pBackupFile = ' RESTORE FILELISTONLY FROM DISK =  ''' + @backupPath + '\'+ backupFile + '''' FROM  @fileList Where  backupFile is not null
						And ( backupFile Not Like '%Archive%' and backupFile Not Like '%diff%') ;

						INSERT  @FileLists
						EXEC(@pBackupFile);

						--SELECT * from @FileLists
						SELECT  @RestoreSpace = SUM(Size) / 1024 / 1024 FROM @FileLists


						SELECT   @pLogicalDataFileName = COALESCE (@pLogicalDataFileName ,' ',' ') +' MOVE '''+ LogicalName +''''+'    TO   '+''''+  @DataFolder+'\'+
						(Select Value from  DEVOPS.[fn_SplitString](PhysicalName,'\') where (Value like '%.mdf' or Value like '%.ndf')) +''',' + CHAR(13)     
						from @FileLists Where Type ='D' ;

						SELECT  @pLogicalLogFileName=  COALESCE (@pLogicalLogFileName ,' ',' ') +' MOVE '''+ LogicalName +''''+'    TO  '+''''+  @LogFolder+'\'+
						(Select Value from  DEVOPS.[fn_SplitString](PhysicalName,'\') where Value like '%.ldf') +''',' + CHAR(13)   
						from @FileLists Where Type ='L' ;

					
						SELECT @DISKNAME = COALESCE(@DISKNAME,'',',') +
						'DISK =' + ''''+ @BACKUPPATH + '\'+ BACKUPFILE + ''',' +  CHAR(13)
						FROM @FILELIST WHERE BACKUPFILE IS NOT NULL AND (BACKUPFILE NOT LIKE '%ARCHIVE%' and BACKUPFILE NOT LIKE '%DIFF%')
						ORDER BY BACKUPFILE
	
						Set @CDC_Enabled  = IIF (@PDATABASENAME ='RI','keep_cdc ,',' ' )

						 SELECT   'RESTORE DATABASE ' + @PDATABASENAME + ' FROM ' +  LEFT(@DISKNAME,LEN(@DISKNAME)-2)
							   +' WITH ' +@CDC_Enabled+  @PLOGICALDATAFILENAME +  @PLOGICALLOGFILENAME 
							   + '  NOUNLOAD,  REPLACE,  STATS = 5, '+@RecoveryMode  as ResultScript,@RestoreSpace AS RestoreSpace
						-- CLEAR
					 SET @backupPath =''
					 SET @BackupFileName =''
					 SET @backupPathList =''
					 SET @pBackupFile=''
					 SET @pLogicalDataFileName=''
					 SET @pLogicalLogFileName =''
					 SET @DiskName =''

					 Delete from @fileList
					 delete from @FileLists
						
						SET @LoopCounter  = @LoopCounter  + 1        
				END
					
  END
  IF(@ISBackup =1)
  BEGIN




  
        SET @RestoreSpace  =0
		DECLARE @strBackupDisk VARCHAR(MAX)
		DECLARE @intDiskCntMin INT
		DECLARE @intDiskCntMax INT

		

		--DROP TABLE #BackupList
  
			-- Get the restoreList based on EnvironmentName
		SELECT  IDENTITY(int, 1,1) AS Id ,  
		env.EnvironmentConfigID,  
		DatabaseName ,
		FileName   ,
		FilePath	,		
		IsRestore         ,
		IsBackup          ,
		NoofBackupFiles         ,
		OverrideExistingDB           ,
		SortOrder         ,
		AWOSetup		,
		LogFolder	,
		DataFolder  
		INTO  #BackupList    FROM  Devops.BackupRestoreConfig Lst 
		INNER JOIN Devops.EnvironmentConfig env on Lst.EnvironmentConfigID= env.EnvironmentConfigID
		WHERE IsBackup =1  
		AND  env.EnvironmentName = @EnvironmentName
		AND  DatabaseName =@DatabaseName
		Order by SortOrder

		SELECT @LoopCounter = min(Id) , @MaxCnt = max(Id) 
		FROM #BackupList  
  
		WHILE(@LoopCounter <= @MaxCnt)
		BEGIN
			
			   SELECT @backupPath = FilePath , @BackupFileName =FileName,@NoofFiles = NoofBackupFiles,@pDatabaseName=DatabaseName,@LogFolder=LogFolder,@DataFolder=DataFolder
				FROM #BackupList WHERE Id = @LoopCounter
				SET @strBackupDisk =''
				SET @intDiskCntMin =1
				SET @intDiskCntMax = @NoofFiles
				While (@intDiskCntMin <= @intDiskCntMax)
				BEGIN
				   IF (@intDiskCntMax <=1)
						BEGIN
							SET @strBackupDisk = @strBackupDisk + '  DISK = N'+''''+ @backupPath + '\'+@BackupFileName+ '.BAK'+''',' +CHAR(13) 							
						END
					 ELSE
						BEGIN
							SET @strBackupDisk = @strBackupDisk + '  DISK = N'+''''+ @backupPath + '\'+@BackupFileName+ '_'+ LTRIM(RTRIM( CAST ( @intDiskCntMin AS char(2)))) + '.BAK'+''',' +CHAR(13) 							
						END
						SET @intDiskCntMin = @intDiskCntMin +1
				END

			
				SELECT   'BACKUP DATABASE  ' + @pDatabaseName + ' TO ' +  LEFT(@strBackupDisk,LEN(@strBackupDisk)-2) + ' WITH NOFORMAT, INIT, SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10' as ResultScript,@RestoreSpace AS RestoreSpace

   	

				-- CLEAR
					 SET @backupPath =''
					 SET @BackupFileName =''
					 SET @backupPathList =''
					 SET @pBackupFile=''
					 SET @pLogicalDataFileName=''
					 SET @pLogicalLogFileName =''
					 SET @DiskName =''

				
						
					SET @LoopCounter  = @LoopCounter  + 1    
			
		END



		
  END
 

END


--DECLARE @ISRestore INT =0
--DECLARE @ISBackUp INT  =1

--IF (@ISBackUp=1)
--BEGIN
--	SELECT lst.RestoreListID , lst.DatabaseName

--	  FROM  DEVOPS.RESTORELIST Lst 
--	  INNER JOIN Devops.Environments env on Lst.EnvironmentID= env.EnvironmentID
--	  WHERE 
--	  IsBackup =1    AND 
--	 env.EnvironmentName = 'Regression'
--	  Order by SortOrder
--END
--ELSE IF (@ISRestore=1)
--BEGIN
--	SELECT lst.RestoreListID , lst.DatabaseName

--	  FROM  DEVOPS.RESTORELIST Lst 
--	  INNER JOIN Devops.Environments env on Lst.EnvironmentID= env.EnvironmentID
--	  WHERE 
--	  IsRestore =1    AND 
--	 env.EnvironmentName = 'Regression'
--	  Order by SortOrder
--END

--SELECT lst.RestoreListID , lst.DatabaseName

--	  FROM  DEVOPS.RESTORELIST Lst 
--	  INNER JOIN Devops.Environments env on Lst.EnvironmentID= env.EnvironmentID
--	  WHERE 
--	  ( IsBackup =1 or IsRestore =0)   AND 
--	 env.EnvironmentName = 'Regression' 
--	  Order by SortOrder

--	  select *  from  DEVOPS.RESTORELIST Lst 

GO


