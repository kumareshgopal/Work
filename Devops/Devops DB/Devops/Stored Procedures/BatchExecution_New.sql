
CREATE PROCEDURE [Devops].[BatchExecution_New]
	@BatchId INT,
	@BackupRestoreConfigID INT ,
	@BatchExecutionID INT OUTPUT
AS
BEGIN

	/*
	
	Insert a new Batch.

	THIS PROCEDURE IS USED BY THE BATCH FRAMEWORK AND IS NOT INTENDED TO BE CALLED DIRECTLY.
	
	*/ 

	SET NOCOUNT ON;

	INSERT Devops.[BatchExecution]
	(
		[BatchId],
		[BackupRestoreConfigID],
		[BatchStart],
		[Status]
	)
	VALUES
	(
		@BatchId,
		@BackupRestoreConfigID,
		GETDATE(),
		NUll
	);

	SELECT @BatchExecutionID = SCOPE_IDENTITY();

	
END