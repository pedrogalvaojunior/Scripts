Create Table TesteValores
(Valor1 Int,
 Valor2 Int)
Go

Insert Into TesteValores Values(10,20),(5,3),(10,Null),(Null,15)
Go

-- Select Derived Table --
Select Sum(Valor1+Valor2) As Total from 
      (Select Sum(Valor1) As Valor1, Sum(Valor2) As Valor2 From 
              (Select Valor1, Valor2 From TesteValores) As A) As B
Go

-- 1º Select denominado A --
Select Valor1, Valor2 From TesteValores As A -- não declaro os paranteses
Go

-- 2º Select denominado B, incorporando o 1º Select A --
      Select Sum(Valor1) As Valor1, Sum(Valor2) As Valor2 From 
              (Select Valor1, Valor2 From TesteValores) As A  -- acrescento o parenteses no Select A
Go

-- 3º Select denominada C, incorporando os Selects B e A --
Select Sum(Valor1+Valor2) As Total from 
      (Select Sum(Valor1) As Valor1, Sum(Valor2) As Valor2 From  -- acrescento o parenteses no Select B
              (Select Valor1, Valor2 From TesteValores) As A) As B -- definido o apelido do Select B
Go