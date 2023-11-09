Declare @TBValorString Table
 (Codigo Int Identity(1,1),
  ValorString1 Varchar(10) Default Null,
  ValorString2 Varchar(10) Not Null)

Insert Into @TBValorString (ValorString1, ValorString2)
Values ('AAA','123'), 
       (Null,'456'),
	   (Null,'789'), 
       ('BBB', '901')

-- Utilizando Case --
Select Case
        When Len(ValorString1) Is Null Then 'Null '+ValorString2
       Else
	    ValorString1+ValorString2
	   End As 'Concatenado com Case'
From @TBValorString

-- Utilizando Coalesce --
Select Coalesce(IsNull(ValorString1,'Null'+ValorString2),ValorString1)+
       Coalesce(IsNull(ValorString2, ValorString2+'Null'),ValorString2) As 'Concatenado com Coalesce'
From @TBValorString
Go