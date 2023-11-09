Create Table Paciente
 (Codigo Int Identity(1,1),
   Nome Varchar(50))

Create Table Telefones
 (Codigo Int Identity(1,1),
  CodPaciente Int,
  NumTelefone VarChar(10))
   
    
Insert Into Paciente Values ('Pedro')  
Insert Into Paciente Values ('Junior') 


Insert Into Telefones Values (1,'7799-5566')
Insert Into Telefones Values (1,'7799-5567')
Insert Into Telefones Values (1,'7799-5868')

Insert Into Telefones Values (2,'8799-5466')
Insert Into Telefones Values (2,'8779-5667')
Insert Into Telefones Values (2,'8799-5868')

Create Procedure P_RelacaoTelefone @CodPaciente Int
As
Begin

;With TresNumeros As 
 (  
  Select CodPaciente, Row_Number() Over (Partition by CodPaciente Order by NumTelefone) As NumOrdem, 
  NumTelefone 
  from Telefones
  Where CodPaciente = @CodPaciente
 )  

Select P.Nome, 
 (Select NumTelefone From TresNumeros Where NumOrdem = 1) As Telefone1,
 (Select NumTelefone From TresNumeros Where NumOrdem = 3) As Telefone2,
 (Select NumTelefone From TresNumeros Where NumOrdem = 3) As Telefone3 
 from Paciente P Inner Join TresNumeros T
                        On P.Codigo = T.CodPaciente
 Where P.Codigo=@CodPaciente
 Group By P.Nome 
 
End

Exec P_RelacaoTelefone 1