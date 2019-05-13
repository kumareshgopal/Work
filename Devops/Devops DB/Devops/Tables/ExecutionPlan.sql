CREATE TABLE [Devops].[ExecutionPlan] (
    [ExecutionPlanId]       INT           IDENTITY (1, 1) NOT NULL,
    [BatchExecutionId]      INT           NULL,
    [BackupRestoreConfigID] INT           NOT NULL,
    [RestoreScript]         VARCHAR (MAX) NULL,
    [BackupScript]          VARCHAR (MAX) NULL,
    [ErrorDesc]             VARCHAR (MAX) NULL,
    [RestoreSpace]          BIGINT        NULL,
    [ServerSpace]           BIGINT        NULL,
    [LastModifiedDateTime]  DATETIME      CONSTRAINT [DF_ExecutionPlan_LastModifiedDateTime] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PKEXPL] PRIMARY KEY NONCLUSTERED ([ExecutionPlanId] ASC)
);



GO


GO


GO
