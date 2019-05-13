


CREATE  PROC [Devops].[sp_NeworResumeBatch]
( @EnvironmentName Varchar(100),
  @Type Varchar(10),
  @BatchID INT OUTPUT)
AS
BEGIN
 
 DECLARE @intCnt INT
 DECLARE @EnvironmentId INT


 SELECT  @EnvironmentId= EnvironmentConfigID from Devops.EnvironmentConfig where EnvironmentName=@EnvironmentName

 SELECT @BatchId = B.BatchId from Devops.Batch B
 inner join Devops.EnvironmentConfig en on en.EnvironmentConfigID  = B.EnvironmentConfigID
 Where en.EnvironmentName =@EnvironmentName
 And (B.CompletionStatus is null or B.CompletionStatus =0)
 And B.Type = @Type


 IF (@BatchId is null)
 BEGIN
			EXEC Devops.[Batch_New]
			@EnvironmentId = @EnvironmentId,
			@Type =@Type,
			@BatchId = @BatchId OUTPUT
			
			SELECT @BatchId
			Return 0 
 END
 ELSE
 BEGIN
      SELECT @BatchId
	  REturn 0
 END
 END