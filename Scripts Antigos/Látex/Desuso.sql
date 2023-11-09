TRUNCATE TABLE PRODUTOS_APROVADOS
TRUNCATE TABLE PRODUTOS_REPROVADOS

DECLARE @CODDATA INT,
             @CODPRODUTO CHAR(8),
             @CODPRODUTO_ANT CHAR(8)

--730135 - 01/01/1999 

SET @CODDATA=732114
SET @CODPRODUTO=(SELECT TOP 1 CODIGO FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO BETWEEN '2000000' AND '2999999' ORDER BY CODIGO)

WHILE @CODPRODUTO <= (SELECT MAX(CODIGO) FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO BETWEEN '2000000' AND '2999999') 
 BEGIN
  IF @CODPRODUTO > (SELECT MAX(CODIGO) FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO BETWEEN '2000000' AND '2999999')
   BREAK
  ELSE
   BEGIN
    IF @CODDATA > (SELECT MAX(DATA_MOV) FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO=@CODPRODUTO)
     BEGIN
      SET SELECT @CODDATA=MAX(DATA_MOV) FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO=@CODPRODUTO
      INSERT PRODUTOS_APROVADOS VALUES(@CODPRODUTO, @CODDATA)
     END
     ELSE
      BEGIN
       SET SELECT @CODDATA=MAX(DATA_MOV) FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO=@CODPRODUTO
       INSERT PRODUTOS_REPROVADOS VALUES(@CODPRODUTO, @CODDATA)
      END
   END

  SET @CODPRODUTO_ANT=@CODPRODUTO  
  SET @CODDATA=732114
  SET @CODPRODUTO=(SELECT TOP 1 CODIGO FROM HISTMOV WHERE TIPO_MOV='54' AND CODIGO > @CODPRODUTO_ANT ORDER BY CODIGO)  
 END
