Declare @MinhaTabela Table
(Codigo Int Identity(1,1),
 Descricao Varchar(100))

 Insert Into @MinhaTabela Values ('USH CAPA  - MANDALA AZUL E ROSA')
 Insert Into @MinhaTabela Values ('USH CAPA  - MANDALA rosa E ROSA')

 Select * from @MinhaTabela
 Where Descricao Like '%[capa USH]%'
 
 Select * from @MinhaTabela
 Where Descricao Like '%[capa]%'
 
 Select * from @MinhaTabela
 Where Descricao Like '%[USH]%'

 Select * from @MinhaTabela
 Where Descricao Like '%[ USH]%'
 
 Select * from @MinhaTabela
 Where Descricao Like '%[capa ]%' 
 Go