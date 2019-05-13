CREATE TABLE [Devops].[EnvironmentConfig] (
    [EnvironmentConfigID] INT           IDENTITY (1, 1) NOT NULL,
    [EnvironmentName]     VARCHAR (50)  NOT NULL,
    [DatabaseServerName]  VARCHAR (100) NULL,
    [AnalysisServerName]  VARCHAR (100) NULL,
    [SourceServerName]    VARCHAR (100) NULL,
    [IsActive]            INT           NULL,
    CONSTRAINT [PK_Environment] PRIMARY KEY CLUSTERED ([EnvironmentConfigID] ASC, [EnvironmentName] ASC)
);



