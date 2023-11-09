USE CORPORERM
GO

--- Relação Funcionários Matriz /0001 ---
Select P.CPF, 
         Replace(P.Nome,'.','') As Nome,
         Convert(Char(10),P.DTNascimento,103) As DtNascimento,
         P.Sexo,
         Case P.EstadoCivil 
          When 'S' Then 1
          When 'C' Then 2
          When 'V' Then 3
          When 'D' Then 4 
          When 'E' Then 5       
         End EstadoCivil,
         1 As TipoDocumento,
         Replace(Replace(P.CartIdentidade,'.',''),'-','') As CarteiraIdentidade,
         P.UFCartIdent,
         P.OrgEmissorIdent,
         Convert(Char(10),P.DTEmissaoIdent,103) As DTEmissaoIdentidade,
         Replace(P.Cep,'-','') As Cep,
         Replace(P.Telefone1,'-','') As Telefone,
         F.CodFuncao As Profissao,
         Replace(F.Salario,'.','') As Salario,
         1 As TipoDeRenda,
         Convert(Char(10),F.DataAdmissao,103) As DataAdmissao,
         (Select Top 1 SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='6') As Pai,
         (Select Top 1 SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='7') As Mae,
         Case P.Nacionalidade         
          When 10 Then 1
         End As Nacionalidade,
         SubString(P.Naturalidade,1,20) As Naturalidade,
         P.EstadoNatal,
         (Select SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='5') As Conjuge,
         SubString(P.Rua,1,30) As Endereco,
         P.Numero,
         SubString(P.Complemento,1,15) As Complemento,
         SubString(P.Bairro,1,15) As Bairro,
         SubString(P.Cidade,1,20) As Cidade,
         P.Estado,
         11 As DDD,
         '' As Celular,
         '' As Email
from PPessoa P Inner Join PFunc F
                      On P.Codigo = F.CodPessoa
                     Inner Join PFuncao PF
                      On F.CodFuncao = PF.Codigo
Where F.CodSituacao In ('A','F')
And    F.CodFilial = 1
Order By P.Nome Asc
Go


--- Relação Funcionários Filial /0002 ---
Select P.CPF, 
         Replace(P.Nome,'.','') As Nome,
         Convert(Char(10),P.DTNascimento,103) As DtNascimento,
         P.Sexo,
         Case P.EstadoCivil 
          When 'S' Then 1
          When 'C' Then 2
          When 'V' Then 3
          When 'D' Then 4 
          When 'E' Then 5       
         End EstadoCivil,
         1 As TipoDocumento,
         Replace(Replace(P.CartIdentidade,'.',''),'-','') As CarteiraIdentidade,
         P.UFCartIdent,
         P.OrgEmissorIdent,
         Convert(Char(10),P.DTEmissaoIdent,103) As DTEmissaoIdentidade,
         Replace(P.Cep,'-','') As Cep,
         Replace(P.Telefone1,'-','') As Telefone,
         F.CodFuncao As Profissao,
         Replace(F.Salario,'.','') As Salario,
         1 As TipoDeRenda,
         Convert(Char(10),F.DataAdmissao,103) As DataAdmissao,
         (Select Top 1 SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='6') As Pai,
         (Select Top 1 SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='7') As Mae,
         Case P.Nacionalidade         
          When 10 Then 1
         End As Nacionalidade,
         SubString(P.Naturalidade,1,20) As Naturalidade,
         P.EstadoNatal,
         (Select SubString(Nome,1,64) From PFDepend Where Chapa = F.Chapa And GrauParentesco='5') As Conjuge,
         SubString(P.Rua,1,30) As Endereco,
         P.Numero,
         SubString(P.Complemento,1,15) As Complemento,
         SubString(P.Bairro,1,15) As Bairro,
         SubString(P.Cidade,1,20) As Cidade,
         P.Estado,
         11 As DDD,
         '' As Celular,
         '' As Email
from PPessoa P Inner Join PFunc F
                      On P.Codigo = F.CodPessoa
                     Inner Join PFuncao PF
                      On F.CodFuncao = PF.Codigo
Where F.CodSituacao In ('A','F')
And    F.CodFilial = 2
Order By P.Nome Asc
Go