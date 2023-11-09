-- Criação do Banco de Dados
CREATE DATABASE Testes
ON (
	NAME='Teste_Data',
	FILENAME='C:\Teste_Primary.MDF',
	SIZE=5MB,
	FILEGROWTH=20MB,
	MAXSIZE=300MB)
LOG ON (
	NAME='Teste_Log',
	FILENAME='C:\Teste_Log.LDF',
	SIZE=50MB,
	FILEGROWTH=10MB,
	MAXSIZE=500MB)

-- Criação dos Filegroups
ALTER DATABASE Testes
ADD FILEGROUP FG1

ALTER DATABASE Testes
ADD FILEGROUP FG2

ALTER DATABASE Testes
ADD FILEGROUP FG3

ALTER DATABASE Testes
ADD FILEGROUP FG4

-- Criação dos Arquivos
ALTER DATABASE Testes
ADD FILE (
	NAME='Teste_FG1',
	FILENAME='D:\Teste_FG1.MDF',
	SIZE=5MB,
	FILEGROWTH=5MB,
	MAXSIZE=90MB) TO FILEGROUP FG1

ALTER DATABASE Testes
ADD FILE (
	NAME='Teste_FG2',
	FILENAME='F:\Teste_FG2.MDF',
	SIZE=5MB,
	FILEGROWTH=5MB,
	MAXSIZE=90MB) TO FILEGROUP FG2

ALTER DATABASE Testes
	ADD FILE (
	NAME='Teste_FG3',
	FILENAME='G:\Teste_FG3.MDF',
	SIZE=5MB,
	FILEGROWTH=5MB,
	MAXSIZE=90MB) TO FILEGROUP FG3

ALTER DATABASE Testes
	ADD FILE (
	NAME='Teste_FG4',
	FILENAME='H:\Teste_FG4.MDF',
	SIZE=5MB,
	FILEGROWTH=5MB,
	MAXSIZE=90MB) TO FILEGROUP FG4


-- Criação de um Schema
CREATE SCHEMA FIN
GO

-- Criação de uma função de particionamento
CREATE PARTITION FUNCTION pf_Competencia (INT)
AS RANGE LEFT 
FOR VALUES (200301, 200501, 200701)

-- Cria um esquema de particionamento
CREATE PARTITION SCHEME ps_Competencia
AS PARTITION pf_Competencia
TO (FG1, FG2, FG3, FG4)

-- Os registros menores que 200301 vão para FG1
-- Os registros maiores que 200301 e menores ou igual a 200501 vão para FG2
-- Os registros maiores que 200501 e menores ou igual a 200701 vão para FG3
-- Os registros maiores que 200701 vão para FG4
-- Criação de uma tabela no esquema de particionamento

CREATE TABLE FIN.LANCAMENTOS 
(dLancamento INT IDENTITY(1,1) NOT NULL,
	Ano SMALLINT NOT NULL,
	Mes TINYINT NOT NULL,	
	Valor SMALLMONEY NOT NULL,
	IdResponsavel SMALLINT NOT NULL,
	Descricao VARCHAR(20) NOT NULL,
	Tipo CHAR(1) NOT NULL,
-- Cria uma coluna calculada no formato AAAAMM
-- A cláusula PERSISTED força o armazenamento da coluna
	Competencia AS (Ano * 100) + Mes PERSISTED NOT NULL,
	CONSTRAINT CK_Ano CHECK (Ano >= 1990 And Ano <= 2020),
	CONSTRAINT CK_Tipo CHECK (Tipo = 'C' Or Tipo = 'D'))
	ON ps_Competencia (Competencia)

-- Adiciona uma chave primária clustered na coluna Competencia e na coluna IdLancamento
ALTER TABLE FIN.LANCAMENTOS
ADD CONSTRAINT PK_Lancamentos PRIMARY KEY CLUSTERED (Competencia, IdLancamento)
WITH FILLFACTOR = 80

-- Inserindo Registros
Use Testes;

DECLARE @intRegistros INT,
			@dteData SMALLDATETIME,
			@intIterador INT

SET @intRegistros = 2000000
SET @dteData = '2005-01-01'
SET @intIterador = 1

WHILE @intIterador <= @intRegistros
BEGIN
 INSERT INTO FIN.LANCAMENTOS (Ano, Mes, Valor, IdResponsavel, Descricao, Tipo)
 VALUES (YEAR(DATEADD(dd,(CHECKSUM(NEWID()) / 1000000), @dteData)),
			MONTH(DATEADD(dd,(CHECKSUM(NEWID()) / 1000000), @dteData)),
			ABS(CHECKSUM(NEWID()) / 100000),
			ABS(CHECKSUM(NEWID()) / 100000000) * 2,
			'Descrição Genérica',
			CASE 
			 WHEN ABS(CHECKSUM(NEWID()) / 1000000000) > 1 THEN 'D'
			ELSE 
			 'C' END)

 SET @intIterador = @intIterador + 1
END

-- Alterando índice 
Use Testes;

ALTER INDEX ALL ON FIN.LANCAMENTOS
REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = OFF)

