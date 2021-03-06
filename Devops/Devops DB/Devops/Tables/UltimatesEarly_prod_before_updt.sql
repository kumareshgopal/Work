﻿CREATE TABLE [Devops].[UltimatesEarly_prod_before_updt] (
    [StagingID]              INT              IDENTITY (1, 1) NOT NULL,
    [ReportingPeriod]        VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [RecordType]             VARCHAR (50)     COLLATE Latin1_General_CI_AS NULL,
    [PolicySectionRef]       VARCHAR (50)     COLLATE Latin1_General_CI_AS NULL,
    [UWYr]                   VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [BPCCode]                VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [RiskCodePol]            VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [RiskLocnCountryCode]    VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [MOACode]                VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [OrigOfficeCode]         VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [OrigCcyCode]            VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [SettCcyCode]            VARCHAR (10)     COLLATE Latin1_General_CI_AS NULL,
    [IHGrossErndClm]         NUMERIC (38, 20) NULL,
    [IHOutRIErndClm]         NUMERIC (38, 20) NULL,
    [MBEGrossLoad]           NUMERIC (38, 20) NULL,
    [MBEOutRILoad]           NUMERIC (38, 20) NULL,
    [IHGrossUnerndClm]       NUMERIC (38, 20) NULL,
    [IHUnerndUltOutRIClm]    NUMERIC (38, 20) NULL,
    [IHGrossErndClmSII]      NUMERIC (38, 20) NULL,
    [IHOutRIErndClmSII]      NUMERIC (38, 20) NULL,
    [IHGrossUnerndClmSII]    NUMERIC (38, 20) NULL,
    [IHUnerndUltOutRIClmSII] NUMERIC (38, 20) NULL,
    [SourceSystemID]         INT              NULL,
    [CDCBatchId]             INT              NULL,
    [CDCDate]                DATETIME         NOT NULL,
    [RowStatus]              CHAR (1)         COLLATE Latin1_General_CI_AS NOT NULL,
    [ValidationMessage]      VARCHAR (2500)   COLLATE Latin1_General_CI_AS NULL
);

