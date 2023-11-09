Create Table ListaNumerica
 (Numero1 Int Primary Key,
  DigitoI TinyInt Default 0,
  DigitoII TinyInt Default 2)
GO

;With CTENumeracao (Numero, DigitoI, DigitoII)
As
(Select 1, 0, 2
 Union All
 Select Numero + 1 As Numero, (Numero/10) As DigitoI, DigitoI+2 As DigitoII from CTENumeracao
 Where Numero<100
)
Insert Into ListaNumerica
Select Numero, DigitoI, DigitoII From CTENumeracao
Go

Declare @Contador TinyInt = 1, 
        @ContadorInicial SmallInt=10, 
        @ContadorFinal SmallInt=19

While @Contador <= 12
Begin

Select Numero1, DigitoI, 
       Stuff(Replace(Replace((Select Concat(Numero1,',') As Numero From ListaNumerica 
                        Where Numero1 BetWeen @ContadorInicial And @ContadorFinal For XML Path('')),'<Numero>',''),'</Numero>',''),30,2,'') As 'Lista Numérica II',
       DigitoI+1 As DigitoII       
From ListaNumerica
Where Numero1 = @Contador

Set @Contador +=1
Set @ContadorInicial +=10
Set @ContadorFinal +=10

End
