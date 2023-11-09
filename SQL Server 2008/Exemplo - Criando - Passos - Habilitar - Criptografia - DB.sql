--Acesssando o Banco de Dados Master--
Use master
Go

-- Criando a Master Key Encryption --
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ABC123';
Go

-- Criando o Certificado de Criptografia --
CREATE CERTIFICATE CertificadoSeguranca
  WITH SUBJECT = 'Certificado - Segurança - Criptografia'
Go

--Consultando a relação de Certificados--
SELECT * FROM SYS.certificates  

--Criando um novo Banco para Aplicar o Certificado--
Create Database Criptografia
Go

--Acessando o Banco de Dados Criptografia--
Use Criptografia
Go

-- Criando a Chave de Criptografia para Banco de Dados com o Certificado --
CREATE DATABASE ENCRYPTION KEY 
WITH ALGORITHM = AES_256 
ENCRYPTION BY SERVER CERTIFICATE CertificadoSeguranca;
GO 

--Acessando o Banco de Dados Master para realizar o backup do Certificado--
Use Master
Go

-- Realizando Backup do Certificado de Criptografia --
BACKUP CERTIFICATE CertificadoSeguranca
 TO FILE = 'C:\SQL\CertificadoSeguranca.cer'
 WITH PRIVATE KEY ( FILE = 'C:\SQL\CertificadoSeguranca.pvk', 
 ENCRYPTION BY PASSWORD = 'ABC123');

-- Habilitando o Banco de Dados Criptografia para ser utilizado como Banco Criptografado--
ALTER DATABASE Criptografia
SET ENCRYPTION ON;
GO 

-- Verificando o andamento da criptografia --
SELECT DB_NAME(DBE.database_id) AS 'Banco de Dados', 
            DBE.database_id As ID, 
            Convert(Varchar(2),DBE.encryption_state)  + ' - ' +
    CASE DBE.encryption_state 
                WHEN 0 THEN 'Criptografia de Banco de Dados não esta ativa' 
                WHEN 1 THEN 'Descriptografado' 
                WHEN 2 THEN 'Criptografia em progresso' 
                WHEN 3 THEN 'Criptografado' 
                WHEN 4 THEN 'Mudança de Chave de Criptografia em progresso' 
                WHEN 5 THEN 'Processo de Descriptografia em progresso' 
    END As 'Descrição da Criptografia', 
            Cert.name As 'Nome do Certificado',
            DBE.percent_complete As 'Porcetagem'
    FROM sys.dm_database_encryption_keys AS DBE 
    LEFT JOIN master.sys.certificates AS Cert
    ON DBE.encryptor_thumbprint = Cert.thumbprint 

--Excluíndo a Chave Simétrica--
DROP SYMMETRIC KEY NomedaSuaChave
Go

--Excluíndo Certificado --
Drop Certificate NomedoSeuCertificado
Go

--Excluíndo a Chave Mestre de Criptografia --
DROP MASTER KEY;
Go

