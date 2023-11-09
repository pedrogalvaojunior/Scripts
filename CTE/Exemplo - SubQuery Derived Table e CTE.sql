-- SubQuery Derived Table (SQL Server 7 e demais)
Declare @T1 Table (Valor1 Int)

Insert Into @T1 Values (1)
 
Select Valor1, Valor2, (Valor1+Valor2) as Total 
from (
Select Valor1,
(Select 1 from @T1) as Valor2
From @T1) As Q

-- SubQuery Derived Table (SQL Server 7 e demais)
select Conta, Descricao, VDebito, VCredito, (VCredito - VDebito) as SaldoFinal
FROM (
Select Conta,Descricao,
(select SUM(Valor) From LancaContabil Where Debito = Conta) as VDebito,
(select SUM(Valor) From LancaContabil Where Credito = Conta) as VCredito
From PlanoContabil) As Q

-- Common Table Expression (2005 e superiores)
;WITH Q (Conta, Descricao, VDebito, VCredito)
As (
Select Conta,Descricao,
(select SUM(Valor) From LancaContabil Where Debito = Conta) as VDebito,
(select SUM(Valor) From LancaContabil Where Credito = Conta) as VCredito
From PlanoContabil)
select Conta, Descricao, VDebito, VCredito, (VCredito - VDebito) as SaldoFinal
FROM Q
