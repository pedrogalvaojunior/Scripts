-- Criando a Tabela Clientes --
Create TABLE Clientes 
(
  ID INT NOT NULL,
  Nome VARCHAR(100) NOT NULL,
  Sexo CHAR(1) NOT NULL,
  DataNascimento DATETIME NOT NULL,
  CPF CHAR(11) NOT NULL,
  Cidade VARCHAR(100) NOT NULL,
  UF CHAR(2) NOT NULL,
  CEP CHAR(9) NOT NULL,
  Renda MONEY NOT NULL,
  DataCadastro DATETIME NOT NULL)
Go

-- Declarando o bloco para inser��o de 2.000.000 registros --
DECLARE @i INT
SET @i = 1 

WHILE (@i < 2000000)
BEGIN
     INSERT INTO Clientes 
	 VALUES (@i,'Jo�o da Cunha Costa e Silva Mendes','M', '19780101','79985421240','Bras�lia','DF', '70360-123',4570.32,'20110106')

     SET @i = @i + 1
END

--Insere o cliente 2.000.000 --
INSERT INTO Clientes VALUES (2000000,'Fl�via Gomides Arnaldo Ferreira Costa','F','19790331','70034267890','Bras�lia','DF','70231030',7832.46,GETDATE())

-- Criando um �ndice na coluna data de cadastro vinculado com a Tabela Clientes --
CREATE INDEX IX_DataCadastro ON Clientes (DataCadastro)

-- Cen�rio 1 - Utilizando a Fun��o DateDiff no Where --
-- Atividando Estat�sticas de IO --
SET STATISTICS IO ON

-- Atividar exibi��o do plano de Execu��o --

-- Consultando os Dados fazendo uso da Fun��o DateDiff no Where --
SELECT * FROM Clientes WHERE DateDIFF(dd,DataCadastro,GETDATE()) < 30

-- Consultando os Dados fazendo o C�lculo da diferen�a da Data --
SELECT * FROM Clientes WHERE DataCadastro > DateADD(dd,-30,GETDATE())
Go

-- Cen�rio 2 - Utilizando a Fun��o Convert no Where --
SELECT * FROM Clientes WHERE DataCadastro = '2011-07-02'
Go

SELECT * FROM Clientes WHERE CONVERT(CHAR(10),DataCadastro,103) = '02/07/2011'
Go

-- Op��o ruim --
SELECT * FROM Clientes WHERE CONVERT(CHAR(10),DataCadastro,103) = '02/07/2011'

-- Op��es Melhores --
SELECT * FROM Clientes WHERE DataCadastro >= '20110702' And DataCadastro < '20110703'
SELECT * FROM Clientes WHERE DataCadastro BETWEEN '20110702' And '20110702 23:59.999'

-- Op��o mais indicada --
SELECT * FROM Clientes
WHERE DataCadastro >= CONVERT(CHAR(8),GETDATE(),112) 
And   DataCadastro < CONVERT(CHAR(8),GETDATE()+1,112)

-- Op��o criativa, mas n�o muito indicado se analisarmos a performance --
SELECT * FROM Clientes
WHERE YEAR(DataCadastro) = YEAR(GETDATE()) 
And   MONTH(DataCadastro) = MONTH(GETDATE()) 
And   DAY(DataCadastro) = DAY(GETDATE())

-- Cen�rio 3 - Utilizando SUBSTRING, LEFT, LTRIM e fun��es textuais --
-- Op��es ruins --
SELECT * FROM Clientes WHERE SUBSTRING(Nome,1,1) = 'F'

SELECT * FROM Clientes WHERE LEFT(Nome,1) = 'F'

SELECT * FROM Clientes WHERE SUBSTRING(Nome,1,1) = 'F'
Go

-- Op��o melhor --
SELECT * FROM Clientes WHERE Nome LIKE 'F%'
Go

-- Utilizando Ltrim e Rtrim --
-- Atualiza o registro �Fl�via Gomides�
UPDATE Clientes 
SET Nome = 'Fl�via Gomides Arnaldo Ferreira Costa'
WHERE ID = 2000000 

-- Cuidado com o LTRIM ou RTRIM -- Faz a pesquisa retirando os espa�os em branco --
SELECT * FROM Clientes WHERE LTRIM(Nome) LIKE 'F%'


-- Cen�rio 4 - User Defined Functions --
/* A partir da vers�o 2000, o SQL Server permite a constru��o de fun��es pr�prias ao inv�s das fun��es j� existentes. 
Ser� que essas fun��es v�o utilizar da mesma l�gica ?*/

