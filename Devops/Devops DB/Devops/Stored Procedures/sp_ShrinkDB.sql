
CREATE PROC Devops.ShrinkDB 

AS
BEGIN 

DBCC UPDATEUSAGE(0)
 
IF OBJECT_ID('tempdb..#tmp') IS NOT NULL
    DROP TABLE #tmp
CREATE TABLE #tmp
(
    [db] NVARCHAR(128),
    [name] NVARCHAR(128),
    [size] decimal (12,2),
	[used] decimal (12,2),
) 
 
INSERT #tmp
EXEC sp_MSforeachdb 'use [?] SELECT db_name(), name ,size/128.0 - CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0, CAST(FILEPROPERTY(name, ''SpaceUsed'') AS int)/128.0 FROM sys.database_files where type = ''1'''
 
DECLARE @name AS NVARCHAR(128)
DECLARE @db AS NVARCHAR(128)
DECLARE @sql AS VARCHAR (294)
WHILE @@ROWCOUNT > 0
BEGIN
    SET ROWCOUNT 1
    SELECT @name = name FROM #tmp
    SELECT @db = db FROM #tmp
/*
 * check for log files that have 20 time 
 * their used space available. If the check 
 * returns true it will shrink the file to
 * 20 time the space used.
 *
 * These values can be changed if necessary
 */
    IF
    (SELECT (used*1) FROM #tmp WHERE db = @db and name = @name) < (SELECT size FROM #tmp WHERE db = @db and name = @name)
		BEGIN
		    /*
		     * Shrink to 20x used space
		     */
		    SET @sql =	'Use ['+ (select db from #tmp where db = @db and name = @name) + '] dbcc shrinkfile ([' + @name + '],' + cast(cast(round((select (used*20) from #tmp where [db] = @db and [name] = @name),0) as int) as varchar(12)) + ')'
			print @sql
		    EXEC ( @sql )
 
		    /*
		     * Release unused space
		     */
		    SET @sql =	'Use ['+ (select db from #tmp where db = @db and name = @name) + '] dbcc shrinkfile ([' + @name + '], 0 , TRUNCATEONLY)'
					print @sql
		    EXEC ( @sql )		
		END
    DELETE FROM #tmp WHERE name = @name
END
 
SET ROWCOUNT 0
SET NOCOUNT off
DROP TABLE #tmp

END