Declare @TabelaNome Table (Nome VarChar(30))

Insert Into @TabelaNome Values('Pedro Antonio Galvão')

Insert Into @TabelaNome Values('José Joaquim da Silva')


Select Reverse(Left(Reverse(SubString(Nome,1,Len(Nome))),CharIndex(' ',Nome))) From @TabelaNome

Select reverse(substring(Reverse('PAULA MARIA GOLDENBERG'),1,charindex(' ',REVERSE('PAULA MARIA GOLDENBERG'))+0))