Create Database KLD


-- Adicionando o FileGroup para trabalhar com FileStream --
ALTER DATABASE KLD
ADD FILEGROUP [KLDFSGROUP] CONTAINS FILESTREAM


-- Adicionando arquivo vinculado com o FileGroup do FileStream --
ALTER database KLD
ADD FILE
(
    NAME= 'KLD_Data_FSGroup',
    FILENAME = 'D:\MSSQL2008\Data\KLD_Data_FSGroup'
)
TO FILEGROUP [KLDFSGROUP]


-- Criando uma Tabela vinculada com o FileGroup pertencente ao FileStream --
CREATE TABLE [dbo].[LOGFILE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DT_LOG] [date] NULL,
	[LOG_FILE] [varbinary](max) FILESTREAM  NULL,
	[ROWGUIDE] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
PRIMARY KEY CLUSTERED ([ID] ASC)
WITH 
 (PAD_INDEX  = OFF, 
  STATISTICS_NORECOMPUTE  = OFF, 
  IGNORE_DUP_KEY = OFF, 
  ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) 
ON [PRIMARY] FILESTREAM_ON [KLDFSGROUP],
UNIQUE NONCLUSTERED 
([ROWGUIDE] ASC)
 WITH (PAD_INDEX  = OFF, 
 STATISTICS_NORECOMPUTE  = OFF, 
 IGNORE_DUP_KEY = OFF, 
 ALLOW_ROW_LOCKS  = ON, 
 ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]) 
ON [PRIMARY] FILESTREAM_ON [KLDFSGROUP]
GO