-- Cria uma fun��o para verificar se a renda � maior que 5.000 --
CREATE FUNCTION dbo.FnRendaMaior5000 (@Renda MONEY)
RETURNS TINYINT
As
BEGIN
 DECLARE @bRendaMaior5000 TINYINT
     
 SET @bRendaMaior5000 = 0
     
 IF @Renda > 5000
 SET @bRendaMaior5000 = 1
     
 RETURN(@bRendaMaior5000)
END
GO 

-- Criando um �ndice sobre a coluna Renda vinculada a tabela Clientes --
CREATE INDEX IX_Renda ON Clientes (Renda) 

-- Consulta os clientes com Renda superior a 5000 --
-- Op��o mais indicada --
SELECT * FROM Clientes WHERE Renda > 5000
Go

-- Op��o ruim --
SELECT * FROM Clientes WHERE dbo.FnRendaMaior5000(Renda) = 1
Go

-- Cen�rio 5 - Express�es e colunas --
-- Op��o mais indicada --
SELECT * FROM Clientes WHERE Renda - 2800 >= 2000
Go

-- Op��o ruim --
SELECT * FROM Clientes WHERE Renda >= 4800
Go

-- Cen�rio 6 - Analogias a JOINs --
-- Cria uma tabela com a coluna DataCadastro e um c�digo promocional --
CREATE TABLE Promocoes 
(DataCadastro CHAR(10), -- Cuidado em utilizar data como char
 Desconto DECIMAL(5,2)) 

-- Insere um registro para a promo��o de hoje --
INSERT INTO Promocoes VALUES (CONVERT(CHAR(10),GETDATE(),103),0.1) 

-- Op��o ruim - Verifica os clientes eleg�veis para o desconto de hoje --
SELECT C.*, 
       P.Desconto 
FROM Clientes As C INNER JOIN Promocoes As P
                    ON CONVERT(CHAR(10),C.DataCadastro,103) = P.DataCadastro


-- Op��o um pouco melhor - Verifica os clientes eleg�veis para o desconto de hoje --
SELECT C.*, 
       P.Desconto 
FROM Clientes As C INNER JOIN Promocoes As P 
                    ON CONVERT(CHAR(10),C.DataCadastro,103) = P.DataCadastro
Go

-- Op��o um pouco mais indicada --
SELECT C.*, 
       P.Desconto 
FROM Clientes As C INNER JOIN Promocoes As P 
                    ON C.DataCadastro >=
                        CAST(RIGHT(P.DataCadastro,4) + 
                             SUBSTRING(P.DataCadastro,4,2) +
                             LEFT(P.DataCadastro,2) As DateTime) 
					And C.DataCadastro < CAST(
                             RIGHT(P.DataCadastro,4) +
                             SUBSTRING(P.DataCadastro,4,2) +
                             LEFT(P.DataCadastro,2) As DateTime) + 1
Go

-- Cen�rio 7 - Analogias a JOINs -- Incompatibilidades entre Collations --
-- Cria uma tabela de Clientes VIPs --
CREATE TABLE ClientesVIPs 
(Nome VARCHAR(100)
 COLLATE Latin1_General_CS_AS NOT NULL,
 Desconto DECIMAL(5,2))
Go

-- Insere um registro --
INSERT INTO ClientesVIPs 
VALUES ('Fl�via Gomides Arnaldo Ferreira Costa',0.1) 
Go

-- Retorna os dados dos Clientes VIPs --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
                             ON C.Nome = CV.Nome
Go

--Como a collation das colunas � diferente, a consulta n�o conseguir� ser executada


-- Retorna os dados dos Clientes VIPs (converte a tabela Clientes) --
-- Op��es ruins --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
							 ON C.Nome COLLATE Latin1_General_CS_AS = CV.Nome 
Go

-- Retorna os dados dos Clientes VIPs (converte a tabela ClientesVIP) --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
                             ON C.Nome = CV.Nome COLLATE Latin1_General_CI_AI
Go

-- Retorna os dados dos Clientes VIPs (converte a tabela ClientesVIP) --
-- For�a o �ndice -- Pior op��o --
SELECT * FROM Clientes As C WITH (INDEX=IX_Nome) INNER JOIN ClientesVIPs As CV 
												  ON C.Nome = CV.Nome COLLATE Latin1_General_CI_AI
Go

-- Subquery --
-- Op��o um pouco melhor --
SELECT * FROM Clientes As C
WHERE Nome IN (SELECT CAST(Nome As VARCHAR(100)) COLLATE Latin1_General_CI_AI
               FROM ClientesVIPs)

-- Subquery com �ndice for�ado -- Pior op��o --
SELECT * FROM Clientes As C WITH (INDEX=IX_Nome)
WHERE Nome IN (SELECT CAST(Nome As VARCHAR(100)) COLLATE Latin1_General_CI_AI
               FROM ClientesVIPs)