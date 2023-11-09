-- Exemplo 1 --
Create Or Alter Function DecimalToBinary (@Input bigint)
Returns Varchar(255)
As
Begin

    Declare @Output Varchar(255) = ''

    While @Input > 0 
	Begin

        Set @Output = @Output + CAST((@Input % 2) AS varchar)
        Set @Input = @Input / 2

    End

    Return Reverse(@Output)

End
Go

Select dbo.[DecimalToBinary](1)
Go

-- Exemplo 2 --
Declare @ValorInteiro TinyInt, @ValorResultado VarChar(255), @Contador TinyInt
Select @ValorInteiro=15, @Contador = 255, @ValorResultado = ''

While @Contador>0
 Begin
    Set @ValorResultado=Convert(Char(1), @ValorInteiro % 2)+@ValorResultado
    Set @ValorInteiro=Convert(TinyInt, (@ValorInteiro / 2))
	
	Set @Contador=@Contador-1
 End

--Select Substring(@ValorResultado,Len(@ValorResultado)-7,8) As Binario

Select Right(@ValorResultado,8) As Binario
Go
