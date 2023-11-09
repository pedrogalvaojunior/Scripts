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


/* Explica��o

dbo.GUID - A tabela dbo.guid manipular� os processos simult�neos de melhor! A tabela de dbo.guid tem um uniqueidentifier com um guid aleat�rio gerado como padr�o.
Portanto, a instru��o INSERT pode espalhados por todo o n�vel folha do �ndice clusterizado. Cada instru��o INSERT-�nica poderia ser colocada em qualquer posi��o com base no valor GUID.

dbo.Identity - A tabela dbo.identity ser� a solu��o mais lento para esse requisito porque a instru��o INSERT tentar� inserir novos dados sempre no final do �ndice.
Ent�o a �ltima p�gina de dados no �ndice � um hotspot no DML-processo e outros processos t�m que esperar at� que o recurso foi liberado pela instru��o INSERT atual!


dbo.heap - A tabela dbo.heap n�o podem participar de seu benef�cio de uma estrutura de �rvore b faltando. Se novos dados ser�o inseridos um HEAP a p�gina PFS (p�gina de espa�o livre) 
de um arquivo de banco de dados tem de ser digitalizados para uma p�gina que:
� pertence � tabela
� tem espa�o livre suficiente para o armazenamento

Em vez de um hotspot no �ltimo n�vel folha de um �ndice, o processo ir� gerar um hotspot no PFS-p�gina (s) do banco de dados.
Se o banco de dados teria v�rios arquivos de dados (como TEMPDB) o hotspot pode desaparecer.

*/