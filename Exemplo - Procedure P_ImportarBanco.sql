Drop PROCEDURE [dbo].[P_ImportarBanco] @BancoOrigem VarChar(25), @BancoDestino VarChar(25)
As
 Begin

  SET NoCount On
  SET QUOTED_IDENTIFIER On

  Declare @Comando VarChar(500),
             @Caminho VarChar(250),
             @NomeArquivoData VarChar(100),
             @NomeArquivoLog VarChar(100),
             @ArquivoDados VarChar(100),
             @ArquivoLog VarChar(100)
 
  Print '**** Preparando o Backup do Banco: '+Upper(DB_Name())+' ****'
  Print ' '
  
  Select Top 1 Arquivo_Data=(Select Top 1 FileName from Sysfiles Order By 1 Asc),
                    NomeArquivoData=(Select Top 1 Name from Sysfiles Order By 1 Asc),
                    Arquivo_Log=(Select Top 1 FileName from Sysfiles Order By 1 Desc),
                    NomeArquivoLog=(Select Top 1 Name from Sysfiles Order By 1 Desc)
  Into #InfoBanco
  from SysFiles

  Print 'Obtendo informações.....'
  Print '-----------------------------------------------------------'
  
 Select @NomeArquivoData=RTrim(NomeArquivoData), 
          @ArquivoDados=RTrim(Arquivo_Data),
          @NomeArquivoLog=RTrim(NomeArquivoLog),
          @ArquivoLog=RTrim(Arquivo_Log)
 From #InfoBanco

  Print 'Nome do arquivo de dados: '+Upper(@NomeArquivoData)+' --> localização: '+@ArquivoDados
  Print 'Nome do arquivo de logs..: '+Upper(@NomeArquivoLog)+' --> localização:'+@ArquivoLog
  Print '-----------------------------------------------------------'

  Set @Caminho='F:\SYS\MSSQL_BACKUP\'+@BancoOrigem+'.bak'

  Set @Comando='Backup Database '+@BancoOrigem+' To Disk = '+''''+@Caminho+''''+
                       ' With Init'
  
  Exec(@Comando) 
   
  Set @Comando='Restore Database '+@BancoDestino+' From Disk = '+''''+@Caminho+''''+
                        ' With Replace, '+Char(13)+
                        ' Move '+''''+@NomeArquivoData+''''+' TO '+''''+@ArquivoDados+''''+','+Char(13)+
                        ' Move '+''''+@NomeArquivoLog+''''+' TO '+''''+@ArquivoLog+''''
                        
  Exec(@Comando)

  Print(@comando)
 End





