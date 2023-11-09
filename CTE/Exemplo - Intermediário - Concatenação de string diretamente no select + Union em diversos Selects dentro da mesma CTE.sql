Create Table Numeracao
(Numero TinyInt Identity(1,1) Primary Key,
 Digito TinyInt Default 0)
 Go

 ;With CTENumeracao (Numero, Digito)
As
(Select 1, 0
 Union All
 Select Numero + 1 As Numero, (Numero/10) As Digito from CTENumeracao
 Where Numero<100
)
Insert Into Numeracao (Digito)
Select Digito From CTENumeracao
Go

;With CTEListaNumerica
As
(
Select Numero As Numero1, Digito,        
           Replace(Replace((Select Concat(Numero,',') As Numero From Numeracao 
                        Where Numero BetWeen 1 And 10 For XML Path('')),'<Numero>',''),'</Numero>','') As 'ListaNumericaII',
           Replace(Replace((Select Concat(Numero-1,',') As Numero From Numeracao 
                        Where Numero BetWeen 1 And 10 Order By Numero Desc For XML Path('')),'<Numero>',''),'</Numero>','') As 'DigitoII'
From Numeracao
Where Numero=1

Union

Select Numero As Numero1, Digito,        
           Replace(Replace((Select Concat(Numero,',') As Numero From Numeracao 
                        Where Numero BetWeen 11 And 20 For XML Path('')),'<Numero>',''),'</Numero>','') As 'ListaNumericaII',
           Replace(Replace((Select Concat(Numero-1,',') As Numero From Numeracao 
                        Where Numero BetWeen 11 And 20 Order By Numero Desc For XML Path('')),'<Numero>',''),'</Numero>','') As 'DigitoII'
From Numeracao
Where Numero=2

Union

Select Numero As Numero1, Digito,        
           Replace(Replace((Select Concat(Numero,',') As Numero From Numeracao 
                        Where Numero BetWeen 21 And 30 For XML Path('')),'<Numero>',''),'</Numero>','') As 'ListaNumericaII',
           Replace(Replace((Select Concat(Numero,',') As Numero From Numeracao 
                        Where Numero BetWeen 21 And 30 Order By Numero Desc For XML Path('')),'<Numero>',''),'</Numero>','') As 'DigitoII'
From Numeracao
Where Numero=3)

Select Numero1, Digito, 
           SubString(ListaNumericaII,1,LEN(ListaNumericaII)-1) As 'Lista Numérica II',
           SubString(DigitoII,1,LEN(DigitoII)-1) As 'Dígito II'
From CTEListaNumerica
Go