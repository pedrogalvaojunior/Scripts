Use AdventureWorks2017
Go

-- Criando a Tabela Person com os dados j� existentes --
SELECT Identity(SmallInt,1,1) As Id,
      [PersonType]
      ,[NameStyle]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[Suffix]
      ,[EmailPromotion]
      ,[ModifiedDate]
Into CicloDeVida.dbo.Person
FROM [Person].[Person]
Go

-- Acessando o Banco de Dados --
Use CicloDeVida
Go

-- Ativando os contadores de IO e Time --
Set Statistics Time On
Set Statistics Io On
Go

-- Ativar plano de execu��o --

-- Exemplo 1 - Consulta NonSARgable -- Fun��o Left() na cl�usula Where --
Select FirstName From Person 
Where LEFT(FirstName,1)='K'
Go

-- Exemplo 1 - Consulta Sargable -- Utilizando o Operador Like --
Select FirstName From Person 
Where FirstName Like'K%'
Go

/* Ressaltar as pequenas diferen�as entre os n�meros: 
- Estimated Number Of Rows
- Estimated Number Of Rows to Read

- Number Of Rows Read 
- Actual Number Of Rows */

/*Essas fun��es criam os mesmos planos de execu��o nas mesmas condi��es: 
 SUBSTRING(), LEFT(), LTRIM(), RTRIM(), User defined functions 

 Para utilizar estas fun��es de obter um melhor desempenho, seria necess�rio criar �ndices fazendo uso das fun��es */

-- Vamos melhorar mais ainda, agora criando o �ndice e reprocessar a querys --
Create NonClustered  Index [NonClustered_FirstName] On Person ([FirstName] ASC)
Go

-- Exemplo 2 - NonSARgable -- Utilizando a fun��o Year() --
Select ModifiedDate From Person
Where YEAR(ModifiedDate) = 2009
Go

-- Exemplo 2 - SARgable -- Utilizando o Operador Between  --
Select ModifiedDate From Person
Where ModifiedDate Between '20090101' And '20091231'
Go

-- Vamos melhorar mais ainda, agora criando o �ndice e reprocessar a querys --
Create NonClustered  Index [NonClustered_ModifiedDate] On Person ([ModifiedDate] ASC)
Go

-- Aqui vamos fazer uso do Include Client Statistics para acompanhar os desempenhos --

-- Exemplo 3 - NonSARgable -- Utilizando fun��o IsNull na cl�usula Where --
Select MiddleName From Person 
Where IsNull(MiddleName,'E') ='E'
Go

-- Exemplo 3 - SARgable -- Utilizando o Operador Is Null --
Select MiddleName From Person 
Where MiddleName Is Null Or MiddleName = 'E'
Go

-- Vamos melhorar mais ainda, agora criando o �ndice e reprocessar a querys --
Create NonClustered  Index [NonClustered_MiddleName] On Person ([MiddleName] ASC)
Go

