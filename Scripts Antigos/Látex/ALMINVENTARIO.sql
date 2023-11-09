/****** Object:  Table [dbo].[ALMINVENTARIO]    Script Date: 09/05/2005 15:47:45 ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ALMINVENTARIO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ALMINVENTARIO]
GO

/****** Object:  Table [dbo].[ALMINVENTARIO]    Script Date: 09/05/2005 15:47:47 ******/
CREATE TABLE [dbo].[ALMINVENTARIO] (
	[CODPRODSEQUENCIAL] [int] NOT NULL ,
	[DEPOSITO] [smallint] NOT NULL ,
	[PLEITURA] [float] NOT NULL ,
	[SLEITURA] [float] NOT NULL ,
	[SALDOSISTEMA] [float] NOT NULL ,
	[STPLEITURA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STSLEITURA] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[STSLDTFLEX] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ALMINVENTARIO] WITH NOCHECK ADD 
	CONSTRAINT [PK_ALMINVENTARIO] PRIMARY KEY  CLUSTERED 
	(
		[CODPRODSEQUENCIAL],
		[DEPOSITO]
	) WITH  FILLFACTOR = 80  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ALMINVENTARIO] ADD 
	CONSTRAINT [DF_ALMINVENTARIO_PLEITURA] DEFAULT (0) FOR [PLEITURA],
	CONSTRAINT [DF_ALMINVENTARIO_SLEITURA] DEFAULT (0) FOR [SLEITURA],
	CONSTRAINT [DF_ALMINVENTARIO_SALDOSISTEMA] DEFAULT (0) FOR [SALDOSISTEMA],
	CONSTRAINT [DF_ALMINVENTARIO_STPLEITURA] DEFAULT ('N') FOR [STPLEITURA],
	CONSTRAINT [DF_ALMINVENTARIO_STSLEITURA] DEFAULT ('N') FOR [STSLEITURA],
	CONSTRAINT [DF_ALMINVENTARIO_STSLDTFLEX] DEFAULT ('N') FOR [STSLDTFLEX]
GO

