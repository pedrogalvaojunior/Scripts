-- Criando a Tabela para armazenar os Dados --
Create Table ASCIITable
(CodeASCII VarChar(20),
 ColumnDec VarChar(20),
 ColumnHex VarChar(20),
 ColumnOct VarChar(20),
 ColumnBin VarChar(20))
Go

-- Lendo os dados diretos no formato VarBinary --
Select * FROM OPENROWSET(  
   BULK 'S:\CoolTermWin\Capture.txt',  
   SINGLE_BLOB) AS x
Go

-- Lendo os dados no formato formato Varchar() --
Select * FROM OPENROWSET(  
   BULK 'S:\CoolTermWin\Capture.txt',  
   SINGLE_CLOB) AS x
Go

-- Inserindo os dados na tabela ASCIITable --
BULK INSERT ASCIITable 
FROM 'S:\CoolTermWin\Capture.txt'
WITH
(DATAFILETYPE = 'char',
 FIELDTERMINATOR = ', ', 
 ROWTERMINATOR = '\n',
 FIRSTROW = 1
)
Go

-- Lendo os dados --
Select * From ASCIITable
Go

Truncate Table ASCIITable