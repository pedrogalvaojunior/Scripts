-- Criando o Banco de Dados --
CREATE DATABASE TestAuditDB;
Go

-- Acessando --
USE TestAuditDB;
Go

-- Criando o Schema --
CREATE SCHEMA MySchemaAudit;
Go

-- Criando a Tabela MySchemaAudit.Produtos --
Create Table MySchemaAudit.Produtos
(Codigo Int Identity(1,1),
  Descricao VarChar(20),
  Saldo Int)
Go

-- Criando a Tabela MySchemaAudit.Movimentacao --
Create Table MySchemaAudit.Movimentacao
(Codigo Int Identity(1,1),
  CodProduto Int,
  TipoMovimentacao Char(1),
  Valor Int)
Go

-- Acessando o Banco de Dados Master --
USE master;
Go

-- Criando o Server Audit no Banco de Dados de Sistema - Master --
Create Server Audit MyServerAudit
    TO FILE ( FILEPATH ='C:\AuditSQL\')
Go

-- Ativando o Server Audit após a sua criação --
Alter Server Audit MyServerAudit WITH (STATE = ON);
Go

-- Criando o Database Audit Specification no Banco de Dados TestAuditDB --
USE TestAuditDB;
Go

-- MyDatabaseAudit --
Create Database AUDIT SPECIFICATION MyDatabaseAudit
For Server AUDIT MyServerAudit 
Add (Select On Schema::MySchemaAudit BY public),
Add (Insert On Schema::MySchemaAudit BY public)
With (State = On);
Go

-- Trigger the audit event by selecting from tables
SELECT ID, DataField FROM SchemaAudit.GeneralData;

SELECT ID, DataField FROM SchemaAudit.SensitiveData;
Go

-- Check the audit for the filtered content
SELECT * FROM fn_get_audit_file('C:\AuditSQL\MyServer*.sqlaudit',default,default);
Go

select * from sys.server_audits 
select * from sys.server_file_audits 
select * from sys.server_audit_specifications 
select * from sys.server_audit_specification_details 
select * from sys.database_audit_specifications 
select * from sys.database_audit_specification_details 
select * from sys.dm_server_audit_status 
select * from sys.dm_audit_actions 
select * from sys.dm_audit_class_type_map 

