 

CREATE  PROC [Devops].[sp_ExecutionPlan_New]
( @BatchExecutionId INT,
  @BackupRestoreConfigID INT ,
  @RestoreScript VARCHAR(MAX),
 @BackupScript  VARCHAR(MAX),
 @RestoreSpace  BIGINT,
 @ServerSpace   BIGINT ,
  @ExecutionPlanID INT OUTPUT
  )
AS
BEGIN

SET NOCOUNT ON;

	INSERT Devops.ExecutionPlan
	(
		[BatchExecutionId],
		[BackupRestoreConfigID]	,
		[RestoreScript],
		[BackupScript], 
		[RestoreSpace],
		[ServerSpace]
	)	
	VALUES
	(
		@BatchExecutionId,
		@BackupRestoreConfigID,
		@RestoreScript,
		@BackupScript,
		@RestoreSpace,
		@ServerSpace
	);

	SELECT @ExecutionPlanID = SCOPE_IDENTITY();
END