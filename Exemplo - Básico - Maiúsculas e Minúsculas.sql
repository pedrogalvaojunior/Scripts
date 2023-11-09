-->Primeira Letra em Maiúscula

Declare @PrimeiraLetra VarChar(100)

Set @PrimeiraLetra=(Select Top 1 Left(Upper(Descricao),1) From Produtos)

Select @PrimeiraLetra+SubString(Lower(Descricao),2,Len(Descricao)) from PRODUTOS

-->Primeira Letra em Minúscula

Declare @PrimeiraLetra VarChar(100)

Set @PrimeiraLetra=(Select Top 1 Left(Lower(Descricao),1) From Produtos)

Select @PrimeiraLetra+SubString(Lower(Descricao),2,Len(Descricao)) from PRODUTOS