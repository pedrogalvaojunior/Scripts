Declare @Nome Char(1),
           @Local Char(6)

Set @Nome=''
Set @Local='REGINA'

Insert Into Funcionarios(Codigo,Nome,LocalRevisao)
Select Distinct CodFuncionario, @Nome, @Local From CtLuvas
Where Not Exists (Select Codigo From Funcionarios 
                         Where Funcionarios.Codigo = CtLuvas.CodFuncionario Or Funcionarios.Codigo = CtLuvas.CodFuncionario1)
Order By CodFuncionario

Select Distinct CodFuncionario From CtLuvas
Where Not Exists (Select Codigo From Funcionarios 
                         Where Funcionarios.Codigo = CtLuvas.CodFuncionario Or Funcionarios.Codigo = CtLuvas.CodFuncionario1)
Order By CodFuncionario


Select * from Funcionarios