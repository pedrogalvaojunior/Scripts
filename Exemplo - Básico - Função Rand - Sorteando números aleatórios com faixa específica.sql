SELECT 10*Rand(), 10 + (20-10)*RAND(), 20 + (30-20)*RAND(), 30 + (40-30)*RAND(), 40 + (50-40)*RAND(), 50 + (60-50)*RAND()
Go

Select 10*Rand() As Faixa10,
           10 + (10) *RAND() As Faixa10,
           20 + (10)*RAND() As Faixa30,
           30 + (10)*RAND() As Faixa40,
           40 + (10)*RAND() As Faixa50,
           50 + (10)*RAND() As Faixa60    


 -- Sorteando os Pseudo Random Números --
 Set @N1 = 10*Rand() -- Números de 0 até 10 --
 Set @N2 = 10 + (20-10)*RAND() -- Números de 11 até 20 --
 Set @N3 = 20 + (30-20)*RAND() -- Números de 21 até 30 --
 Set @N4 = 30 + (40-30)*RAND() -- Números de 31 até 40 --
 Set @N5 = 40 + (50-40)*RAND() -- Números de 41 até 50 --
 Set @N6 = 50 + (60-50)*RAND() -- Números de 51 até 60 --