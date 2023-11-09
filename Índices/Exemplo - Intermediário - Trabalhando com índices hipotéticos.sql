-- Passo 1 - Criando o Banco de Dados HypotheticalDB --
CREATE DATABASE [HypotheticalDB]
ON  PRIMARY 
(NAME = 'HypotheticalDB-Data', 
 FILENAME = 'C:\SQLServer2016\Data\HypotheticalDB_Data.mdf' , 
 SIZE = 4MB , 
 MAXSIZE = 4096MB, 
 FILEGROWTH = 2MB )
LOG ON 
(NAME = 'HypotheticalDB-Log', 
 FILENAME = 'C:\SQLServer2016\Log\HypotheticalDB_Log.ldf' , 
 SIZE = 8MB , 
 MAXSIZE = 2GB , 
 FILEGROWTH = 4MB)
GO

-- Passo 2 - Acessando o Banco de Dados --
Use HypotheticalDB
Go

-- Passo 3 - Criando as Tabelas --
Drop Table If Exists dbo.Clientes
CREATE TABLE Clientes
(Codigo  INT Identity(1,1) NOT NULL Primary Key Clustered,
 CodigoCategoria TinyInt NOT NULL,
 Nome  VARCHAR(60) NOT NULL,
 Endereco VARCHAR(80) NOT NULL,
 Estado  CHAR(2) NOT NULL,
 DataUltimaCompra  DATETIME)
Go

Drop Table If Exists dbo.ClientesCategorias
CREATE TABLE ClientesCategorias 
(Codigo TinyInt NOT NULL,
 Descricao VARCHAR(20) NOT NULL)
Go

-- Passo 4 - Inserindo dados na Tabela ClientesCategorias --
INSERT Into ClientesCategorias (Codigo, Descricao)
 Values (1, 'Premier'),
             (2, 'Advanced'),
             (3, 'Special')
Go

-- Passo 5 - Inserindo dados na Tabela Clientes --
Insert Into Clientes (CodigoCategoria, Nome, Endereco, Estado, DataUltimaCompra)
Values (3, 'José Bonito','Rua A','SP',GETDATE()-30),
            (1, 'Dassaev Silva','Rua B','SP',GETDATE()-120),
            (3, 'Viewer Partes','Rua 123','RJ',GETDATE()-720),
            (1, 'Dino Silva Sauros','Avenida Parque dos Dinassauros','AM',GETDATE()-240),
			(2, 'Fernandino Campos Boyd','Estrada Velha','MG',GETDATE()-5),
            (1, 'Katrina Tornado','Rua Storm','RG',GETDATE()-300),
            (2, 'Washington Wizard','Place 1','PR',GETDATE()-1024),
            (3, 'Chicago Bulls','Place 2','PR',GETDATE()-89),
            (2, 'Denver Nuggets','Place 3','PR',GETDATE()-289),
            (2, 'Los Angeles Lakers','Place 4','PR',GETDATE()-390)
Go

-- Passo 6 - Consultando os dados --
Select Codigo, Descricao From ClientesCategorias
Go

Select Codigo, CodigoCategoria, Nome, Endereco, Estado, DataUltimaCompra From Clientes
Go

-- Passo 7 - Criando índices hipotéticos não-clusterizado na tabela ClientesCategorias --
CREATE INDEX IND_ClientesCategorias_NaoClusterizado_CodigoSemEstatisticas 
 ON ClientesCategorias (Codigo) With Statistics_Only = 0

CREATE INDEX IND_ClientesCategorias_NaoClusterizado_CodigoComEstatisticas 
 ON ClientesCategorias (Codigo) With Statistics_Only = -1
Go

-- Passo 8 - Criando índices hipotéticos clusterizado na tabela ClientesCategorias --
CREATE CLUSTERED INDEX IND_ClientesCategorias_Clusterizado_CodigoComEstatisticas 
 ON ClientesCategorias (Codigo) With Statistics_Only = -1
Go

-- Abrir a estrutura da tabela e verificar que os índices não estão criados fisicamente, mas sim lógicamente através da guia estatísticas --

-- Passo 9 - Obtendo informações sobre os índices --
Exec sp_helpindex ClientesCategorias
Go

