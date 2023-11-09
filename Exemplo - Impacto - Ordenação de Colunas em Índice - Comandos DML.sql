Create Database Exemplos

--Criando as Tabelas fisicamente--
CREATE TABLE dbo.Tabela1 
(Coluna1 int NOT NULL,
 Coluna2 int NULL,
 Coluna3 int NULL,
 Coluna4 varchar(50) NULL)
GO

CREATE TABLE dbo.Tabela2 
(Coluna1 int NOT NULL,
 Coluna2 int NULL,
 Coluna3 int NULL,
 Coluna4 varchar(50) NULL)
GO

-- Adicionando Primary Key --
ALTER TABLE dbo.Tabela1 
 ADD CONSTRAINT PK_Tabela1 PRIMARY KEY CLUSTERED (Coluna1) 
GO

ALTER TABLE dbo.Tabela2 
 ADD CONSTRAINT PK_Tabela2 PRIMARY KEY CLUSTERED (Coluna1)
GO

-- Populando as tabelas --
DECLARE @valor INT

SET @valor=1

WHILE @valor < 1000
BEGIN  
   INSERT INTO dbo.Tabela1(Coluna1, Coluna2, Coluna3, Coluna4) VALUES(@valor,@valor,@valor,'Valores')
   INSERT INTO dbo.Tabela2(Coluna1, Coluna2, Coluna3, Coluna4) VALUES(@valor,@valor,@valor,'Valores')
   SET @valor=@valor+1
END
GO

-- Criando Índice na Tabela1 com Multiplas Colunas --
CREATE NONCLUSTERED INDEX IND_Tabela1_Coluna2_Coluna3 
ON dbo.Tabela1 (Coluna3,Coluna2)
 WITH (STATISTICS_NORECOMPUTE = OFF, 
            IGNORE_DUP_KEY = OFF, 
            ALLOW_ROW_LOCKS = ON, 
            ALLOW_PAGE_LOCKS = ON) 
  ON [PRIMARY]
GO

--Ativando a exibição de informações sobre Estatísticas com retorno em Tela--
SET STATISTICS IO ON

--Removendo todos os buffers limpos do Pool de buffers do SQL Server--
DBCC DROPCLEANBUFFERS
GO

--Consultando dados--
SELECT * FROM dbo.Tabela1 WHERE Coluna3=99
GO

--Removendo todos os buffers limpos do Pool de buffers do SQL Server--
DBCC DROPCLEANBUFFERS
GO

--Consultando dados--
SELECT * FROM dbo.Tabela1 WHERE Coluna2=99
GO

--Removendo todos os buffers limpos do Pool de buffers do SQL Server--
DBCC DROPCLEANBUFFERS
GO

--Consultando dados--
SELECT * FROM dbo.Tabela1 INNER JOIN dbo.Tabela2 
                                                ON dbo.Tabela1.Coluna2 = dbo.Tabela2.Coluna1
 WHERE dbo.Tabela1.Coluna3=255       
GO

--Removendo todos os buffers limpos do Pool de buffers do SQL Server--
DBCC DROPCLEANBUFFERS
GO

--Consultando dados--
SELECT * FROM dbo.Tabela1 INNER JOIN dbo.Tabela2 
                                                ON dbo.Tabela1.Coluna3 = dbo.Tabela2.Coluna1
 WHERE dbo.Tabela1.Coluna2=255       
GO

--Desativando a exibição de informações sobre Estatísticas com retorno em Tela--
SET STATISTICS IO OFF