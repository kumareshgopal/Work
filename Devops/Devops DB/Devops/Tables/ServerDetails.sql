CREATE TABLE [Devops].[ServerDetails] (
    [Rundate]            DATETIME        NULL,
    [ServerName]         VARCHAR (50)    NULL,
    [SQLVersion]         VARCHAR (100)   NULL,
    [DatabaseName]       VARCHAR (50)    NULL,
    [CreateDateTime]     DATETIME        NULL,
    [CompatibilityLevel] INT             NULL,
    [CollationName]      VARCHAR (100)   NULL,
    [RecoveryModel]      VARCHAR (50)    NULL,
    [LastBackUpTime]     DATETIME        NULL,
    [DatabaseSize]       DECIMAL (10, 2) NULL,
    [DatabaseType]       VARCHAR (50)    NULL
);

