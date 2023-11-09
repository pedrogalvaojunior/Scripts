USE CORPORERM
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2005') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2005')           
           End As 'Tempo de Casa - Meses'
from PFunc
Where CodSituacao In ('A')
And    CodFilial = 1
And    Year(DataAdmissão)=2005
Order By Nome
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2006') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2006')           
           End As 'Tempo de Casa - Meses'
from PFunc
Where CodSituacao In ('A')
And    CodFilial = 1
And    Year(DataAdmissão)=2006
Order By Nome
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2007') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2007')           
           End As 'Tempo de Casa - Meses'
from PFunc
Where CodSituacao In ('A')
And    CodFilial = 1
And    Year(DataAdmissão)=2007
Order By Nome
Go

USE CORPORERM
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Convert(Char(10),DataDemissao,103) As 'Data Demissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2005') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2005')           
           End As 'Tempo de Casa - Meses',
           Case DateDiff(Year,DataAdmissao,'31/12/2005') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Year,DataAdmissao,'31/12/2005')           
           End As 'Tempo de Casa - Anos'           
from PFunc
Where CodSituacao In ('D')
And    CodFilial = 1
And    Year(DataDemissão)=2005
Order By Nome
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Convert(Char(10),DataDemissao,103) As 'Data Demissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2006') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2006')           
           End As 'Tempo de Casa - Meses',
           Case DateDiff(Year,DataAdmissao,'31/12/2006') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Year,DataAdmissao,'31/12/2006')           
           End As 'Tempo de Casa - Anos'           
from PFunc
Where CodSituacao In ('D')
And    CodFilial = 1
And    Year(DataDemissão)=2006
Order By Nome
Go

SELECT Chapa, Nome, 
           Convert(Char(10),DataAdmissao,103) As 'Data Admissão',
           Convert(Char(10),DataDemissao,103) As 'Data Demissão',
           Case DateDiff(Month,DataAdmissao,'31/12/2007') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Month,DataAdmissao,'31/12/2007')           
           End As 'Tempo de Casa - Meses',
           Case DateDiff(Year,DataAdmissao,'31/12/2007') 
            When -1 Then 0
			When -2 Then 0
			When -3 Then 0
            When -4 Then 0
			When -5 Then 0
			When -6 Then 0
            When -7 Then 0
			When -8 Then 0
			When -9 Then 0
            Else DateDiff(Year,DataAdmissao,'31/12/2007')           
           End As 'Tempo de Casa - Anos'           
from PFunc
Where CodSituacao In ('D')
And    CodFilial = 1
And    Year(DataDemissão)=2007
Order By Nome
Go