SELECT 10*Rand(), 10 + (20-10)*RAND(), 20 + (30-20)*RAND(), 30 + (40-30)*RAND(), 40 + (50-40)*RAND(), 50 + (60-50)*RAND()
Go

Select 10*Rand() As Faixa10,
           10 + (10) *RAND() As Faixa10,
           20 + (10)*RAND() As Faixa30,
           30 + (10)*RAND() As Faixa40,
           40 + (10)*RAND() As Faixa50,
           50 + (10)*RAND() As Faixa60    


 -- Sorteando os Pseudo Random N�meros --
 Set @N1 = 10*Rand() -- N�meros de 0 at� 10 --
 Set @N2 = 10 + (20-10)*RAND() -- N�meros de 11 at� 20 --
 Set @N3 = 20 + (30-20)*RAND() -- N�meros de 21 at� 30 --
 Set @N4 = 30 + (40-30)*RAND() -- N�meros de 31 at� 40 --
 Set @N5 = 40 + (50-40)*RAND() -- N�meros de 41 at� 50 --
 Set @N6 = 50 + (60-50)*RAND() -- N�meros de 51 at� 60 --