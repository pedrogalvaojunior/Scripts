USE [LABORATORIO]
GO
/****** Object:  StoredProcedure [dbo].[P_RegistroHistorico_PesquisaMovimentacaoParcial]    Script Date: 03/05/2008 13:28:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[P_RegistroHistorico_PesquisaMovimentacaoParcial] @NUMPVM CHAR(7)
AS
Begin

Set NoCount ON

Truncate Table CTProducao_RegistroHistoricoParcial
Truncate Table ResumoResultadosMP
Truncate Table ResumoResultadosMO

Declare  @NumControle Char(7),
            @Contador Int,
            @CodSigla Char(2)

Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NUMMO, NumControle, DescricaoProduto, CodSigla)
Select @NUMPVM, 
         NULL,
         CTPVMI.NUMCONTROLE, 
         MO.DescricaoProduto, 
         'MO' As Sigla
from CTProducao_PVM_Items CTPVMI Inner Join CTProducao_Moinho MO
                                                    ON CTPVMI.NUMCONTROLE = MO.NUMMO
Where CTPVMI.NUMPVM = @NumPVM
And     CTPVMI.CodSigla = 'MO'
Union
Select @NUMPVM,
         NULL, 
         CTPVMI.NUMCONTROLE, 
         MP.Descricao, 
         'MP' As Sigla
from CTProducao_PVM_Items CTPVMI Inner Join CTEntrada_PQC MP
                                                    ON CTPVMI.NUMCONTROLE = MP.NUMMP
Where CTPVMI.NUMPVM = @NumPVM
And     CTPVMI.CodSigla = 'MP'
Order By CTPVMI.NumControle DESC

Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NumControle, DescricaoProduto, CodSigla)
Select  @NumPVM, NumRecebimento, DescricaoProduto, 'LT' From CTProducao_PVM
Where NUMPVM=@NUMPVM

If (Select Segundo_NumRecebimento From CTProducao_PVM Where NUMPVM = @NUMPVM) <> Null
 Begin
  Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NumControle, DescricaoProduto, CodSigla)
  Select  @NumPVM, NumRecebimento, DescricaoProduto, 'LT' From CTProducao_PVM
  Where NUMPVM=@NUMPVM 
 End

Declare CTProducao_PVM_Itens_Cursor Cursor For
Select NUMCONTROLE, CodSigla from CTProducao_PVM_Items
Where NUMPVM = @NUMPVM
 
Open CTProducao_PVM_Itens_Cursor
 
Set @Contador = 0

 While @Contador < (Select Count(NUMPVM) From CTProducao_PVM_Items Where NumPVM = @NumPVM)
   Begin
    Fetch Next From CTProducao_PVM_Itens_Cursor
    Into @NumControle, @CodSigla
   
     If @CodSigla = 'MO'
      Begin             
        Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NUMMO, NumControle, DescricaoProduto, CodSigla)
        Select @NUMPVM, 
                 CTPMOI.NUMMO,
                 CTPMOI.Numcontrole, 
                 CTPMOI.DescricaoProduto,
                 CTPMOI.CodSigla
        From CTProducao_Moinho CTPMoinho Inner Join CTProducao_Moinho_Items CTPMOI
                                                           On CTPMoinho.NumMO = CTPMOI.NumMO
        Where CTPMoinho.NumMO = @NumControle
       End        

      If @CodSigla = 'MP'
       Begin
        Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NUMMO, NumControle, DescricaoProduto, CodSigla)
        Select @NUMPVM, 
                  CTPMOI.NUMMO,
                  CTPMOI.NumControle, 
                  CTPMOI.DescricaoProduto, 
                  CTPMOI.CodSigla
         From CTEntrada_PQC CTEPQC Inner Join CTProducao_Moinho_Items CTPMOI 
                                                   On CTEPQC.NumMP = CTPMOI.NumControle
         Where CTPMOI.NumMO = @NumControle
        End

    Set @Contador = @Contador + 1
   End

 CLOSE CTProducao_PVM_Itens_Cursor
 DEALLOCATE CTProducao_PVM_Itens_Cursor

 Execute dbo.P_RegistroHistorico_ResumoResultadosPVMxMOxMP 
End
