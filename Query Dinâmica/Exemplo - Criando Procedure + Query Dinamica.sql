Create Procedure P_DynamicProcedure @Tabela varchar(50),
                                         @Colunas varchar(500), 
                                         @ChaveTabela varchar(50), 
                                         @ChaveValor VarChar(50) = Null
As

Begin

Declare @Comando Varchar(1000)

Set @Comando = 'Select '+@Colunas +' from '+@Tabela+ ' Where '+@ChaveTabela + ' = '+ IsNull(@ChaveValor,0)
Exec(@Comando)
End

Exec P_DynamicProcedure 'sysusers','uid, Status, Name','uid',Null
