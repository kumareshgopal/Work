CREATE TABLE [Devops].[BatchExecution] (
    [BatchExecutionId]      INT            IDENTITY (1, 1) NOT NULL,
    [BatchId]               INT            NOT NULL,
    [BackupRestoreConfigID] INT            NULL,
    [BatchStart]            DATETIME       NULL,
    [BatchEnd]              DATETIME       NULL,
    [Status]                VARCHAR (10)   NULL,
    [ErrorDesc]             VARCHAR (1000) NULL,
    CONSTRAINT [PK_BatchExecution] PRIMARY KEY CLUSTERED ([BatchExecutionId] ASC)
);



