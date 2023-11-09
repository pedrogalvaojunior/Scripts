USE AULA6
GO

Create TABLE PARCELAMENTO
(CODIGO INT IDENTITY(1,1) PRIMARY KEY,
 CODVENDA INT NOT NULL,
 NUMEROPARCELA TINYINT NOT NULL,
 VALORPARCELA FLOAT NOT NULL,
 PorcentagemJuros Float Not Null,
 DataVencimento Date Not Null,
 ValorTotal Float Null)
GO

Create TRIGGER T_INSERIR_PARCELAMENTO
ON VENDAS
AFTER INSERT
AS
Begin

Set NoCount On

 IF (SELECT QTDEPARCELAS FROM INSERTED) > 1
  Begin

   Declare @Contador TinyInt,
           @CodVenda Int,
           @PorcentagemJuros Float

   Set @Contador = 1
   Set @CodVenda = (Select Codigo from inserted)
   Set @PorcentagemJuros=10
 
   
   While @Contador <= (Select QTDEPARCELAS FROM inserted)
    Begin
	 
	 Insert Into PARCELAMENTO(CODVENDA, NUMEROPARCELA, VALORPARCELA, PorcentagemJuros, DataVencimento)
	 Select Codigo, @Contador, (VAlorVenda/QTDEParcelas+((VALORVENDA/QTDEPARCELAS)*@PorcentagemJuros)/100), @PorcentagemJuros, DATEADD(MONTH,@Contador,GETDATE()) From Inserted 

	 Set @Contador += 1
	End                        

	Exec P_AtualizarValorTotalParcelamento @CodVenda
  End
End


Create Procedure P_AtualizarValorTotalParcelamento(@CodVenda Int = 1)
As
Begin

Set NoCount On

   Update Parcelamento
   Set ValorTotal = (Select SUM(ValorParcela) From PARCELAMENTO
                     Where CODVENDA = @CodVenda)
   Output inserted.CODVENDA, inserted.NUMEROPARCELA, inserted.VALORPARCELA, inserted.PorcentagemJuros, inserted.ValorTotal
   Where CODVENDA = @CodVenda 					  

End