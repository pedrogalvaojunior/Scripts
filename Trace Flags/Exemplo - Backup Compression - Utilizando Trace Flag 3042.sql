sp_spaceused

create table valores
 (codigo int primary key identity(1,1),
  nome varchar(50) default 'esta é linha de teste',
  data date default getdate()) 
  
  insert into valores default values
  go 1000000
  
  backup database meubanco
   to disk ='c:\temp\meubanco.bak'
   With Init, noformat, compression 
  
  DBCC TRACEON (3042, -1);
  GO
  
  BACKUP database meubanco 
  to disk  = 'c:\temp\meubanco_TEST3042.BAK' 
  With Init, noformat, compression 