USE CORPORERM
GO

--- Relação Funcionários Matriz /0001 ---
Select 'A' As 'Transaction Action', 
         P.CPF As 'Tax ID', 
         Replace(P.Nome,'.','') As 'Alpha Name',
         100 As 'Business Unit', 
         'E' As 'Search Type',
         1 As 'Person/Corporation Code',
         'Y' As 'Employee',  
         'ISENTO' As 'Add''I Tax Id', 
         SubString(P.Rua,1,40) As 'Address Line 1',
         P.Numero As 'Address Line 2',
         SubString(UPPER(P.Complemento),1,40) As 'Address Line 3',
         SubString(UPPER(P.Bairro),1,40) As 'Address Line 4',
         SubString(P.CEP,1,12) As 'Postal Code', 
         SubString(UPPER(P.Cidade),1,25) As City,
         SubString(UPPER(P.Pais),1,2) As Pais,
         SubString(P.EstadoNatal,1,3) As State,
         ' ' As Município,
         11 As 'Prefix',
         SubString(REPLACE(P.Telefone1,'-',''),1,20) As 'Phone Number',
         ' ' As 'Phone Number Type 1'          
from PPessoa P Inner Join PFunc F
                      On P.Codigo = F.CodPessoa
                     Inner Join PFuncao PF
                      On F.CodFuncao = PF.Codigo
Where F.CodSituacao In ('A','F')
And    F.CodFilial = 1
Union All
Select 'A' As 'Transaction Action', 
         P.CPF As 'Tax ID', 
         Replace(P.Nome,'.','') As 'Alpha Name',
         200 As 'Business Unit',          
         'E' As 'Search Type',
         1 As 'Person/Corporation Code',
         'Y' As 'Employee',  
         'ISENTO' As 'Add''I Tax Id', 
         SubString(P.Rua,1,40) As 'Address Line 1',
         P.Numero As 'Address Line 2',
         SubString(UPPER(P.Complemento),1,40) As 'Address Line 3',
         SubString(UPPER(P.Bairro),1,40) As 'Address Line 4',
         SubString(P.CEP,1,12) As 'Postal Code', 
         SubString(UPPER(P.Cidade),1,25) As City,
         SubString(UPPER(P.Pais),1,2) As Pais,
         SubString(P.EstadoNatal,1,3) As State,
         ' ' As Município,
         11 As 'Prefix',
         SubString(REPLACE(P.Telefone1,'-',''),1,20) As 'Phone Number',
         ' ' As 'Phone Number Type 1'          
from PPessoa P Inner Join PFunc F
                      On P.Codigo = F.CodPessoa
                     Inner Join PFuncao PF
                      On F.CodFuncao = PF.Codigo
Where F.CodSituacao In ('A','F')
And    F.CodFilial = 2
Go