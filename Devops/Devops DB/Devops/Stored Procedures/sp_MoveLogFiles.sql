


CREATE PROC Devops.MOVELOGFILE( @DBName varchar(50),@NewLoc varchar(1000),@NewLocLogs varchar(1000))

AS
BEGIN


SET NOCOUNT ON

--VAR
DECLARE @cmd nvarchar(4000)
--Declare @DBName varchar(50)
Declare @OldLoc varchar(1000)
Declare @LogName varchar(1000)
Declare @OldLoc_log varchar(1000)
Declare @LogName_log varchar(1000)
--Declare @NewLoc varchar(1000)
--Declare @NewLocLogs varchar(1000)
declare @FileName varchar(255)
declare @FileName_log varchar(255)
declare @Error_flag int    
declare @tail int 


       --Set the following vlaues DATA QUALITY_20140701
       --set @DBName = 'Talbot_Warehouse'
       --set @NewLoc = 'F:\Microsoft SQL Server\Data\'
       --set @NewLocLogs = 'G:\Microsoft SQL Server\Logs\'

--
--     set @DBName = 'ith_test'
--     set @NewLoc = 'h:\MSSQLSERVER\MSSQL$DAWH\Data\'

--********************** Start of Script **************************

       
--create a temp table to hold list of DBs
       create TABLE #DBInfo (
              ServerName VARCHAR(100),  
              DatabaseName VARCHAR(100),  
              FileSizeMB INT,  
              LogicalFileName sysname,  
              PhysicalFileName NVARCHAR(520),  
              Status sysname,  
              Updateability sysname,  
              RecoveryMode sysname,  
              FreeSpaceMB INT,  
              FreeSpacePct VARCHAR(7),  
              FreeSpacePages INT,  
              PollDate datetime)  


-- Query to find the required info from each DB on the server.
       select @cmd = 'Use [' + '?' + '] 
                                  SELECT  @@servername as ServerName,  
                                  ' + '''' + '?' + '''' + ' AS DatabaseName,  
                                  CAST(sysfiles.size/128.0 AS int) AS FileSize,  
                                  sysfiles.name AS LogicalFileName, sysfiles.filename AS PhysicalFileName,  
                                  CONVERT(sysname,DatabasePropertyEx(''?'',''Status'')) AS Status,  
                                  CONVERT(sysname,DatabasePropertyEx(''?'',''Updateability'')) AS Updateability,  
                                  CONVERT(sysname,DatabasePropertyEx(''?'',''Recovery'')) AS RecoveryMode,  
                                  CAST(sysfiles.size/128.0 - CAST(FILEPROPERTY(sysfiles.name, ' + '''' +  
                                  'SpaceUsed' + '''' + ' ) AS int)/128.0 AS int) AS FreeSpaceMB,  
                                  CAST(100 * (CAST (((sysfiles.size/128.0 -CAST(FILEPROPERTY(sysfiles.name,  
                                  ' + '''' + 'SpaceUsed' + '''' + ' ) AS int)/128.0)/(sysfiles.size/128.0))  
                                  AS decimal(4,2))) AS varchar(8)) + ' + '''' + '%' + '''' + ' AS FreeSpacePct,  
                                  GETDATE() as PollDate FROM dbo.sysfiles'  
       INSERT INTO #DBInfo (
                           ServerName,  
                           DatabaseName,  
                           FileSizeMB,  
                           LogicalFileName,  
                           PhysicalFileName,  
                           Status,  
                           Updateability,  
                           RecoveryMode,  
                           FreeSpaceMB,  
                           FreeSpacePct,  
                           PollDate)  
       EXEC sp_MSForEachDB @cmd  -- Use the sp_MSForEachDB to run on each DB on the SERVER
       
       set @Error_flag = 0
       set @OldLoc = (select PhysicalFileName  from #DBInfo where DatabaseName = @DBName and PhysicalFileName like ('%.mdf'))
       set @LogName = (select LogicalFileName  from #DBInfo where DatabaseName = @DBName and PhysicalFileName like ('%.mdf')) 

       set @OldLoc_log = (select PhysicalFileName  from #DBInfo where DatabaseName = @DBName and PhysicalFileName like ('%.ldf'))
       set @LogName_log = (select LogicalFileName  from #DBInfo where DatabaseName = @DBName and PhysicalFileName like ('%.ldf'))




       set @tail = (
              select charindex('\',LTRIM(reverse(@OldLoc)) )
       )
       
       set @FileName = (
       select substring(reverse(@OldLoc),1,@tail-1))
       set @Filename = reverse(@FileName)

       set @NewLoc = @NewLoc + @FileName
       print 'File to Be Move: '+@OldLoc
       print 'New File Location is :'+ @NewLoc
       print 'Logical Name :'+@LogName
       print ''





       set @tail = (
              select charindex('\',LTRIM(reverse(@OldLoc_log)) )
       )
       
       set @FileName_log = (
       select substring(reverse(@OldLoc_log),1,@tail-1))
       set @FileName_log = reverse(@FileName_log)

       set @NewLocLogs  = @NewLocLogs + @FileName_log
       print 'File to Be Move: '+@OldLoc_log
       print 'New File Location is :'+ @NewLocLogs
       print 'Logical Name :'+@LogName_log
       print ''




-- Step1: put the database offline
    set @cmd = 'ALTER DATABASE ['+ @DBName + '] SET OFFLINE;'
       exec (@cmd)--Set the DB to be offline
       print @CMD
       print ''

--Copy file
       select @cmd = 'copy "'+ @OldLoc +'"  "'+ @NewLoc +'"'
       EXEC master.dbo.xp_cmdshell @cmd
       print @CMD
       print ''



       select @cmd = 'copy "'+ @OldLoc_log +'"  "'+ @NewLocLogs +'"'
       EXEC master.dbo.xp_cmdshell @cmd
       print @CMD
       print ''

--Change the DB to point to the new file
       set @cmd = 'ALTER DATABASE ['+@DBname+'] MODIFY FILE (NAME = ['+@LogName+'], FILENAME = '''+@NewLoc+''');' 
       print @CMD
       print ''
       exec (@cmd)

       set @cmd = 'ALTER DATABASE ['+@DBname+'] MODIFY FILE (NAME = ['+@LogName_log+'], FILENAME = '''+@NewLocLogs+''');' 
       print @CMD
       print ''
       exec (@cmd)

--Rename the DB file 
       select @cmd = 'rename "'+@oldLoc+'" "'+@FileName+'_Del2"'
       EXEC master.dbo.xp_cmdshell @cmd     
       print @CMD
       print ''


       select @cmd = 'rename "'+@OldLoc_log+'" "'+@FileName_log+'_Del2"'
       EXEC master.dbo.xp_cmdshell @cmd     
       print @CMD
       print ''

--Bring the database online
    set @cmd = 'ALTER DATABASE ['+@DBName+'] SET ONLINE'
       exec (@cmd)
       print @CMD
       print ''





--clean up temptable
drop table #DBInfo

END