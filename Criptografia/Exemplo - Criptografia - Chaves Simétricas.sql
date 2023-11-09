-- Criando o Banco de Dados --
Create Database Criptografia
Go

-- Acessando o Banco de Dados --
USE CRIPTOGRAFIA
Go

-- CRIANDO UMA CHAVE MESTRE DE CRIPTOGRAFIA --
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'P@ssword';
GO

-- Verificando se o banco de dados esta pronto para trabalhar com criptografia de dados através de Chaves --
Select name, is_master_key_encrypted_by_server 
from Sys.databases
Where name in('Criptografia','Master')
Go

-- Criando a Chave Simétrica utilizando o Algoritom Triple_DES --
CREATE SYMMETRIC KEY ChaveSimetrica
WITH ALGORITHM = TRIPLE_DES
ENCRYPTION BY PASSWORD = 'P@ssw0rd1'

-- Lista de Chaves Simétricas Criadas --
Select name, symmetric_key_id, key_algorithm, algorithm_desc 
from sys.symmetric_keys

-- Criando a Tabela TabelaCriptografada --
CREATE TABLE TabelaCriptografada
(Codigo int, 
  Descricao VarChar(100))
Go  

-- Abrindo a Chave Simétrica --
OPEN SYMMETRIC KEY ChaveSimetrica 
DECRYPTION BY Password = 'P@ssw0rd1'
Go

-- Inserindo os Dados  --
INSERT INTO TabelaCriptografada(Codigo,Descricao)
Values(1, EncryptByKey(Key_GUID('ChaveSimetrica'),'Pedro')) 
Go

-- Consultando a tabela --
Select Codigo, Descricao from TabelaCriptografada 
Go

-- Fechando a Chave Simétrica --
CLOSE SYMMETRIC KEY ChaveSimetrica 
Go 

-- Alterando a Tabela --
Alter Table TabelaCriptografada
 Add DadosCriptografados VarBinary(100)
Go

-- Abrindo a Chave Simétrica --
OPEN SYMMETRIC KEY ChaveSimetrica 
DECRYPTION BY Password = 'P@ssw0rd1'
Go

-- Atualizando dados  --
Update TabelaCriptografada
Set DadosCriptografados = 
EncryptByKey(Key_GUID('ChaveSimetrica'),'Pedro')
Go

-- Consultando a tabela --
Select Codigo,Descricao, DadosCriptografados from TabelaCriptografada 
Go

-- Fechando a Chave Simétrica --
CLOSE SYMMETRIC KEY ChaveSimetrica 
Go 