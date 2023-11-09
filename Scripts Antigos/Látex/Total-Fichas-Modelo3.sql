Declare @Total1 Int,
        @Total2 Int,
        @Total3 Int,
        @Total4 Int

Set @Total1=(Select Max(NumFicha) - Min(NumFicha) As Total From Custo100..custo)
Set @Total2=(Select Max(NumFicha) - Min(NumFicha) As Total From Custo200..custo)
Set @Total3=(Select Max(NumFicha) - Min(NumFicha) As Total From Custo300..custo)
Set @Total4=(Select Max(NumFicha) - Min(NumFicha) As Total From Custo900..custo)

Print 'Total de Fichas Montadas--> '+Cast(@Total1+@Total2+@Total3+@Total4 As Char(5))