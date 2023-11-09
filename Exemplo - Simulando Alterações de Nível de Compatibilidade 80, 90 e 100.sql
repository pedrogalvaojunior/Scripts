/* A. Alterando o nível de compatibilidade: O exemplo a seguir altera o nível de compatibilidade 
do banco de dados AdventureWorks2008R2 para 90, SQL Server 2005.*/

ALTER DATABASE AdventureWorks2008R2
SET COMPATIBILITY_LEVEL = 90;
GO

/*B. Efeito do nível de compatibilidade em ORDER BY (Cenário 1): O exemplo a seguir 
ilustra a diferença na associação ORDER BY para os níveis de compatibilidade 80 e 100. 
O exemplo cria uma tabela de exemplo, SampleTable, no banco de dados tempdb.*/

USE tempdb;
CREATE TABLE SampleTable(c1 int, c2 int);
GO

/*Em níveis de compatibilidade 90 e superior, no nível padrão, 
a instrução SELECT... ORDER BY a seguir produz um erro porque o alias de coluna na cláusula 
AS, c1, é ambíguo.*/

SELECT c1, c2 AS c1
FROM SampleTable
ORDER BY c1;
GO

/*Depois de redefinir o banco de dados para o nível de compatibilidade 80, a mesma instrução 
SELECT... ORDER BY será bem-sucedida.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1, c2 AS c1
FROM SampleTable
ORDER BY c1;
GO

/*A seguinte instrução SELECT... ORDER BY funciona em ambos os níveis de compatibilidade 
porque um alias inequívoco é especificado na cláusula AS.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 100;
GO

SELECT c1, c2 AS c3
FROM SampleTable
ORDER BY c1;
GO

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1, c2 AS c3
FROM SampleTable
ORDER BY c1;
GO

/*C. Efeito do nível de compatibilidade em ORDER BY (Cenário 2): Em níveis de compatibilidade 90 
e superior, no nível padrão, a instrução SELECT...ORDER BY a seguir produz um erro porque o 
alias de coluna especificado na cláusula ORDER BY contém um prefixo de tabela.*/

SELECT c1 AS x
FROM SampleTable
ORDER BY SampleTable.x;
GO

/*Depois de redefinir o banco de dados para o nível de compatibilidade 80, a mesma instrução 
SELECT...ORDER BY será bem-sucedida.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1 AS x
FROM SampleTable
ORDER BY SampleTable.x;
GO

/*A seguinte instrução SELECT...ORDER BY funciona em ambos os níveis de compatibilidade 
porque o prefixo de tabela foi removido da coluna alias especificada na cláusula ORDER BY.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 100;
GO

SELECT c1 AS x
FROM SampleTable
ORDER BY x;
GO

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1 AS x
FROM SampleTable
ORDER BY x;
GO