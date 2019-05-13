CREATE TABLE [Devops].[CopyFilesConfig] (
    [CopyFilesConfigId]   INT            IDENTITY (1, 1) NOT NULL,
    [EnvironmentConfigId] INT            NULL,
    [FileName]            VARCHAR (1000) NULL,
    [CopyFrom]            VARCHAR (1000) NULL,
    [CopyTo]              VARCHAR (1000) NULL,
    [SortOrder]           INT            NULL,
    [Status]              VARCHAR (100)  NULL
);



