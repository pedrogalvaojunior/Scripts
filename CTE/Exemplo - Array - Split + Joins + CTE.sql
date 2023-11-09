Set NoCount On;

Use tempdb;

If OBJECT_ID('dbo.Numeracao','U') Is Not Null
 Drop Table dbo.Numeracao;

Create Table dbo.Numeracao
(Numero Int Not Null Primary Key) ;
Go

Declare @ValorMaximo Int, 
                @Contador Int;
                
Set @ValorMaximo=1000000;
Set @Contador=1;

Insert Into dbo.Numeracao Values(1)    

While @Contador * 2 <= @ValorMaximo
 Begin
 
  Insert Into dbo.Numeracao
   Select Numero+@Contador from dbo.Numeracao;
    
  Set @Contador *= 2;        
 End 

Insert Into dbo.Numeracao
 Select Numero + @Contador from dbo.Numeracao
 Where Numero + @Contador <= @ValorMaximo
Go

IF OBJECT_ID('dbo.Arrays') Is Not Null
 Drop Table dbo.Arrays;

Create Table dbo.Arrays
(Idx Varchar(10) Not Null Primary Key,
  Elementos Varchar(8000) Not Null)
Go

Insert Into Arrays(Idx, Elementos) 
Values 
 ('A','20,223,2544,25567,14'),
 ('B','30,-23433,28'),
 ('C','12,10,8099,12,1200,13,12,14,10,9'),
 ('D','-4,-6,-45678,-2') 

Select A.Idx, A.Elementos, 
            N.Numero
from dbo.Arrays A Join dbo.Numeracao N
                                  On N.Numero <= DATALENGTH(A.Elementos)
                                  And SUBSTRING (Elementos, Numero, 1) = ','                        
                                  
Select A.Idx, 
           Substring(A.Elementos, N.Numero,  
            CHARINDEX(',', A.Elementos + ',', N.Numero)-N.Numero) As Elementos            
from dbo.Arrays A Join dbo.Numeracao N
                                  On N.Numero <= DATALENGTH(A.Elementos) + 1
                                  And SUBSTRING (',' + A.Elementos, Numero, 1) = ','
                                  
 Select ROW_NUMBER() Over(Partition By A.Idx Order By N.Numero) As Posição,
           A.Idx, 
          Substring(A.Elementos, N.Numero, CHARINDEX(',', A.Elementos +',', N.Numero)-N.Numero) As Elementos            
from dbo.Arrays A Join dbo.Numeracao N
                                  On N.Numero <= DATALENGTH(A.Elementos) 
                                  And SUBSTRING (','+A.Elementos, Numero, 1) = ','                                 

With Split As
(
 Select Idx, 1 As Pos, 1 As PosIni,
            CharIndex(',',Elementos + ',')  - 1 As PosFim
 From dbo.Arrays
 Where DATALENGTH(Elementos) > 0

 Union All

 Select Spl.Idx, Spl.Pos+1, Spl.PosFim + 2,
            CHARINDEX(',', A.Elementos + ',', Spl.PosFim + 2) - 1
 From Split As Spl Inner Join dbo.Arrays A
                              On A.Idx = Spl.Idx
                              And CHARINDEX(',', A.Elementos + ',', Spl.PosFim + 2) > 0
)
Select A.Idx, Spl.Pos,
           CAST(SUBSTRING(A.Elementos, Spl.PosIni, Spl.PosFim-Spl.PosIni+1) As Int) As Elementos
From dbo.Arrays A Join Split As Spl
                                On spl.Idx = A.Idx
Order By A.Idx, Spl.Pos; 

-- Construindo a Estrutura Completa do Array --
Create Table dbo.ArrayCompleto
(Idx Int Identity Primary Key,
 Identificador Char(1) Not Null,
 Elementos Varchar(10))

-- Inserindo os dados na Tabela ArrayCompleto --   
Insert Into ArrayCompleto (Identificador, Elementos)
Select A.Idx, 
           Substring(A.Elementos, N.Numero,  
            CHARINDEX(',', A.Elementos + ',', N.Numero)-N.Numero) As Elementos

from dbo.Arrays A Join dbo.Numeracao N
                                  On N.Numero <= DATALENGTH(A.Elementos) + 1
                                  And SUBSTRING (',' + A.Elementos, Numero, 1) = ','

Select * from ArrayCompleto