DBCC SHOW_STATISTICS (ClientesCategorias, IND_ClientesCategorias_Clusterizado_CodigoComEstatisticas)
DBCC SHOW_STATISTICS (ClientesCategorias, IND_ClientesCategorias_NaoClusterizado_CodigoSemEstatisticas)
DBCC SHOW_STATISTICS (ClientesCategorias, IND_ClientesCategorias_NaoClusterizado_CodigoComEstatisticas)
Go

-- Passo 10 - Obtendo informações sobre a relação de índices --
SELECT object_id, 
             OBJECT_NAME(object_id) AS 'Tabelas' ,
             name As 'Nome do Índice',
             type_desc,
			 Index_id,
             is_hypothetical As 'Índice Hipotético = 1 Não-Hipotético=0'
FROM sys.indexes 
WHERE object_id in (object_id('ClientesCategorias'), object_id('Clientes'))
Go

-- Passo 11 - Executando o Select de maneira clássica sem a diretiva SET AUTOPILOT --
SET SHOWPLAN_XML ON
Go

Select C.Codigo, 
          Cc.Codigo As 'Categoria do Cliente', 
		  C.Nome, 
		  C.Endereco, 
		  C.Estado, 
		  C.DataUltimaCompra 
From Clientes C Inner Join ClientesCategorias CC
                           On C.CodigoCategoria = CC.Codigo
Where C.Estado = 'SP'
GO 

SET SHOWPLAN_XML OFF
Go

-- Passo 12 - Executando o Select de maneira personalizada ativando a diretiva SET AUTOPILOT  --
SET AUTOPILOT ON -- Ativando a diretiva --
Go

Select C.Codigo, 
          Cc.Codigo As 'Categoria do Cliente', 
		  C.Nome, 
		  C.Endereco, 
		  C.Estado, 
		  C.DataUltimaCompra 
From Clientes C Inner Join ClientesCategorias CC
                           On C.CodigoCategoria = CC.Codigo
Where C.Estado = 'SP'
Go

SET AUTOPILOT OFF -- Desativando a diretiva --
GO

-- Apresentar o plano de execução e identificar o uso do índice hipotético --

-- Passo 13 - Habilitando o índice hipotético clusterizado --
Use HypotheticalDB
Go

DBCC AUTOPILOT (5, 5, 0, 0, 0)
DBCC AUTOPILOT (6,5,597577167,4)
GO 

SET AUTOPILOT ON -- Ativando a diretiva --
Go

Select C.Codigo, 
          Cc.Codigo As 'Categoria do Cliente', 
		  C.Nome, 
		  C.Endereco, 
		  C.Estado, 
		  C.DataUltimaCompra 
From Clientes C Inner Join ClientesCategorias CC
                           On C.CodigoCategoria = CC.Codigo
Where C.Estado = 'SP'
Go

SET AUTOPILOT OFF -- Desativando a diretiva --
GO

-- Passo 14 - Habilitando o índice hipotético não clusterizado --
DBCC AUTOPILOT (5, 5, 0, 0, 0)
DBCC AUTOPILOT (0,5,597577167,2)
GO 

SET AUTOPILOT ON -- Ativando a diretiva --
Go

Select C.Codigo, 
          Cc.Codigo As 'Categoria do Cliente', 
		  C.Nome, 
		  C.Endereco, 
		  C.Estado, 
		  C.DataUltimaCompra 
From Clientes C Inner Join ClientesCategorias CC
                           On C.CodigoCategoria = CC.Codigo
Where C.Estado = 'SP'
Go

SET AUTOPILOT OFF -- Desativando a diretiva --
GO

-- Resultado misterioso quando se usa o TypeId = 7 --
DBCC AUTOPILOT (7, 5, 0, 0, 0, 2)
GO
SET AUTOPILOT ON
GO

Select C.Codigo, 
          Cc.Codigo As 'Categoria do Cliente', 
		  C.Nome, 
		  C.Endereco, 
		  C.Estado, 
		  C.DataUltimaCompra 
From Clientes C Inner Join ClientesCategorias CC
                           On C.CodigoCategoria = CC.Codigo
Where C.Estado = 'SP'
Go

SET AUTOPILOT OFF
GO
