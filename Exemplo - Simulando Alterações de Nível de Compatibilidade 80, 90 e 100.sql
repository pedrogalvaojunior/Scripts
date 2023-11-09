/* A. Alterando o n�vel de compatibilidade: O exemplo a seguir altera o n�vel de compatibilidade 
do banco de dados AdventureWorks2008R2 para 90, SQL Server 2005.*/

ALTER DATABASE AdventureWorks2008R2
SET COMPATIBILITY_LEVEL = 90;
GO

/*B. Efeito do n�vel de compatibilidade em ORDER BY (Cen�rio 1): O exemplo a seguir 
ilustra a diferen�a na associa��o ORDER BY para os n�veis de compatibilidade 80 e 100. 
O exemplo cria uma tabela de exemplo, SampleTable, no banco de dados tempdb.*/

USE tempdb;
CREATE TABLE SampleTable(c1 int, c2 int);
GO

/*Em n�veis de compatibilidade 90 e superior, no n�vel padr�o, 
a instru��o SELECT... ORDER BY a seguir produz um erro porque o alias de coluna na cl�usula 
AS, c1, � amb�guo.*/

SELECT c1, c2 AS c1
FROM SampleTable
ORDER BY c1;
GO

/*Depois de redefinir o banco de dados para o n�vel de compatibilidade 80, a mesma instru��o 
SELECT... ORDER BY ser� bem-sucedida.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1, c2 AS c1
FROM SampleTable
ORDER BY c1;
GO

/*A seguinte instru��o SELECT... ORDER BY funciona em ambos os n�veis de compatibilidade 
porque um alias inequ�voco � especificado na cl�usula AS.*/

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

/*C. Efeito do n�vel de compatibilidade em ORDER BY (Cen�rio 2): Em n�veis de compatibilidade 90 
e superior, no n�vel padr�o, a instru��o SELECT...ORDER BY a seguir produz um erro porque o 
alias de coluna especificado na cl�usula ORDER BY cont�m um prefixo de tabela.*/

SELECT c1 AS x
FROM SampleTable
ORDER BY SampleTable.x;
GO

/*Depois de redefinir o banco de dados para o n�vel de compatibilidade 80, a mesma instru��o 
SELECT...ORDER BY ser� bem-sucedida.*/

ALTER DATABASE tempdb
SET COMPATIBILITY_LEVEL = 80;
GO

SELECT c1 AS x
FROM SampleTable
ORDER BY SampleTable.x;
GO

/*A seguinte instru��o SELECT...ORDER BY funciona em ambos os n�veis de compatibilidade 
porque o prefixo de tabela foi removido da coluna alias especificada na cl�usula ORDER BY.*/

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