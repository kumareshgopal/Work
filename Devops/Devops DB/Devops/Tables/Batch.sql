CREATE TABLE [Devops].[Batch] (
    [BatchId]             INT          IDENTITY (1, 1) NOT NULL,
    [EnvironmentConfigID] INT          NOT NULL,
    [StartTime]           DATETIME     NOT NULL,
    [FinishTime]          DATETIME     NULL,
    [CompletionStatus]    BIT          NULL,
    [Type]                VARCHAR (10) NULL,
    CONSTRAINT [PK_Batch] PRIMARY KEY CLUSTERED ([BatchId] ASC)
);



