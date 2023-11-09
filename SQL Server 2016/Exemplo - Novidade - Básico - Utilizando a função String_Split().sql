-- Exemplo 1 � Separando de forma simples uma string �
SELECT * 
FROM STRING_SPLIT('Junior,Galv�o,MVP,SQL Server',',')
Go

-- Exemplo 2 � Fazendo uso de vari�veis como par�metros de entrada de valores �
DECLARE @string VARCHAR(100) = 'Microsoft,SQL Server,2016,RC0',
                @separador CHAR(1) =','

SELECT * 
FROM STRING_SPLIT(@string,@separador)
Go

-- Exemplo 3 � Armazenando o resultado da divis�o de uma string em uma nova tabela �
DECLARE @string VARCHAR(100) = 'Microsoft,SQL Server,2016,RC0',
        @separador CHAR(1) =','

SELECT * INTO #SplitTable
FROM STRING_SPLIT(@string,@separador)
GO

-- Visualizando a estrutura da tabela --
sp_Columns #SplitTable
Go

-- Consultando os dados da tabela --
Select * from #SplitTable
Go

-- Exemplo 4 � Apresentando a mensagem quando o separador de string for definido com mais de um caracter --
DECLARE @string VARCHAR(100) = 'pedrogalvaojunior#@gmail#@com',
                @separador CHAR(2) ='#@'

SELECT * FROM STRING_SPLIT(@string,@separador)
Go

-- Exemplo 5 � Apresentando o comportamento da String_Split() quando um par�metro apresenta valor nulo �
SELECT * FROM STRING_SPLIT('pedrogalvaojunior,wordpress,com',NULL)
Go

-- Exemplo 6 � Realizando o split de uma string com base na jun��o de uma tabela com a fun��o String_Split() �
-- Criando a tabela Split --
Create Table Split
( SplitId INT IDENTITY (1,1) NOT NULL,
  SplitValue1 NVARCHAR(50), 
  SplitValue2 NVARCHAR(50))
GO

-- Inserindo linhas de registro --
INSERT INTO Split (SplitValue1, SplitValue2)
VALUES ('Pedro','Galv�o'),
              ('Junior','Galv�o'),
              ('Antonio','Silva'),
			  ('Chico','Bento')
Go

-- Realizando a Jun��o da Tabela Split com a fun��o Split_String() --
Select SplitId, SplitValue1, SplitValue2, Value 
From Split S Inner Join String_Split('Pedro,Antonio',',') STS
				  On S.SplitValue1 = STS.Value
Go

-- Exemplo 7 � Apresentando o resultado quando ambos os par�metros vazios �
Select * from String_Split(' ',',')
Go

-- Exemplo 8 � Apresentando o comportamento da String_Split() quando o caracter do final da string � o mesmo utilizado como separador �
SELECT * FROM STRING_SPLIT('Conhecendo,SQL Server,2016,',',')
Go