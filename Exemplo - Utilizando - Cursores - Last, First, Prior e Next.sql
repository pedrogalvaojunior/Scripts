CREATE DATABASE TESTE

CREATE TABLE PRODUTOS
(CODIGO INT IDENTITY(1,1),
 DESCRICAO VARCHAR(100))

INSERT INTO PRODUTOS VALUES ('PRODUTO: '+Convert(Varchar(5),IsNull(@@Identity,1)))
Go 10000

Select * from Produtos

/************************************************************/
--CURSOR NEXT--
CREATE TABLE TESTE
(CODIGO INT, 
 DESCRICAO VARCHAR(50))

DECLARE @REGISTRO INT,
        @CODIGO INT,
        @DESCRICAO VARCHAR(50)

SET @REGISTRO=0

DECLARE CURSOR_Produtos CURSOR FOR
 SELECT CODIGO, DESCRICAO FROM PRODUTOS
 OPEN Cursor_Produtos
 
 WHILE @REGISTRO <=10
  BEGIN
   FETCH NEXT FROM Cursor_Produtos
   INTO @CODIGO, @DESCRICAO
   
   INSERT INTO TESTE VALUES(@CODIGO, @DESCRICAO)

   SET @REGISTRO=@REGISTRO+1 
   
   PRINT 'Código:'+CAST(@CODIGO AS VARCHAR(20))+' Descrição:'+@DESCRICAO
  END

 CLOSE Cursor_Produtos
 DEALLOCATE Cursor_Produtos

SELECT * FROM TESTE

/************************************************************/
-- CURSOR FIRST --

DECLARE @REGISTRO INT,
                @CODIGO INT,
                @DESCRICAO VARCHAR(50)

SET @REGISTRO = 0

DECLARE Cursor_Produtos SCROLL CURSOR FOR
 SELECT CODIGO, DESCRICAO FROM PRODUTOS ORDER BY CODIGO ASC
 OPEN Cursor_Produtos
 
 WHILE @REGISTRO = 0
  BEGIN
   FETCH First FROM Cursor_Produtos
   INTO @CODIGO, @DESCRICAO
  
   SET @REGISTRO=@REGISTRO-1 
   
   PRINT 'Código:'+CAST(@CODIGO AS VARCHAR(20))+' Descrição:'+@DESCRICAO
  End

 CLOSE Cursor_Produtos
 DEALLOCATE Cursor_Produtos

/************************************************************/
-- CURSOR LAST --

DECLARE @REGISTRO INT,
                @CODIGO INT,
                @DESCRICAO VARCHAR(50)

SET @REGISTRO = 0

DECLARE Cursor_Produtos SCROLL CURSOR FOR
 SELECT CODIGO, DESCRICAO FROM PRODUTOS ORDER BY CODIGO ASC
 OPEN Cursor_Produtos
 
 WHILE @REGISTRO = 0
  BEGIN
   FETCH Last FROM Cursor_Produtos
   INTO @CODIGO, @DESCRICAO
  
   SET @REGISTRO=1
   
   PRINT 'Código:'+CAST(@CODIGO AS VARCHAR(20))+' Descrição:'+@DESCRICAO
  End

 CLOSE Cursor_Produtos
 DEALLOCATE Cursor_Produtos
 
/************************************************************/
-- CURSOR PRIOR --

DECLARE @REGISTRO INT,
                @CODIGO INT,
                @DESCRICAO VARCHAR(50)

SET @REGISTRO = 0

DECLARE Cursor_Produtos SCROLL CURSOR FOR
 SELECT TOP 2 CODIGO, DESCRICAO FROM PRODUTOS ORDER BY CODIGO DESC
 OPEN Cursor_Produtos
 
 WHILE @REGISTRO = 0
  BEGIN
   FETCH LAST FROM Cursor_Produtos
   
   FETCH PRIOR FROM  Cursor_Produtos
   INTO @CODIGO, @DESCRICAO
  
   SET @REGISTRO=1 
   
   PRINT 'Código:'+CAST(@CODIGO AS VARCHAR(20))+' Descrição:'+@DESCRICAO
  End

 CLOSE Cursor_Produtos
 DEALLOCATE Cursor_Produtos