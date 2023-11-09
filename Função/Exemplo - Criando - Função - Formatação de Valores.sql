Create Function FormatarIntToMoney (@Valor Float) 
Returns varchar(30) as
Begin

Return replace(replace(replace( convert(varchar, convert(money, @Valor), 1), '.', 'x'), 
                         ',', '.'), 'x', ',');
End;
Go
  
Declare @Valores Table (ValorTotal Float);
Insert Into @Valores values (1453.3), (2839.24), (1020.44), (4332.30)

SELECT dbo.FormatarIntToMoney(Valor_Total) from @Valores;
Go