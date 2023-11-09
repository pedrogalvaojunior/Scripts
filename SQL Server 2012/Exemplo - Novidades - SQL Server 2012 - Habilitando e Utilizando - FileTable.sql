-- Habilitando - Funcionalidade - FileStream --
EXEC sp_configure filestream_access_level, 2
RECONFIGURE WITH OVERRIDE
Go

-- Criando - Banco de Dados - Com Suporte FileTable--
CREATE DATABASE Cars 
ON PRIMARY 
 (NAME = Cars_data, 
  FILENAME = 'C:\Bancos\FileTablesDemo\Cars.mdf'),
FILEGROUP CarsFSGroup CONTAINS FILESTREAM -- Especificando o FileGroup com FileStream
 (NAME = Cars_FS, 
  FILENAME = 'C:\Bancos\FileTablesDemo\CarsFileStream') -- Informando o caminho fo FileStream
LOG ON (NAME = 'Cars_log', 
 FILENAME = 'C:\Bancos\FileTablesDemo\Cars_log.ldf');        
GO

-- Enable Non-Transactional Access at the Database Level --
Use Cars

ALTER DATABASE Cars
SET FILESTREAM (NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'CarsDataFS')

-- Criando - FileTable --
CREATE TABLE CarsDocStore AS FileTable
GO

-- Display all default Attributes --
Select * from dbo.carsDocStore

-- Abrir FileTable Directory --

-- Criar os Arquivos --
/*AudiA6.txt
BuickRegal.txt
FordMustangGT.txt

-- Each file contains the following items for each car:

Model Year
Mileage
Body Style
Engine
Exterior Color
Interior Color
Interior Material

Arrastar para a Pasta do FileTable*/

-- Atualizar Dados --
update dbo.CarsDocStore
set is_readonly = 1
where name = 'FordMustangGT.txt'

-- Excluíndo Dados --
Delete from dbo.CarsDocStore
where name = 'BuickRegal.txt'
