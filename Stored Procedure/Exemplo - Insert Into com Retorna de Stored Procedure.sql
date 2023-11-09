Create Table MinhasTabelas
 (Codigo Int Primary Key Identity(1,1),
  Nome Varchar(100)) 
  
Insert Into MinhasTabelas
SELECT Name FROM SYS.TABLES
WHERE TYPE='U'

Create Table EspacoOcupado
 (Name VarChar(100),
   Rows Int,
   Reserved Varchar(10),
   Data Varchar(10),
   Index_Size Varchar(10),
   Unused Varchar(10))

Declare @Contador SmallInt,
              @NomeTabela Varchar(100)

Set @Contador=1

While @Contador <= (Select COUNT(Codigo) from MinhasTabelas)
 Begin
  
  Select @NomeTabela=Nome from MinhasTabelas 
  Where Codigo=@Contador
  
  Insert Into EspacoOcupado
  Exec SP_Spaceused @NomeTabela
  
  Set @Contador +=1
 End 
        
Select * from EspacoOcupado

