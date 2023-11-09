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

-- Declarando o bloco para inserção de 2.000.000 registros --
DECLARE @i INT
SET @i = 1 

WHILE (@i < 2000000)
BEGIN
     INSERT INTO Clientes 
	 VALUES (@i,'João da Cunha Costa e Silva Mendes','M', '19780101','79985421240','Brasília','DF', '70360-123',4570.32,'20110106')

     SET @i = @i + 1
END

--Insere o cliente 2.000.000 --
INSERT INTO Clientes VALUES (2000000,'Flávia Gomides Arnaldo Ferreira Costa','F','19790331','70034267890','Brasília','DF','70231030',7832.46,GETDATE())

-- Criando um índice na coluna data de cadastro vinculado com a Tabela Clientes --
CREATE INDEX IX_DataCadastro ON Clientes (DataCadastro)

-- Cenário 1 - Utilizando a Função DateDiff no Where --
-- Atividando Estatísticas de IO --
SET STATISTICS IO ON

-- Atividar exibição do plano de Execução --

-- Consultando os Dados fazendo uso da Função DateDiff no Where --
SELECT * FROM Clientes WHERE DateDIFF(dd,DataCadastro,GETDATE()) < 30

-- Consultando os Dados fazendo o Cálculo da diferença da Data --
SELECT * FROM Clientes WHERE DataCadastro > DateADD(dd,-30,GETDATE())
Go

-- Cenário 2 - Utilizando a Função Convert no Where --
SELECT * FROM Clientes WHERE DataCadastro = '2011-07-02'
Go

SELECT * FROM Clientes WHERE CONVERT(CHAR(10),DataCadastro,103) = '02/07/2011'
Go

-- Opção ruim --
SELECT * FROM Clientes WHERE CONVERT(CHAR(10),DataCadastro,103) = '02/07/2011'

-- Opções Melhores --
SELECT * FROM Clientes WHERE DataCadastro >= '20110702' And DataCadastro < '20110703'
SELECT * FROM Clientes WHERE DataCadastro BETWEEN '20110702' And '20110702 23:59.999'

-- Opção mais indicada --
SELECT * FROM Clientes
WHERE DataCadastro >= CONVERT(CHAR(8),GETDATE(),112) 
And   DataCadastro < CONVERT(CHAR(8),GETDATE()+1,112)

-- Opção criativa, mas não muito indicado se analisarmos a performance --
SELECT * FROM Clientes
WHERE YEAR(DataCadastro) = YEAR(GETDATE()) 
And   MONTH(DataCadastro) = MONTH(GETDATE()) 
And   DAY(DataCadastro) = DAY(GETDATE())

-- Cenário 3 - Utilizando SUBSTRING, LEFT, LTRIM e funções textuais --
-- Opções ruins --
SELECT * FROM Clientes WHERE SUBSTRING(Nome,1,1) = 'F'

SELECT * FROM Clientes WHERE LEFT(Nome,1) = 'F'

SELECT * FROM Clientes WHERE SUBSTRING(Nome,1,1) = 'F'
Go

-- Opção melhor --
SELECT * FROM Clientes WHERE Nome LIKE 'F%'
Go

-- Utilizando Ltrim e Rtrim --
-- Atualiza o registro “Flávia Gomides”
UPDATE Clientes 
SET Nome = 'Flávia Gomides Arnaldo Ferreira Costa'
WHERE ID = 2000000 

-- Cuidado com o LTRIM ou RTRIM -- Faz a pesquisa retirando os espaços em branco --
SELECT * FROM Clientes WHERE LTRIM(Nome) LIKE 'F%'


-- Cenário 4 - User Defined Functions --
/* A partir da versão 2000, o SQL Server permite a construção de funções próprias ao invés das funções já existentes. 
Será que essas funções vão utilizar da mesma lógica ?*/

-- Cria uma função para verificar se a renda é maior que 5.000 --
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

-- Criando um índice sobre a coluna Renda vinculada a tabela Clientes --
CREATE INDEX IX_Renda ON Clientes (Renda) 

-- Consulta os clientes com Renda superior a 5000 --
-- Opção mais indicada --
SELECT * FROM Clientes WHERE Renda > 5000
Go

-- Opção ruim --
SELECT * FROM Clientes WHERE dbo.FnRendaMaior5000(Renda) = 1
Go

-- Cenário 5 - Expressões e colunas --
-- Opção mais indicada --
SELECT * FROM Clientes WHERE Renda - 2800 >= 2000
Go

-- Opção ruim --
SELECT * FROM Clientes WHERE Renda >= 4800
Go

-- Cenário 6 - Analogias a JOINs --
-- Cria uma tabela com a coluna DataCadastro e um código promocional --
CREATE TABLE Promocoes 
(DataCadastro CHAR(10), -- Cuidado em utilizar data como char
 Desconto DECIMAL(5,2)) 

-- Insere um registro para a promoção de hoje --
INSERT INTO Promocoes VALUES (CONVERT(CHAR(10),GETDATE(),103),0.1) 

-- Opção ruim - Verifica os clientes elegíveis para o desconto de hoje --
SELECT C.*, 
       P.Desconto 
FROM Clientes As C INNER JOIN Promocoes As P
                    ON CONVERT(CHAR(10),C.DataCadastro,103) = P.DataCadastro


-- Opção um pouco melhor - Verifica os clientes elegíveis para o desconto de hoje --
SELECT C.*, 
       P.Desconto 
FROM Clientes As C INNER JOIN Promocoes As P 
                    ON CONVERT(CHAR(10),C.DataCadastro,103) = P.DataCadastro
Go

-- Opção um pouco mais indicada --
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

-- Cenário 7 - Analogias a JOINs -- Incompatibilidades entre Collations --
-- Cria uma tabela de Clientes VIPs --
CREATE TABLE ClientesVIPs 
(Nome VARCHAR(100)
 COLLATE Latin1_General_CS_AS NOT NULL,
 Desconto DECIMAL(5,2))
Go

-- Insere um registro --
INSERT INTO ClientesVIPs 
VALUES ('Flávia Gomides Arnaldo Ferreira Costa',0.1) 
Go

-- Retorna os dados dos Clientes VIPs --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
                             ON C.Nome = CV.Nome
Go

--Como a collation das colunas é diferente, a consulta não conseguirá ser executada


-- Retorna os dados dos Clientes VIPs (converte a tabela Clientes) --
-- Opções ruins --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
							 ON C.Nome COLLATE Latin1_General_CS_AS = CV.Nome 
Go

-- Retorna os dados dos Clientes VIPs (converte a tabela ClientesVIP) --
SELECT * FROM Clientes As C INNER JOIN ClientesVIPs As CV 
                             ON C.Nome = CV.Nome COLLATE Latin1_General_CI_AI
Go

-- Retorna os dados dos Clientes VIPs (converte a tabela ClientesVIP) --
-- Força o índice -- Pior opção --
SELECT * FROM Clientes As C WITH (INDEX=IX_Nome) INNER JOIN ClientesVIPs As CV 
												  ON C.Nome = CV.Nome COLLATE Latin1_General_CI_AI
Go

-- Subquery --
-- Opção um pouco melhor --
SELECT * FROM Clientes As C
WHERE Nome IN (SELECT CAST(Nome As VARCHAR(100)) COLLATE Latin1_General_CI_AI
               FROM ClientesVIPs)

-- Subquery com índice forçado -- Pior opção --
SELECT * FROM Clientes As C WITH (INDEX=IX_Nome)
WHERE Nome IN (SELECT CAST(Nome As VARCHAR(100)) COLLATE Latin1_General_CI_AI
               FROM ClientesVIPs)