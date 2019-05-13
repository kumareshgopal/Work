CREATE TABLE [Devops].[BackupRestoreConfig] (
    [BackupRestoreConfigID] INT            IDENTITY (1, 1) NOT NULL,
    [EnvironmentConfigID]   INT            NOT NULL,
    [DatabaseName]          VARCHAR (255)  NOT NULL,
    [FileName]              VARCHAR (255)  NOT NULL,
    [FilePath]              VARCHAR (1000) NOT NULL,
    [IsRestore]             BIT            NULL,
    [IsBackup]              BIT            NULL,
    [NoofBackupFiles]       INT            NULL,
    [OverrideExistingDB]    BIT            NULL,
    [SortOrder]             INT            NULL,
    [AWOSetup]              BIT            NULL,
    [DataFolder]            VARCHAR (1000) NULL,
    [LogFolder]             VARCHAR (1000) NULL,
    [RecoveryMode]          VARCHAR (50)   NULL,
    CONSTRAINT [PK_BackupRestoreConfig] PRIMARY KEY CLUSTERED ([BackupRestoreConfigID] ASC)
);



GO

GO