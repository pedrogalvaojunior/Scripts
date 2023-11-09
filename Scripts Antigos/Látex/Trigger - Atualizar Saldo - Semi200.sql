CREATE  Trigger T_Atualizar_Saldos
On EstFisic
After Insert, Update
As

Set NoCount Off

Declare @TipoMov Char(1),
           @Codigo Char(10),
           @Quantidade Float(8),
           @Data_Mov DateTime

Select @TipoMov=Status, @Quantidade=Quantidade, @Codigo=Codigo, @Data_Mov=Data From Inserted

Begin

  If @TipoMov = 'E'
   Begin  
    Update Produtos 
    Set Saldo= Saldo+@Quantidade, Data=@Data_Mov
    Where Codigo = @Codigo 
   End
  
  If @TipoMov='S'
   Begin  
    Update Produtos 
    Set Saldo= Saldo-@Quantidade, Data=@Data_Mov
    Where Codigo = @Codigo 
   End
End