-- Acesso o Banco de Dados Aula 9 --
Use Aula9
Go

-- Obtendo o tamanho da tabela 'Tabela1' --
sp_spaceused 'Tabela1'
Go

-- Obtendo informações sobre os arquivos que compõem o banco de dados --
Exec SP_HelpFile
Go

-- Obtendo informações sobre o Grupo de Arquivos (FileGroup) atual --
Exec SP_HelpFileGroup
Go

-- Adicionando um novo FileGroup --
Alter DataBase Aula9
 Add Filegroup Segundo
Go

-- Adicionando um novo Arquivo de Dados ao Banco de Dados Aula9 --
Alter Database Aula9
Add File
 (Name = Aula9_Dados_Terceiro,
  FileName = 'C:\Bancos\Aula9_Dados_Terceiro.ndf',
  Size = 4MB,
  MaxSize = Unlimited,
  Filegrowth = 10%)
To Filegroup Segundo
Go

-- Criando a nova Tabela2 no FileGroup Segundo --
CREATE TABLE TABELA2
(Codigo bigint IDENTITY(1,1) NOT NULL Primary Key,
 Valores1 int NOT NULL,
 Valores2 int NOT NULL,
 Texto varchar(max) NULL,
 Texto2 text NULL,
 DataInicial date NULL,
 DataFinal datetime NULL) 
ON [SEGUNDO]
Go

-- Copiando os Dados da Tabela1 para Tabela2 --
Insert Into TABELA2
 Select Valores1, Valores2, Texto, Texto2, DataInicial, DataFinal From TABELA1
Go

Select * from Tabela2
Go

-- Obtendo informações sobre LogSpace --
DBCC SQLPERF(Logspace)
Go

-- Obtendo informações sobre transações ativas/execução --
DBCC OPENTRAN(Aula9)
Go

-- Obtendo Status de Reutilização do Transaction Log --
Select Log_Reuse_Wait, log_reuse_wait_desc from sys.databases 
Where name='Aula9'

-- Alterando o Modelo de Recuperação do Banco de Dados --
ALTER DATABASE Aula9  
Set Recovery Simple -- Descartando o uso Arquivo de Log --
Go

-- Encolhendo o Arquivo de Log --
DBCC ShrinkFile(2,50);
Go
  
Dbcc Shrinkfile(2,TruncateOnly)
Go

--
ALTER DATABASE Aula9  
Set Recovery Full -- Habilitando o uso do Arquivo de Log --
Go

-- Alterando as propriedades do Arquivo de Log --
Alter Database Aula9
Modify File
 (Name = AULA9_LOG,
  MaxSize = Unlimited,
  Filegrowth = 10%)
Go