/**********************Criando as Tables***********************************/
CREATE TABLE INSUMOS (
 COD_INSUMO INT PRIMARY KEY NOT NULL,
 NOME_INSUMO  VARCHAR (80),
 DESC_INSUMO  VARCHAR (100),
 UM_INSUMO    CHAR    (3),
 PRECO_INSUMO FLOAT)

SET IDENTITY_INSERT PRODUTO1 OFF

CREATE TABLE PRODUTO1 (
  CODIGO INT PRIMARY KEY IDENTITY (1,1) NOT NULL, //-->CHAVE PRIMÁRIA
  COD_INSUMO INT FOREIGN KEY REFERENCES INSUMOS(COD_INSUMO), //-->CHAVE ESTRANGEIRA
  QTD_INSUMO FLOAT,
  PRECO_TOTAL_INSUMO FLOAT,
  PRECO_TOTAL_PRODUTO FLOAT)

/**********************Populando a Table INSUMOS****************************/
INSERT INTO INSUMOS VALUES('1','AG 100','AG100 (D45 LIGHT)','M3','183.62')	
INSERT INTO INSUMOS VALUES('2','BUCHA C/ ROSCA','PORCA AMERICANA','UN','0.19')	
INSERT INTO INSUMOS VALUES('3','CAIXA DE MADEIRA','CAIXA MAXIVALE 126X186X11','UN','1.00')	
INSERT INTO INSUMOS VALUES('4','CAIXA DE MADEIRA','CAIXA MAXIVALE 126X186X13','UN','2.00')	
INSERT INTO INSUMOS VALUES('5','CAIXA DE MADEIRA','CAIXA MAXIVALE 126X186X14','UN','3.00')	
INSERT INTO INSUMOS VALUES('6','CAIXA DE MADEIRA','CAIXA MAXIVALE 126X186X15','UN','4.00')	
INSERT INTO INSUMOS VALUES('7','CAIXA DE MADEIRA','CAIXA MAXIVALE 136X186X11','UN','5.00')	
INSERT INTO INSUMOS VALUES('8','CAIXA DE MADEIRA','CAIXA MAXIVALE 136X186X13','UN','6.00')	
INSERT INTO INSUMOS VALUES('9','CAIXA DE MADEIRA','CAIXA MAXIVALE 136X186X14','UN','7.00')	
INSERT INTO INSUMOS VALUES('10','CAIXA DE MADEIRA','CAIXA MAXIVALE 136X186X15','UN','8.00')	
INSERT INTO INSUMOS VALUES('11','CAIXA DE MADEIRA','CAIXA MAXIVALE 76X186X11','UN','9.00')	
INSERT INTO INSUMOS VALUES('12','CAIXA DE MADEIRA','CAIXA MAXIVALE 76X186X13','UN','10.00')	

/**********************Selecionando os dados da Table Insumos********************/
SELECT * FROM INSUMOS

/**********************Populando a Table PRODUTOS****************************/
SELECT * FROM PRODUTO1

INSERT INTO PRODUTO1 VALUES(1,'10.25','2.00','20.50')
INSERT INTO PRODUTO1 VALUES(1,'2','1.00','2.00')

INSERT INTO PRODUTO1 VALUES(5,'10.25','2.00','20.50')
INSERT INTO PRODUTO1 VALUES(5,'2','1.00','2.00')

INSERT INTO PRODUTO1 VALUES(6,'10.25','2.00','20.50')
INSERT INTO PRODUTO1 VALUES(6,'2','1.00','2.00')

/**********************Selecionando os dados da Table PRODUTO1********************/
SELECT * FROM PRODUTO1

/**********************Veja o relacionamento entre os dados***********************/
SELECT IMS.*, 
           PRO.QTD_INSUMO,
           PRO.PRECO_TOTAL_INSUMO,
           PRO.PRECO_TOTAL_PRODUTO FROM INSUMOS IMS INNER JOIN PRODUTO1 PRO
                                                                               ON IMS.COD_INSUMO = PRO.COD_INSUMO
ORDER BY IMS.COD_INSUMO

/*************************Respostas***********************************
1 - Não, é mais indicado é relacionar um campo parte evitar conflitos nas transações.

2 - Para isso, eu criei um campo Primary Key na Table Produto1, e usei o campo COD_INSUMO para fazer o 
relacionamento.

3 - Este campos você pode calcular diretamente na sua aplicação ou até mesmo criar uma Stored Procedure 
no seu Banco de Dados para ele fazer o calculo para você, depois é só pegar o resultado.

Qualquer coisa, estou a disposição.
/**********************************************************************/


