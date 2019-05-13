CREATE  PROC Devops.sp_BatchExecution_New
( @BatchId INT,
  @BackupRestoreConfigID INT)
AS
BEGIN
 
 DECLARE @intcnt INT
 
 SELECT @intcnt = COUNT(*) from Devops.BatchExecution where BatchId =@BatchId and BackupRestoreConfigID  = @BackupRestoreConfigID
 and (Status is null and Status <> 'Completed')
 IF (@intcnt =0)
 BEGIN
    INSERT INTO Devops.BatchExecution
	(BatchId,BackupRestoreConfigID,BatchStart)
	SELECT @BatchId,@BackupRestoreConfigID,GETDATE()
 END
END