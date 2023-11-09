-- Parte 1: Verificando a existência das Tabelas --
If Exists(Select Object_Id('Tabela1'))
 Begin 
  Drop Table Tabela1 

  CREATE TABLE Tabela1 
   (Coluna1 INT, 
    Coluna2 INT, 
    Coluna3 INT)
 End
 Else
  Begin
   CREATE TABLE Tabela1 
    (Coluna1 INT, 
     Coluna2 INT, 
     Coluna3 INT)
  End  

If Exists(Select Object_Id('Tabela2'))
 Begin
  Drop Table Tabela2 

  CREATE TABLE Tabela2 
   (Coluna1 INT, 
    Coluna2 INT, 
    Coluna3 INT)
 End
 Else
  Begin
   CREATE TABLE Tabela2 
    (Coluna1 INT, 
     Coluna2 INT, 
     Coluna3 INT)
  End   
 
If Exists(Select Object_Id('Tabela3'))
 Begin
  Drop Table Tabela3 

  CREATE TABLE Tabela3 
   (Coluna1 INT, 
    Coluna2 INT, 
    Coluna3 INT)
 End
  Else
  Begin
   CREATE TABLE Tabela3 
    (Coluna1 INT, 
     Coluna2 INT, 
     Coluna3 INT)
  End  
  
-- Parte 2: Inserindo os registros --
INSERT INTO Tabela1 VALUES (1, 2, 3)
INSERT INTO Tabela1 VALUES (0, 7, 9)
INSERT INTO Tabela1 VALUES (3, 4, 2)

INSERT INTO Tabela2 VALUES (2, 2, 2)
INSERT INTO Tabela2 VALUES (3, 9, 5)
INSERT INTO Tabela2 VALUES (1, 6, 8)

INSERT INTO Tabela3 VALUES (4, 0, 7)
INSERT INTO Tabela3 VALUES (6, 5, 1)
INSERT INTO Tabela3 VALUES (4, 7, 9) 

-- Parte 3: Declarando as variáveis --
DECLARE @Comando VARCHAR(1000), 
                @ComandoTransact VARCHAR(100), 
                @ValordePesquisa INT,
                @TABLE_NAME VARCHAR(20), 
                @Coluna_NAME VARCHAR(20)

Set @Comando = '' 
Set @TABLE_NAME = '' 
Set @Coluna_NAME = ''

Set @ComandoTransact = 'SELECT ''?'', ''^'', COUNT(*) AS TOTAL FROM ? WHERE ^ = @ UNION ALL' + CHAR(10)

Set @ValordePesquisa = 3 -- Informe o valor a ser pesquisado no Mecanismo.

-- Parte 4: Declarando o CursordePesquisa para retornar o nome da tabela e nome da Coluna --
DECLARE CursordePesquisa CURSOR FAST_FORWARD
FOR SELECT TABLE_NAME, Column_Name FROM INFORMATION_SCHEMA.Columns

-- Abrindo o CursordePesquisa --
OPEN CursordePesquisa
FETCH NEXT FROM CursordePesquisa INTO @TABLE_NAME, @Coluna_NAME

-- Parte 5: Iniciando o bloco condicional While --
WHILE @@FETCH_STATUS = 0
 BEGIN

  SET @Comando = @Comando + REPLACE(REPLACE(REPLACE(@ComandoTransact,'?',@TABLE_NAME),'^',@Coluna_NAME),'@',@ValordePesquisa)
  FETCH NEXT FROM CursordePesquisa 
  INTO @TABLE_NAME, @Coluna_NAME
 END

-- Parte 6: Realizando a Concatenação e União dos Selects --
SET @Comando = LEFT(@Comando,LEN(@Comando)-LEN('UNION ALL')-2)

-- Parte 7: Criando a Tabela Temporária para armazenar os Resultados --
CREATE TABLE #Resultados 
 (NomeTabela Varchar(20), 
  NomeColuna VARCHAR(20), 
  TotaldeRegistros INT)

-- Inserindo os dados na tabela Resultados com base na execução do @Comando --
INSERT INTO #Resultados 
Exec (@Comando)

-- Encerrando o Cursor --
CLOSE CursordePesquisa
DEALLOCATE CursordePesquisa

-- Apresentando os dados --
SELECT * FROM #Resultados

-- Excluíndo a Tabela Temporária Resultados --
DROP TABLE #Resultados