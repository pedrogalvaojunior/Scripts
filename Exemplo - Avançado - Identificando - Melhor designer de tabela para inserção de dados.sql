CREATE DATABASE demo_db
ON PRIMARY
(
    Name = 'demo_db',
    FILENAME = 'C:\Bancos\demo_db.mdf',
    SIZE = 1000MB,
    MAXSIZE = 2000MB,
    FILEGROWTH = 100MB
)
LOG ON
(
    NAME = 'demo_log',
    FILENAME = 'C:\Bancos\demo_db.ldf',
    SIZE = 100MB,
    MAXSIZE = 1000MB,
    FILEGROWTH = 100MB
);
GO

/* The purpose of this database is the storage of data of at least 200 simultaneously writing applications. Every single process inserts 1,000 records as a single transactions for each 
record into the table! This process will be simulated with the following code ( this will be fired by 200 clients simultaneously!) */
Declare @i Int

Set @i = 0

WHILE @i <= 1000
BEGIN
    INSERT INTO dbo.<table_name> DEFAULT VALUES
    SET @i += 1;
END

--The team has developed three different table designs for the fulfilment of the requirements: 

-- Table A --
CREATE TABLE dbo.[identity]
(
    Id    int        NOT NULL    IDENTITY (1, 1),
    C1    char(200)  NOT NULL    DEFAULT ('only a filler'),

    CONSTRAINT pk_identity_Id PRIMARY KEY CLUSTERED (Id)
);
GO

-- Table B --
CREATE TABLE dbo.guid
(
    Id    uniqueidentifier NOT NULL    DEFAULT (newid()),
    C1    char(188)        NOT NULL    DEFAULT ('only a filler'),

    CONSTRAINT pk_guid_id PRIMARY KEY CLUSTERED (Id)
);
GO

-- Table C --
CREATE TABLE dbo.heap
(
    Id    int        NOT NULL    IDENTITY (1, 1),
    C1    char(200)  NOT NULL    DEFAULT ('only a filler')
);
GO


/* Explicação

dbo.GUID - A tabela dbo.guid manipulará os processos simultâneos de melhor! A tabela de dbo.guid tem um uniqueidentifier com um guid aleatório gerado como padrão.
Portanto, a instrução INSERT pode espalhados por todo o nível folha do índice clusterizado. Cada instrução INSERT-única poderia ser colocada em qualquer posição com base no valor GUID.

dbo.Identity - A tabela dbo.identity será a solução mais lento para esse requisito porque a instrução INSERT tentará inserir novos dados sempre no final do índice.
Então a última página de dados no índice é um hotspot no DML-processo e outros processos têm que esperar até que o recurso foi liberado pela instrução INSERT atual!


dbo.heap - A tabela dbo.heap não podem participar de seu benefício de uma estrutura de árvore b faltando. Se novos dados serão inseridos um HEAP a página PFS (página de espaço livre) 
de um arquivo de banco de dados tem de ser digitalizados para uma página que:
• pertence à tabela
• tem espaço livre suficiente para o armazenamento

Em vez de um hotspot no último nível folha de um índice, o processo irá gerar um hotspot no PFS-página (s) do banco de dados.
Se o banco de dados teria vários arquivos de dados (como TEMPDB) o hotspot pode desaparecer.

*/