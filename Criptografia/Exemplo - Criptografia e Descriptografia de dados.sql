CREATE DATABASE CRIPTOGRAFIA

USE CRIPTOGRAFIA

CREATE TABLE MeusDadosCriptografados
 (Codigo Int Identity(1,1) Primary Key,
   Descricao Varchar(10),
   ValorOriginal VarChar(20) Not Null,
   ValorCriptografado VarBinary(256)) 

Insert Into MeusDadosCriptografados (Descricao,ValorOriginal)
Values ('Frase','Oi Mundo')
   
Insert Into MeusDadosCriptografados (Descricao,ValorOriginal)
Values ('Frase','Este � um Teste')


Select * from MeusDadosCriptografados

-- Criptografando os dados utilizando a fun��o EncryptByPassPhrase --   
DECLARE @Frase NVarChar(256)
SET @Frase = 'Esta ser� a frase utilizada na criptografia dos dados';

UPDATE MeusDadosCriptografados
SET ValorCriptografado = EncryptByPassPhrase(@Frase, ValorOriginal)

Select * from MeusDadosCriptografados

-- Descriptografando os dados utilizando a fun��o DecryptByPassPhrase --
DECLARE @Frase NVarChar(256)
SET @Frase = 'Esta ser� a frase utilizada na criptografia dos dados';

Select Convert(VarChar(Max),DecryptByPassPhrase(@Frase, ValorCriptografado))
from MeusDadosCriptografados

Select * from MeusDadosCriptografados