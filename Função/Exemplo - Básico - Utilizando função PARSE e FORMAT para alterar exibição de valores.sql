Declare @Valor Varchar(10)

Set @Valor='1,540.20'

Select @Valor As Antes,
       PARSE(@Valor As money Using 'en-US') As Depois


Select FORMAT(Cast(@Valor As Money),'C','pt-BR')
Go