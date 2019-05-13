

CREATE PROCEDURE [Devops].[Batch_New]
	@EnvironmentID INT,
	@Type VARCHAR(10),
	@BatchId INT OUTPUT
AS
BEGIN

	/*
	
	Insert a new Batch.

	THIS PROCEDURE IS USED BY THE BATCH FRAMEWORK AND IS NOT INTENDED TO BE CALLED DIRECTLY.
	
	*/ 

	SET NOCOUNT ON;

	INSERT Devops.[Batch]
	(
		[EnvironmentConfigID],
		StartTime,
		CompletionStatus,
		[TYPE]

	)
	VALUES
	(
		@EnvironmentID,
		GETDATE(),
		Null,
		@Type
	);

	SELECT @BatchId = SCOPE_IDENTITY();

	
END