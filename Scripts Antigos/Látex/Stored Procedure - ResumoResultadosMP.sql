USE [LABORATORIO]
GO
/****** Object:  StoredProcedure [dbo].[P_RegistroHistorico_ResumoResultadosMP]    Script Date: 07/05/2007 10:34:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[P_RegistroHistorico_ResumoResultadosMP] @NUMMO Char(7)
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

  Truncate Table ResumoResultadosMP

  Select @Contador=Count(*) From CTProducao_Moinho_Items
  Where NUMMO=@NUMMO
  AND    CODSIGLA='MP'

  Declare CTProducao_Moinho_Items_MP_Cursor Cursor For
  Select NUMCONTROLE from CTProducao_Moinho_Items
  Where NUMMO = @NUMMO
  AND    CODSIGLA='MP'
  Open CTProducao_Moinho_Items_MP_Cursor

  While @Contador > 0
   Begin
    Fetch Next From CTProducao_Moinho_Items_MP_Cursor
    Into @NumControle

    If (SubString(@NumControle,6,2)='07')
     Begin
      
      Select @CodRelacionamento=CodRelacionamento,
               @CodSequencialProduto=CodSequencialProduto 
      From CTEntrada_PQC_Resultados Where NUMMP = @NumControle                 

      Insert Into ResumoResultadosMP
      SELECT 'MP',
                 NUMMP,
                 ME.DESCRICAO,
                 CME.CLASSE+' - '+CONVERT(VARCHAR(4),ME.NUMENSAIO) As "CodClasses", 
                 PQCx.PADRAO_MINIMO,
                 PQCx.PADRAO_MAXIMO,
                 ME.UNIDADE,
                 PQCRe.AMOSTRA,
                 Observacao=(Select Observacao_Amostra From CTEntrada_PQC Where NumMP = PQCRe.NumMP)
      FROM METODOS_ENSAIOS ME INNER JOIN CLASSIFICACAO_ME CME
                                                ON ME.NUMCLASSE = CME.CODIGO
                                               INNER JOIN PQCxME PQCx
                                                ON PQCx.CODSEQUENCIALMETODO = ME.CODIGO
                                               INNER JOIN CTENTRADA_PQC_RESULTADOS PQCRe
                                                ON PQCRe.NUMMP = @NumControle
                                                AND PQCRe.CODSEQUENCIALMETODO = ME.CODIGO
      WHERE PQCx.CODSEQUENCIALPRODUTO = @CodSequencialProduto
      AND     PQCx.CODRELACIONAMENTO = @CodRelacionamento

     End

    If (SubString(@NumControle,6,2)='06')
     Begin
      
      Select @CodRelacionamento=CodRelacionamento,
               @CodSequencialProduto=CodSequencialProduto 
      From CTEntrada_Anterior_PQC_Resultados Where NUMMP = @NumControle                 

      Insert Into ResumoResultadosMP
      SELECT 'MP',
                 PQCRe.NUMMP,
                 ME.DESCRICAO,
                 CME.CLASSE+' - '+CONVERT(VARCHAR(4),ME.NUMENSAIO) As "CodClasses", 
                 PQCx.PADRAO_MINIMO,
                 PQCx.PADRAO_MAXIMO,
                 ME.UNIDADE,
                 PQCRe.AMOSTRA,
                 Observacao=(Select Observacao_Amostra From CTEntrada_PQC Where NUMMP = PQCRe.NUMMP)
      FROM METODOS_ENSAIOS ME INNER JOIN CLASSIFICACAO_ME CME
                                                ON ME.NUMCLASSE = CME.CODIGO
                                               INNER JOIN PQCxME PQCx
                                                ON PQCx.CODSEQUENCIALMETODO = ME.CODIGO
                                               INNER JOIN CTENTRADA_ANTERIOR_PQC_RESULTADOS PQCRe
                                                ON PQCRe.NUMMP = @NumControle
                                                AND PQCRe.CODSEQUENCIALMETODO = ME.CODIGO
      WHERE PQCx.CODSEQUENCIALPRODUTO = @CodSequencialProduto
      AND     PQCx.CODRELACIONAMENTO = @CodRelacionamento

     End

    Set @Contador= @Contador -1 
   End


  Select NumControle, Descricao, CodClasses, PadraoMinimo, PadraoMaximo, Unidade, Amostra, Observacao From ResumoResultadosMP
  Order By CodSigla Desc, NumControle Asc

  CLOSE CTProducao_Moinho_Items_MP_Cursor
  DEALLOCATE CTProducao_Moinho_Items_MP_Cursor
 End

P_RegistroHistorico_ResumoResultadosMP '2684/07'