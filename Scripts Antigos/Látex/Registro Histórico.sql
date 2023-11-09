Set NoCount ON

Truncate Table CTProducao_RegistroHistoricoParcial

Declare @NumPVM Char(7),
           @NumControle Char(7),
           @Contador Int,
           @CodSigla Char(2)

Set @NUMPVM='0033/08'

Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NumControle, CodSigla)
Select  @NumPVM, NumRecebimento, 'LT' From CTProducao_PVM
Where NUMPVM=@NUMPVM

If (Select Segundo_NumRecebimento From CTProducao_PVM Where NUMPVM = @NUMPVM) <> Null
 Begin
  Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NumControle, CodSigla)
  Select  @NumPVM, Segundo_NumRecebimento, 'LT' From CTProducao_PVM
  Where NUMPVM=@NUMPVM
 End

Select @Contador=Count(*) From CTProducao_PVM_Items
Where NUMPVM=@NUMPVM

Declare CTProducao_PVM_Itens_Cursor Cursor For
Select NUMCONTROLE, CodSigla from CTProducao_PVM_Items
Where NUMPVM = @NUMPVM
 
Open CTProducao_PVM_Itens_Cursor

 While @Contador > 0
   Begin
    Fetch Next From CTProducao_PVM_Itens_Cursor
    Into @NumControle, @CodSigla

    If Not Exists (Select NUMControle from CTProducao_RegistroHistoricoParcial Where NumControle = @NumControle And CodSigla = @CodSigla)
     Begin
      Insert Into CTProducao_RegistroHistoricoParcial(NUMPVM, NumControle, CodSigla)
      Select @NUMPVM, 
                CTPVM.NumControle, 
                CTPVM.CodSigla         
       From CTProducao_Moinho_Items CTPVM 
       Where    CTPVM.NumMO=@NumControle
       Order By CTPVM.NUMMO Desc, CTPVM.NumControle Desc
      End

     Set @Contador= @Contador -1 
   End

Select NumPVM, NumControle, CodSigla from CTProducao_RegistroHistoricoParcial
Order By NumControle Asc, CodSigla Asc

CLOSE CTProducao_PVM_Itens_Cursor
DEALLOCATE CTProducao_PVM_Itens_Cursor
