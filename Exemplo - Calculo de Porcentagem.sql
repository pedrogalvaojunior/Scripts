Declare @Lucro Numeric(10,2)
Set @Lucro=100.25

Print 'Valor Atual:'+Convert(Char(10),@Lucro)+'   '+'Valor calculado:'+Convert(Char(10),@Lucro * 0.15)
Print 'Valor Final:'+Convert(Char(10),@Lucro+(@Lucro * 0.15))