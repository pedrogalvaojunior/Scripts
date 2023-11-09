-- Criando o Banco de Dados DBMonitor --
Create Database DBMonitor
Go

-- Acessando o Banco de Dados DBMonitor --
Use DBMonitor
Go

-- Criando a Tabela Funcionarios --
CREATE TABLE Funcionarios
(ID Int IDENTITY(1,1) PRIMARY KEY, 
 Nome VarChar(30), 
 Salario Numeric(18,2))
Go

-- Inserindo a massa de dados na Tabela Funcionarios --
DECLARE @Contador SmallInt

SET @Contador = 1

WHILE @Contador <= 1000 
 BEGIN 

  INSERT INTO Funcionarios(Nome, Salario) 
  SELECT 'Junior Galv�o', ABS(CONVERT(Numeric(18,2), (CheckSUM(NEWID()) / 500000.0))) 

  SET @Contador = @Contador + 1 

END 

/* Sobre o Halloween problema: Era Halloween, a noite estava fria no penoso inverno(sei l� se era inverno :-), inclui para dar um ar de drama) de 1976, crian�as pediam 
�tricks and treats� nas casas. Enquanto isso em um lugar n�o muito distante dali, foi rodado um update em um banco de dados, para atualizar em 10% o sal�rio de todos 
funcion�rios que ganhavam menos de $ 25.000,00. 

Assim come�a a hist�ria de um problema conhecido por �Halloween Problem�, engenheiros da IBM http://www.mcjones.org/System_R/SQL_Reunion_95/sqlr95-System.html#Index197
foram os primeiros a encontrar o problema, e a partir de ent�o, ao longo dos anos, v�rios banco de dados sofreram com problemas semelhantes, 
inclusive nosso querido SQL Server como pode ser percebido aqui: http://support.microsoft.com/search/default.aspx?query=Halloween&mode=r&catalog=LCID%3D1033

O problema consiste em utilizar um �ndice nonclustered para atualizar uma determinada coluna, e pode ocorrer de uma mesma linha ser atualizada v�rias vezes. 
 */


-- Atualizando o sal�rio dos Funcion�rios --
UPDATE Funcionarios 
SET Salario = Salario * 1.1 
FROM Funcionarios 
WHERE Salario < 2000 
Go

 -- Simulando o Eager Spool e Halloween Problem --
Create NonClustered Index IX_Salario On Funcionarios(Salario)
Go

UPDATE Funcionarios 
SET Salario = Salario * 1.1 
FROM Funcionarios WITH(INDEX=ix_Salario) 
WHERE Salario < 2000 
Go