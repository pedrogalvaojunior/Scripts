Declare @Comando NVarchar(1000), @Parametros NVarchar(20)

Set @Parametros= N'@Valores Int'

Set @Comando='Create Table Tabela (Codigo Int)
                            Insert Into Tabela Values(1),(2),(3)
                            
                            Select * from Tabela Where Codigo = @Valores
                            
                            Alter Table Tabela
                             Alter Column Codigo SmallInt
                            
                              Select * from Tabela Where Codigo = @Valores'
 
Execute sp_executeSQL @Comando, @Parametros,	 @Valores=2

Declare @Tabela Table (Codigo Int)
                            Insert Into @Tabela Values(1),(2),(3)
                            
                            Select * from @Tabela 
                            
                            Alter Table @Tabela
                             Alter Column Codigo SmallInt