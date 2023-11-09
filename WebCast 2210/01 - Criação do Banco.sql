-- Cria o banco de dados
IF EXISTS (SELECT * FROM SYS.DATABASES WHERE NAME = 'DBQueryPlus')
	DROP DATABASE DBQueryPlus;

CREATE DATABASE DBQueryPlus ON (
	NAME='DBQueryPlus_Data',FILENAME='D:\DBQueryPlus_Data.MDF',SIZE=40MB)
LOG ON (
	NAME='DBQueryPlus_Log',FILENAME='D:\DBQueryPlus_Log.LDF',SIZE=10MB)

-- Muda o contexto do banco de dados
USE DBQueryPlus;

-- Cria as tabelas necessárias
CREATE TABLE tblCategorias (
	CategoriaID INT IDENTITY(1,1), CategoriaNome VARCHAR(50))

CREATE TABLE tblProdutos (
	ProdutoID INT, CategoriaID INT, ProdutoNome VARCHAR(100))

INSERT INTO tblProdutos VALUES (01,2,'Câmera digital')
INSERT INTO tblProdutos VALUES (03,2,'Pen Drive')
INSERT INTO tblProdutos VALUES (07,2,'Monitor LCD')
INSERT INTO tblProdutos VALUES (13,3,'Luva')
INSERT INTO tblProdutos VALUES (20,3,'Meia')
INSERT INTO tblProdutos VALUES (25,1,'Maçã')

CREATE TABLE tblVendasConsolidadas (
	Data SMALLDATETIME,
	TotalVendido NUMERIC(10,2))

INSERT INTO tblVendasConsolidadas VALUES ('20070401',2000)
INSERT INTO tblVendasConsolidadas VALUES ('20070601',2500)
INSERT INTO tblVendasConsolidadas VALUES ('20070701',3000)
INSERT INTO tblVendasConsolidadas VALUES ('20070801',3200)
INSERT INTO tblVendasConsolidadas VALUES ('20071101',4800)
INSERT INTO tblVendasConsolidadas VALUES ('20071201',5000)
INSERT INTO tblVendasConsolidadas VALUES ('20080101',3100)
INSERT INTO tblVendasConsolidadas VALUES ('20080201',2500)
INSERT INTO tblVendasConsolidadas VALUES ('20080301',1300)
INSERT INTO tblVendasConsolidadas VALUES ('20080401',1000)
INSERT INTO tblVendasConsolidadas VALUES ('20080601',4000)
INSERT INTO tblVendasConsolidadas VALUES ('20080701',5000)
INSERT INTO tblVendasConsolidadas VALUES ('20080801',5500)
INSERT INTO tblVendasConsolidadas VALUES ('20081001',4500)

CREATE TABLE tblNumeros (Valor INT)
INSERT INTO tblNumeros VALUES (2)
INSERT INTO tblNumeros VALUES (3)
INSERT INTO tblNumeros VALUES (6)
INSERT INTO tblNumeros VALUES (7)

CREATE TABLE tblClientes (ClienteID INT, NomeCliente VARCHAR(50))
INSERT INTO tblClientes VALUES (1,'Wagner')
INSERT INTO tblClientes VALUES (2,'Sérgio')
INSERT INTO tblClientes VALUES (3,'Felipe')
INSERT INTO tblClientes VALUES (4,'Ricardo')

CREATE TABLE tblCarros (CarroID INT, ClienteID INT,
	CarroModelo VARCHAR(50), CarroMarca VARCHAR(20))

INSERT INTO tblCarros VALUES (01,01,'Astra','GM')
INSERT INTO tblCarros VALUES (02,01,'Fit','Honda')
INSERT INTO tblCarros VALUES (03,02,'Astra','GM')
INSERT INTO tblCarros VALUES (04,02,'207','Peugeot')
INSERT INTO tblCarros VALUES (05,02,'Fusca','Volks')
INSERT INTO tblCarros VALUES (06,02,'Mégane','Renault')
INSERT INTO tblCarros VALUES (07,03,'C3','Citroen')
INSERT INTO tblCarros VALUES (08,03,'Palio','Fiat')
INSERT INTO tblCarros VALUES (09,03,'Polo','Volks')
INSERT INTO tblCarros VALUES (10,04,'Celta','GM')
INSERT INTO tblCarros VALUES (11,04,'Palio Weekend','Fiat')
INSERT INTO tblCarros VALUES (12,04,'Golf','Volks')