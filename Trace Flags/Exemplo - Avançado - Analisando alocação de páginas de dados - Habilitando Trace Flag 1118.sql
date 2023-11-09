--0) Cria o banco de dados Inside
*/
USE MASTER
GO

IF EXISTS (SELECT * FROM SYSDATABASES WHERE [Name] = 'Inside')
BEGIN
	DROP DATABASE Inside
END
GO

CREATE DATABASE Inside
ON
(
Name = 'Inside_data',
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL$INST2000_01\Data\Inside_data.mdf',
Size = 10MB,
FileGrowth = 5MB,
MaxSize = UNLIMITED
)
LOG ON
(
Name = 'Inside_log',
FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL$INST2000_01\Data\Inside_log.mdf',
Size = 5MB,
FileGrowth = 3MB,
MaxSize = UNLIMITED
)
GO

USE TempDB
go

/*
	1 - PRIMEIRA ETAPA
	==============================================================================

	Mostra que inicalmente o SQL Server aloca 1 p�gina em extents mistos at� que 8 p�ginas sejam utilizadas. 
	A partir da� o SQL Server passa a alocar um extent uniforme (8 p�ginas) quando necess�rio.
*/

/*
	1.1) Cria nova tabela para verificar modelo aloca��o
*/
IF EXISTS (SELECT * FROM SysObjects WHERE [Name] = 'PageAlloc_01' and Xtype = 'U')
BEGIN
	DROP TABLE PageAlloc_01
END
GO

CREATE Table PageAlloc_01
(
	Data CHAR(1000) NOT NULL
)
GO

INSERT INTO PageAlloc_01 VALUES ('01')

DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

INSERT INTO PageAlloc_01 VALUES ('02')
INSERT INTO PageAlloc_01 VALUES ('03')
INSERT INTO PageAlloc_01 VALUES ('04')
INSERT INTO PageAlloc_01 VALUES ('05')
INSERT INTO PageAlloc_01 VALUES ('06')
INSERT INTO PageAlloc_01 VALUES ('07')

DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

INSERT INTO PageAlloc_01 VALUES ('08')

/*
	1.2) Uma nova p�gina foi alocada, tamb�m em um extent misto.
*/
DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)

INSERT INTO PageAlloc_01 VALUES ('09')
INSERT INTO PageAlloc_01 VALUES ('10')
INSERT INTO PageAlloc_01 VALUES ('11')
INSERT INTO PageAlloc_01 VALUES ('12')
INSERT INTO PageAlloc_01 VALUES ('13')
INSERT INTO PageAlloc_01 VALUES ('14')

DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

INSERT INTO PageAlloc_01 VALUES ('15')

/*
	1.3) Uma nova aloca��o de p�gina se repete...
*/
DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

/*
	1.4) Preenche as outras p�ginas at� que o objeto tenha alocado 8 p�ginas distribu�das em extents mistos
*/
DECLARE @Contador INT
SET @Contador = 16

WHILE @Contador < 57
BEGIN
	INSERT INTO PageAlloc_01 VALUES (@Contador)	
	SET @Contador = @Contador + 1
END

DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

/*
	1.5) Quando o registo 57 for inserido, o SQL Server passar� a alocar extents uniformes, como pode
	ser visto na sa�da do ExtentInfo.

	Extent size = 8
*/
INSERT INTO PageAlloc_01 VALUES (57)

DBCC EXTENTINFO(TempDB, 'PageAlloc_01', 0)
GO

/*
	2 - SEGUNDA ETAPA
	==============================================================================

	Habilitando o trace flag 1118 o SQL Server altera o modelo de aloca��o, passando a reservar 1 extent 
uniforme j� no primeiro acesso. Isso faz com que o acesso nas p�ginas PFS e SGAM diminua, j� que o SQL Server
n�o necessita consultar diversas vezes essas informa��es para alocar as 8 p�ginas. Por outro lado, um objeto de
1 KB vai "usar" 64 KB, provavelmente gerando um aumento do tamanho dos arquivos da tempdb.
*/

/*
	2.1) Exibe os trace flags correntes e depois habilita o trace flag 1118
*/
DBCC TRACESTATUS(-1)
DBCC TRACEON(1118)

/*
	2.2) Cria nova tabela para verificar modelo aloca��o
*/
IF EXISTS (SELECT * FROM SysObjects WHERE [Name] = 'PageAlloc_02' and Xtype = 'U')
BEGIN
	DROP TABLE PageAlloc_02
END
GO

CREATE Table PageAlloc_02
(
	Data CHAR(1000) NOT NULL
)
GO

INSERT INTO PageAlloc_02 VALUES ('01')

/*
	2.3) Podemos ver na sa�da do ExtentInfo, que o SQL Server j� alocou 8 p�ginas para este objeto.

	Extent size = 8
*/
DBCC EXTENTINFO(TempDB, 'PageAlloc_02', 0)
GO

/*
	2.4) Repete a inser��o de 55 registros para preencher o espa�o das 8 p�ginas inicialmente alocadas.
*/
DECLARE @Contador INT
SET @Contador = 2

WHILE @Contador < 57
BEGIN
	INSERT INTO PageAlloc_02 VALUES (@Contador)	
	SET @Contador = @Contador + 1
END

DBCC EXTENTINFO(TempDB, 'PageAlloc_02', 0)
GO

/*
	2.5) Quando o registro 57 for inserido o SQL Server alocar� um novo extent uniforme, seguindo a maneira
padr�o de aloca��o de p�ginas para objetos com mais de 64 KB.

	Extent size = 8
*/
INSERT INTO PageAlloc_02 VALUES (57)

DBCC EXTENTINFO(TempDB, 'PageAlloc_02', 0)
GO

/*
	2.6) Com isso demonstramos o efeito do trace flag 1118 no SQL Server.
*/


/*
	3 - TERCEIRA ETAPA
	==============================================================================

	Uma d�vida comum que temos com rela��o ao trace flag 1118 � se ele somente se aplica ao tempDB ou
a qualquer banco de dados que exista no SQL Server. Para descobrirmos isso, vamos apenas reexecutar uma
inser��o em um banco de dados de usu�rio.

*/

/*
	3.1) Cria nova tabela para verificar modelo aloca��o em um banco de dados de usu�rio.
*/
USE Inside
GO

IF EXISTS (SELECT * FROM SysObjects WHERE [Name] = 'PageAlloc_03' and Xtype = 'U')
BEGIN
	DROP TABLE PageAlloc_03
END
GO

CREATE Table PageAlloc_03
(
	Data CHAR(1000) NOT NULL
)
GO

INSERT INTO PageAlloc_03 VALUES ('01')

/*
	3.2) Podemos ver na sa�da do ExtentInfo, que o SQL Server j� alocou 8 p�ginas para este objeto.

	Extent size = 8
*/
DBCC EXTENTINFO(Inside, 'PageAlloc_03', 0)
GO

/*
	** Admito que inicialmente eu achei que este comportamento somente se aplicaria ao
banco de dados TempDB, apesar do artigo n�o deixar claro o escopo do trace flag. Nosso exemplo
demonstra claramente que o trace flag se aplica a TODO O SERVIDOR SQL SERVER...

		Nada como um exemplo para entendermos melhor como tudo funciona...
*/
