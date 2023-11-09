Create Table #Esporte
 (Codigo Int Identity(1,1),
   Descricao Char(10))
Go

Insert Into #Esporte Values('Futebol')
Insert Into #Esporte Values('Volei')
Insert Into #Esporte Values('Basquete')
Insert Into #Esporte Values('Biriba')
Go

Create Table #Usuarios
 (Codigo Int Identity(1,1),
   Nome VarChar(10),
   CodEsporte Int)
Go

Insert Into #Usuarios Values ('Pedro',1)
Insert Into #Usuarios Values ('Antonio',1)
Insert Into #Usuarios Values ('Galvão',1)
Insert Into #Usuarios Values ('Junior',1)
go

Insert Into #Usuarios Values ('Jose',2)
Insert Into #Usuarios Values ('Joao',2)
Insert Into #Usuarios Values ('Maria',2)
go

Insert Into #Usuarios Values ('Sergio',3)
Insert Into #Usuarios Values ('Vitor',3)
go

Insert Into #Usuarios Values ('Geovani',4)


Select * from #Esporte

Select * from #Usuarios


Select Count(U.CodEsporte) As Total, E.Descricao From #Usuarios U Inner Join #Esporte E
                                                                                 On U.CodEsporte = E.Codigo
Group By E.Descricao
Order By Count(U.CodEsporte) Desc
