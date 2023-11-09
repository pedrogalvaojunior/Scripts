Declare @MinhaVariavel Int

Set @MinhaVariavel = 1

Declare @MinhaTabela Table
 (Codigo Int)

Insert Into @MinhaTabela Values (1),(2),(3)

Select * from @MinhaTabela

Select Case Codigo
        When 1 Then @MinhaVariavel + 10
		When 2 Then @MinhaVariavel + 2
		When 3 Then @MinhaVariavel + 3
	   End As Valores
From @MinhaTabela

Select Case @MinhaVariavel
        When 1 Then @MinhaVariavel + 2
		When 2 Then @MinhaVariavel + 4
		When 3 Then @MinhaVariavel + 6
	   End Valores

Select IIF(@MinhaVariavel <= 1, @MinhaVariavel + Codigo, @MinhaVariavel - 1) 'IIF - SQL Server 2012 ' From @MinhaTabela