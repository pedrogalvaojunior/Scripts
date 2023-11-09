Declare @CodSequencialProduto Int,
           @Contador Int

Set @Contador=0

Truncate Table Rel_PQCxME

Declare PQCMe_Cursor Cursor For
 SELECT Distinct PQ.CODSEQUENCIALPRODUTO
  FROM PRODUTOSQUIMICOS PQ INNER JOIN PQCxME PM
                                            ON PQ.CODSEQUENCIALPRODUTO = PM.CODSEQUENCIALPRODUTO
  ORDER BY PQ.CODSEQUENCIALPRODUTO
Open PQCMe_Cursor

While @Contador < (SELECT Count(Distinct PQ.CODSEQUENCIALPRODUTO) 
                             FROM PRODUTOSQUIMICOS PQ INNER JOIN PQCxME PM
                                                                        ON PQ.CODSEQUENCIALPRODUTO = PM.CODSEQUENCIALPRODUTO)
 Begin

  FETCH NEXT FROM PQCMe_Cursor
  INTO @CodSequencialProduto

 Insert Into Rel_PQCxME
 SELECT   SUBSTRING(CONVERT(CHAR(9),CMP.CODANTIGO),3,7) As 'Código Antigo',
              Case Len(PQ.NumCadastro)
                When 1 Then '000'+Convert(Char(1),PQ.NumCadastro)
                When 2 Then '00'+Convert(Char(2),PQ.NumCadastro)
                When 3 Then '0'+Convert(Char(3),PQ.NumCadastro)
                When 4 Then Convert(Char(4),PQ.NumCadastro)
               End As 'Número Cadastro',
               CMP.APELIDO AS 'Descrição do Produto',
               PQ.PROCEDENCIA As 'Procedência',
               'ME/MP - '+Convert(VarChar(4),ME.NUMENSAIO)+' / '+ ME.DESCRICAO As 'Descrição - Método de Ensaio',
               PM.PADRAO_MINIMO As 'Padrão Mínimo',
               PM.PADRAO_MAXIMO As 'Padrão Máximo',
               ME.UNIDADE As 'Unidade Padrão' 
  FROM METODOS_ENSAIOS ME Inner JOIN PQCxMe PM
                                                      On PM.CODSEQUENCIALMETODO = ME.CODIGO 
                                                     INNER JOIN EMP100..CMPPRODUTOS CMP
                                                      ON CMP.CODPRODSEQUENCIAL = PM.CODSEQUENCIALPRODUTO
                                                     INNER JOIN EMP100..GERUNIDADES UNI
                                                      ON CMP.UNIDESTOQUE = UNI.CODIGO
                                                     INNER JOIN PRODUTOSQUIMICOS PQ
                                                      ON PQ.CODSEQUENCIALPRODUTO = CMP.CODPRODSEQUENCIAL
  WHERE PQ.CODSEQUENCIALPRODUTO=@CodSequencialProduto
  ORDER BY PQ.NUMCADASTRO   

  SET @Contador=@Contador+1  

  Print @Contador
 End

Close PQCMe_Cursor
Deallocate PQCMe_Cursor

SELECT * FROM REL_PQCxME
ORDER BY [Número Cadastro]