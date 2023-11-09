Declare @MinhaVariavel Int

Set @MinhaVariavel = 1

Declare @MinhaTabela Table
 (Codigo Int)

Insert Into @MinhaTabela Values (1),(2),(3)

Select * from @MinhaTabela

Select IIF(@MinhaVariavel <= 1, @MinhaVariavel + Codigo, @MinhaVariavel - 1) 'IIF - SQL Server 2012 ' From @MinhaTabela