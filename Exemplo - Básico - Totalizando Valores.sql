Declare @Usuarios Table
 (Codigo Int Identity(1,1),
   Nome VarChar(20))

Insert Into @Usuarios Values('Junior')
Insert Into @Usuarios Values('Eduardo')
Insert Into @Usuarios Values('João Pedro')

Declare @Acessos Table
 (Codigo Int Identity(1,1),
  CodigoUsuario Int,
  Data DateTime)


Insert Into @Acessos Values(1,GetDate())
Insert Into @Acessos Values(1,GetDate()+1)
Insert Into @Acessos Values(1,GetDate()+2)

Insert Into @Acessos Values(2,GetDate())
Insert Into @Acessos Values(2,GetDate()+1)
Insert Into @Acessos Values(2,GetDate()+2)

Insert Into @Acessos Values(3,GetDate())
Insert Into @Acessos Values(3,GetDate()+1)
Insert Into @Acessos Values(3,GetDate()+2)

Insert Into @Acessos Values(3,GetDate())
Insert Into @Acessos Values(3,GetDate()+1)
Insert Into @Acessos Values(3,GetDate()+2)

--Retornando todos os usuários
Select * from @Usuarios

--Retornando todos os acessos
Select * from @Acessos

--Retornando todos os nomes dos usuários e suas quantidades de acessos
Select U.Nome, 
         Count(A.CodigoUsuario) As Quantidade 
from @Usuarios U Inner Join @Acessos A 
                         On U.Codigo = A.CodigoUsuario
Group By U.Nome  


