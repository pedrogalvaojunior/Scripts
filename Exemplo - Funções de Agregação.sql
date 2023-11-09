Create Table #Agregacao
 (Codigo SmallInt,
   Descricao VarChar(60),
   Marca Char(12),
   QTDE Float)

Insert Into #Agregacao Values (1,'Arroz','Prato Fino',10)
Insert Into #Agregacao Values (2,'Fej�o','Broto Legal',30)
Insert Into #Agregacao Values (3,'Batata','Fresca',50)
Insert Into #Agregacao Values (4,'Goibada','Arisco',20)
Insert Into #Agregacao Values (5,'Mandioca','Gorda',25)

Select Max(Codigo) As 'Maior C�digo',
         Min(Codigo) As 'Menor C�digo',
         Count(Codigo) As 'QTDE de Produtos',
         Sum(QTDE) As 'QTDE Total',
         AVG(QTDE) As 'M�dia QTDE'
from #Agregacao

   