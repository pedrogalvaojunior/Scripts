CREATE DATABASE [Exemplo] 
go

USE [Exemplo]
GO
-- Cria a Tabela de Relacionamento a ser Verificada
CREATE TABLE [dbo].[Estados](
	[id] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[Estado] [char](2) NULL)
GO

-- Esse Insert deve funcionar 
insert into Estados (Estado) values ('RS'), ('SP')

-- Cria Tabela
CREATE TABLE [dbo].[Clientes](
	[Id] [int] IDENTITY(1,1) NOT NULL Primary Key,
	[Nome] [varchar](50) NULL,
	[idEstado] [int] NULL)
go

-- Cria a Function para Verificação
create function [dbo].[VerificaEstado](@idEstado int)
returns int
as 
begin
    -- VErifica se o estado existe na tabela de Estados
    return (select id from Estados where id = @idEstado) 
end
GO

-- Implementa a Function
ALTER TABLE [dbo].[Clientes]  WITH CHECK 
ADD  CONSTRAINT [chk_VerificaEstado] 
CHECK  (([dbo].[VerificaEstado]([idEstado]) IS NOT NULL))
GO

ALTER TABLE [dbo].[Clientes] 
CHECK CONSTRAINT [chk_VerificaEstado]
GO

-- Esse Insert Deve Funcionar
insert into Clientes (Nome, idEstado) values ('Roberto Fonseca', 1)
-- Esse Insert Tem que dar Erro de Constrant de Check Violada
insert into Clientes (Nome, idEstado) values ('Tem que Dar Erro', 3)

select * from Clientes

use master
go
drop database exemplo
go