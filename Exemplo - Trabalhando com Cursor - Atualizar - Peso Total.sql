DECLARE @NUMRECEBIMENTO CHAR(7),
             @CODSEQUENCIAL CHAR(7)

SET @NUMRECEBIMENTO=''

SELECT @CODSEQUENCIAL=MIN(NUMRECEBIMENTO) FROM CTENTRADA_RECEBIMENTO_LATEX

DECLARE CURSORES CURSOR FOR
 SELECT NUMRECEBIMENTO FROM CTENTRADA_RECEBIMENTO_LATEX
 ORDER BY DATACONTROLE ASC
 OPEN CURSORES
 
 WHILE @CODSEQUENCIAL <=(SELECT MAX(NUMRECEBIMENTO) FROM CTENTRADA_RECEBIMENTO_LATEX)
  BEGIN
   FETCH NEXT FROM CURSORES
   INTO @NUMRECEBIMENTO

  Update CTEntrada_Recebimento_Latex
  Set PesoTotal=(Select Sum(CTPL.Quantidade) From CTEntrada_Recebimento_Latex_Itens CTPL Inner Join CTEntrada_Recebimento_Latex CT  
                                                                                                                                   On CTPL.NumRecebimento = CT.NumRecebimento
                        Where CTPL.NumRecebimento = @NumRecebimento)
  From CTEntrada_Recebimento_Latex PL 
  Where PL.NumRecebimento = @NumRecebimento
   
   SET @CODSEQUENCIAL=@NUMRECEBIMENTO
   
  END

  CLOSE CURSORES
 DEALLOCATE CURSORES


