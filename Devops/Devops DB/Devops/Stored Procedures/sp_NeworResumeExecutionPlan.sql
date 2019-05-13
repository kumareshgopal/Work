


CREATE PROC [Devops].[sp_NeworResumeExecutionPlan] ( 
 @BatchExecutionID INT ,
 @BackupRestoreConfigID INT  ,
 @RestoreScript VARCHAR(MAX),
 @BackupScript  VARCHAR(MAX),
 @RestoreSpace  BIGINT,
 @ServerSpace   BIGINT 
 
)

AS
BEGIN

  DECLARE @ExecutionPlanID INT

	IF EXISTS (SELECT * FROM Devops.ExecutionPlan  WHERE BatchExecutionId =@BatchExecutionId and BackupRestoreConfigID =@BackupRestoreConfigID)
	BEGIN

		UPDATE Devops.ExecutionPlan 
		SET RestoreScript = @RestoreScript
		,BackupScript = @BackupScript
		,RestoreSpace =@RestoreSpace
		,ServerSpace=@ServerSpace
		WHERE BatchExecutionId =@BatchExecutionId and BackupRestoreConfigID =@BackupRestoreConfigID
	
	END
	ELSE 
	BEGIN  
		EXEC [Devops].[sp_ExecutionPlan_New] 
		@BatchExecutionId = @BatchExecutionId,
		@BackupRestoreConfigID=@BackupRestoreConfigID,
		@RestoreScript=@RestoreScript,
		@BackupScript=@BackupScript,
		@RestoreSpace=@RestoreSpace,
		@ServerSpace=@ServerSpace,
		@ExecutionPlanID = @ExecutionPlanID OUTPUT
							 
	END
END