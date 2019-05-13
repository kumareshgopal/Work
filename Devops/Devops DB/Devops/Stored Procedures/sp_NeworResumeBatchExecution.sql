
CREATE PROC [Devops].[sp_NeworResumeBatchExecution] (
  @BatchId INT    ,
  @BackupRestoreConfigID INT,
  @BatchExecutionID INT OUTPUT
)

AS
BEGIN

	IF EXISTS (SELECT * FROM Devops.Batch  WHERE BatchId =@BatchId 
	and (CompletionStatus =0 or CompletionStatus is null ) )
	BEGIN
	 IF EXISTS ( SELECT * FROM Devops.BatchExecution  WHERE BatchId =@BatchId and BackupRestoreConfigID =@BackupRestoreConfigID  
				and (Status <> 'Completed' or Status is null ))
        BEGIN
			SELECT @BatchExecutionID = BatchExecutionID  FROM Devops.BatchExecution  WHERE BatchId =@BatchId and BackupRestoreConfigID =@BackupRestoreConfigID  
			SELECT @BatchExecutionID
		END
	ELSE
		BEGIN  
			EXEC [Devops].[BatchExecution_New] 
			@BatchId = @BatchId,
			@BackupRestoreConfigID=@BackupRestoreConfigID,
			@BatchExecutionID = @BatchExecutionID OUTPUT

			
			SELECT @BatchExecutionID
		 
		END

	
	
END
END