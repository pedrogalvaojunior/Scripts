Declare @TBVenda Table (Ano Int,Valor Int)

Insert Into @TBVenda Values (2004,1)
Insert Into @TBVenda Values (2004,2)
Insert Into @TBVenda Values (2004,3)
Insert Into @TBVenda Values (2004,4)

Insert Into @TBVenda Values (2005,1)
Insert Into @TBVenda Values (2005,3)
Insert Into @TBVenda Values (2005,5)
Insert Into @TBVenda Values (2005,7)

Insert Into @TBVenda Values (2007,2)
Insert Into @TBVenda Values (2007,4)
Insert Into @TBVenda Values (2007,6)
Insert Into @TBVenda Values (2007,8)

Insert Into @TBVenda Values (2008,4)
Insert Into @TBVenda Values (2008,8)
Insert Into @TBVenda Values (2008,12)
Insert Into @TBVenda Values (2008,16)


Declare @TabelaAno Table (Ano Int)

Insert Into @TabelaAno Values(2004)
Insert Into @TabelaAno Values(2005)
Insert Into @TabelaAno Values(2006)
Insert Into @TabelaAno Values(2007)
Insert Into @TabelaAno Values(2008)

SELECT IsNull(TB.Ano,TA.Ano), Sum(IsNull(Tb.Valor,1)) FROM @TBVenda TB Right Join @TabelaAno TA
                                                                                   On TB.Ano = TA.Ano
GROUP BY TB.Ano, TA.Ano
