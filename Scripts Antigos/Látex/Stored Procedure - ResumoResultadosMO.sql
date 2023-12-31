ALTER Procedure [dbo].[P_RegistroHistorico_ResumoResultadosMO] @NUMMO Char(7)
As
 Begin

  Set NoCount On

  Declare @NumControle Char(7),
             @Contador Int,
             @CodSequencialProduto Int,
             @CodRelacionamento Int

  Set @NumControle = 0
  Set @Contador = 0
  Set @CodSequencialProduto = 0 
  Set @CodRelacionamento = 0

  Truncate Table ResumoResultadosMO

  Select @Contador=Count(*) From CTProducao_Moinho_Items
  Where NUMMO=@NUMMO
  AND    CODSIGLA='MO'

  Declare CTProducao_Moinho_Items_MO_Cursor Cursor For
  Select NUMCONTROLE from CTProducao_Moinho_Items
  Where NUMMO = @NUMMO
  AND    CODSIGLA= 'MO'
  Open CTProducao_Moinho_Items_MO_Cursor

  While @Contador > 0
   Begin
    Fetch Next From CTProducao_Moinho_Items_MO_Cursor
    Into @NumControle

    If (SubString(@NumControle,6,2)='07')
     Begin
      
      Select @CodRelacionamento=CodRelacionamento,
               @CodSequencialProduto=CodSequencialProduto 
      From CTProducao_Moinho_Resultados Where NUMMO = @NumControle                 

      Insert Into ResumoResultadosMO
      SELECT 'MO',
                 PQCRe.NUMMO,
                 ME.DESCRICAO,
                 CME.CLASSE+' - '+CONVERT(VARCHAR(4),ME.NUMENSAIO) As "CodClasses", 
                 DataEntrada=(Select DataEntrada from CTProducao_Moinho_Info_Reprovacao Where NUMMO = PQCRe.NUMMO And NumRetorno = PQCRe.NUMRETORNO),                 
                 DataLiberacao=(Select DataLiberacao from CTProducao_Moinho_Info_Reprovacao Where NUMMO = PQCRe.NUMMO And NumRetorno = PQCRe.NUMRETORNO),
                 PQCRe.NUMRETORNO,
                 PQCx.PADRAO_MINIMO,
                 PQCx.PADRAO_MAXIMO,
                 ME.UNIDADE,
                 PQCRe.AMOSTRA,
                 Case PQCRe.STATUS
                  When 'A' Then 'Aprovado'
                  When 'R' Then 'Reprovado'
                 End As Status,
                 PQCRe.MOTIVO_ANALISE,
                 NOME=(SELECT NOME FROM RESPONSAVEL Where Responsavel.Codigo = PQCRe.CodResponsavel_Laboratorio)
      FROM METODOS_ENSAIOS ME INNER JOIN CLASSIFICACAO_ME CME
                                                ON ME.NUMCLASSE = CME.CODIGO
                                               INNER JOIN PQC_MoinhoxME PQCx
                                                ON PQCx.CODSEQUENCIALMETODO = ME.CODIGO
                                               INNER JOIN CTPRODUCAO_MOINHO_RESULTADOS PQCRe
                                                ON PQCRe.NUMMO = @NumControle
                                                AND PQCRe.CODSEQUENCIALMETODO = ME.CODIGO
      WHERE PQCx.CODSEQUENCIALPRODUTO = @CodSequencialProduto
      AND     PQCx.CODRELACIONAMENTO = @CodRelacionamento

     End

    Set @Contador= @Contador -1 
   End


  Select NumControle, Descricao, CodClasses, DataEntrada, DataLiberacao, NumRetorno, 
            PadraoMinimo, PadraoMaximo, Unidade, Amostra, Status, MotivoAnalise, NomeResponsavel From ResumoResultadosMO
  Order By CodSigla Desc, NumControle Asc

  CLOSE CTProducao_Moinho_Items_MO_Cursor
  DEALLOCATE CTProducao_Moinho_Items_MO_Cursor
 End

