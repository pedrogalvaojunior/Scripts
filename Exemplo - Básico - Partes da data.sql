Select * From ctluvas
Where  DatePart(Day, DataProducao)=20
And     DatePart(Month, DataProducao)=12
And     DatePart(Year, DataProducao)=2005
Order by CodProduto