-- Realizando Backup
Use Master;

BACKUP LOG Testes WITH TRUNCATE_ONLY

-- Reduzindo a base
DBCC SHRINKDATABASE (Testes)

-- Reduzindo os arquivos de dados
DBCC SHRINKFILE(2,50)

ALTER INDEX ALL ON FIN.LANCAMENTOS
REBUILD WITH (SORT_IN_TEMPDB = ON, ONLINE = OFF, FILLFACTOR=100)


-- Adiciona um índice para a coluna IdResponsavel
CREATE INDEX ID_Responsavel ON FIN.LANCAMENTOS (IdResponsavel)
WITH FILLFACTOR = 100


-- Verificando as estatísticas
SET STATISTICS TIME ON

-- Q1 (181ms)
SELECT COUNT(*) FROM FIN.LANCAMENTOS
WHERE COMPETENCIA = 200601

-- Q2 (2126ms)
SELECT DISTINCT IdResponsavel, Tipo
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 200301 AND 200412

-- Q3 (19ms)
SELECT IdResponsavel, SUM(Valor) As Total
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 199501 AND 199901
GROUP BY IdResponsavel

-- Q4 (198ms)
SELECT Ano, MIN(Valor) As MenorCredito
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 200101 AND 200112
GROUP BY Ano

-- Q5 (2454ms)
SELECT IdResponsavel, Mes, COUNT(*) As QTD
FROM FIN.LANCAMENTOS
GROUP BY IdResponsavel, Mes

SET STATISTICS TIME OFF

-- Cria uma View para facilitar a exportação
CREATE VIEW FIN.vLancamentos
AS
SELECT
	IdLancamento, Ano, Mes, Valor,
	IdResponsavel, Descricao, Tipo
FROM	FIN.LANCAMENTOS

-- Exporta os dados para um TXT
EXEC master.dbo.XP_CMDSHELL 'bcp [Testes].[fin].[vLancamentos] out C:\Testes.txt -c'

-- Cria uma nova tabela
CREATE TABLE FIN.LANCAMENTOS2 
(IdLancamento INT NOT NULL,
 Ano SMALLINT NOT NULL,
 Mes TINYINT NOT NULL,
 Valor SMALLMONEY NOT NULL,
 IdResponsavel SMALLINT NOT NULL,
 Descricao VARCHAR(20) NOT NULL,
 Tipo CHAR(1) NOT NULL) ON [PRIMARY]

-- Importa os dados do arquivo TXT
EXEC master.dbo.XP_CMDSHELL 'bcp [Testes].[fin].[lancamentos2] in C:\Testes.txt -T -c -b 200000 -h "TABLOCK"'

-- Dropa a tabela anterior
DROP TABLE FIN.LANCAMENTOS

-- Renomeia a nova tabela
SP_RENAME 'FIN.LANCAMENTOS2', 'LANCAMENTOS'

-- Adiciona a coluna calculada Competencia
ALTER TABLE FIN.LANCAMENTOS 
ADD Competencia AS (Ano * 100) + Mes PERSISTED NOT NULL

-- Executa a limpeza do LOG
BACKUP LOG Testes WITH TRUNCATE_ONLY

DBCC SHRINKFILE(2,50)

-- Compacta o banco
DBCC SHRINKDATABASE (Testes)

-- Indexa a tabela e cria a PK (sem particionamento dessa vez)
ALTER TABLE FIN.LANCAMENTOS
ADD CONSTRAINT PK_Lancamentos PRIMARY KEY CLUSTERED (Competencia, IdLancamento)
WITH FILLFACTOR = 100

-- Limpa o Log
BACKUP LOG Testes WITH TRUNCATE_ONLY

DBCC SHRINKFILE(2,50)

-- Adiciona um índice para a coluna IdResponsavel

CREATE INDEX ID_Responsavel ON FIN.LANCAMENTOS (IdResponsavel)
WITH FILLFACTOR = 100


-- Verifica as estatísticas
SET STATISTICS TIME ON

-- Q1 (5ms)
SELECT COUNT(*) FROM FIN.LANCAMENTOS
WHERE COMPETENCIA = 200601

-- Q2 (2028ms)
SELECT DISTINCT IdResponsavel, Tipo
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 200301 AND 200412

-- Q3 (10ms)
SELECT IdResponsavel, SUM(Valor) As Total
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 199501 AND 199901
GROUP BY IdResponsavel

-- Q4 (8ms)
SELECT Ano, MIN(Valor) As MenorCredito
FROM FIN.LANCAMENTOS
WHERE COMPETENCIA BETWEEN 200101 AND 200112
GROUP BY Ano

-- Q5 (1115ms)
SELECT IdResponsavel, Mes, COUNT(*) As QTD
FROM FIN.LANCAMENTOS
GROUP BY IdResponsavel, Mes

SET STATISTICS TIME OFF

USE Master;

-- Derruba todos os usuários

ALTER DATABASE Testes 
SET READ_ONLY
WITH ROLLBACK IMMEDIATE
GO

-- Dropa o banco de dados
DROP DATABASE Testes