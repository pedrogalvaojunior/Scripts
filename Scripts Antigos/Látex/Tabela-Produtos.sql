/****** Object:  Table [dbo].[PRODUTOS]    Script Date: 09/10/2003 13:58:50: JR ******/
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PRODUTOS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PRODUTOS]
GO

/****** Object:  Table [dbo].[PRODUTOS]    Script Date: 09/10/2003 13:58:51: JR ******/
CREATE TABLE [dbo].[PRODUTOS] (
	[CODPRODUTO] [nchar] (12) COLLATE Latin1_General_CI_AS NOT NULL ,
	[CODBARRAS] [decimal](18, 0) NOT NULL ,
	[DESCRICAO] [varchar] (60) COLLATE Latin1_General_CI_AS NOT NULL ,
	[DATACADASTRO] [datetime] NULL ,
	[CADASTRADOPOR] [char] (8) COLLATE Latin1_General_CI_AS NULL ,
	[CODDUN14] [decimal](18, 0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PRODUTOS] WITH NOCHECK ADD 
	CONSTRAINT [IND_CODPRODUTO] PRIMARY KEY  CLUSTERED 
	(
		[CODPRODUTO],
		[CODBARRAS]
	) WITH  FILLFACTOR = 80  ON [PRIMARY] 
GO

