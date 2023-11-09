Declare @Datas Table 
 (DataInicial DateTime, 
  DataFinal DateTime)

Insert Into @Datas 
Values (GetDate(), GetDate()+1),
       (GetDate(), '2019-12-06 20:46:15')

;With TotalHoras (Horas, Minutos)
As 
( 
  Select DateDiff(Hour,DataInicial, DataFinal) As Horas,
         DateDiff(ss,DataInicial, DataFinal) As Minutos
  From @Datas
),

Resultados (Dias, Horas, Minutos, Segundos)
As 
(
 Select 
        (Horas / 24) As Dias,
        (Horas % 24) As Horas,
        (Minutos % 3600) / 60 As Minutos,
        (Minutos % 3600) % 60 As Segundos
 From TotalHoras)


Select Concat(Dias, ' dia(s) ', Horas, 'hr(s) ', Minutos, 'min(s) ', Segundos, 'seg(s)') As Diferenca
From Resultados
Go