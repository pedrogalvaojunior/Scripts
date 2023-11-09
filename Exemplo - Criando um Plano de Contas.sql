Create Table #Contas
(Codigo Int Identity(1,1),
   Descricao VarChar(10))

Insert Into #Contas Values ('Conta 1')
Insert Into #Contas Values ('Conta 2')

Select * from #Contas

Create Table #PlanoContas
 (Codigo Int Identity(1,1),
   ContaCredito Int,
   ContaDebito Int,
   Valor Float)


Insert Into #PlanoContas Values(1,2,100)
Insert Into #PlanoContas Values(1,2,200)
Insert Into #PlanoContas Values(1,2,300)

Insert Into #PlanoContas Values(2,1,100)
Insert Into #PlanoContas Values(2,1,50)

Select * from #PlanoContas


Alter Procedure #P_Contas @CodigoConta Int = Null
As
Begin
 Select Credito=(Select Sum(Valor) From #PlanoContas where ContaCredito=@CodigoConta), 
           Debito=(Select Sum(Valor) From #PlanoContas where ContaDebito=@CodigoConta),
           Valor=((Select Sum(Valor) From #PlanoContas where ContaCredito=@CodigoConta)-(Select Sum(Valor) From #PlanoContas where ContaDebito=@CodigoConta))
End

#P_Contas 1