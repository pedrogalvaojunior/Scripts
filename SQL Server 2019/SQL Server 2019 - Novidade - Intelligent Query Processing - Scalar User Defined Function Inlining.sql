-- Exemplo 1 --
-- Criando o Banco de Dados ScalarUDFInlining2019 --
Create Database ScalarUDFInlining2019
Go

-- Alterando o N�vel de Compatibilidade do Banco ScalarUDFInlining2019 para o SQL Server 2017 --
Alter Database ScalarUDFInlining2019
 Set Compatibility_Level = 140
 Go

 -- Acessando o Banco de Dados ScalarUDFInlining2019 --
 Use ScalarUDFInlining2019
 Go

 -- Criando a Tabela de Idiomas --
 Create Table Idiomas
 (CodigoIdioma Int Primary Key,
  DescricaoIdioma SysName)
 Go
 
 -- Criando a Tabela de Empregados --
 Create Table Empregados
  (CodigoEmpregado Int Primary Key,
   CodigoIdioma Int Not Null)
Go

-- Adicionando o Relacionamento entre as Tabelas de Empregados e Idiomas --
Alter Table Empregados
 Add Constraint [FK_Empregados_Idiomas_CodigoIdioma] Foreign Key (CodigoIdioma)
  References Idiomas (CodigoIdioma)
Go
  
-- Inserindo registros na Tabela Idiomas --
Insert Into Idiomas Values (1033, N'English'),(4555, N'Klingon')
Go

-- Inserindo registros na Tabela de Empregados --
Insert Into Empregados
Select Object_id, 
           Case ABS ((object_id)%2) 
		    When 1 Then 1033 Else 4555
		   End As IdiomaID
From sys.all_objects
Go

-- Criando a UDF Table InLine - F_PesquisarIdioma --
Create or Alter Function F_PesquisarIdioma (@CodigoIdioma Int)
Returns Sysname
As
Begin
 Return (Select DescricaoIdioma From Idiomas Where CodigoIdioma = @CodigoIdioma)
End
Go

-- Ativar o Plano de Manuten��o e observar o operador Clustered Index Scan -- 

-- Utilizando a UDF F_PesquisarIdioma no Select da Tabela Empregados, exibindo a DescricaoIdioma atrav�s da UDF --
Select Top 6 CodigoEmpregado, DescricaoDoIdioma = dbo.F_PesquisarIdioma (CodigoIdioma)
From Empregados
Go

-- Argumentar sobre como processamento esta sendo realizado --
 
 -- Verificando as Estat�sticas de processamento da UDF, atrav�s da sys.dm_exec_functions_stats --
Select OBJECT_NAME(object_id) As 'Function Name', execution_count As 'Execution Count'
From Sys.dm_exec_function_stats
Where Object_Name(Object_id) IS NOT NULL
Go

-- Aplicar a Scalar UDF InLining --
-- Passo 1 - Alterando o Database Scoped Configurando - Limpado o Procedure_Cache --
Alter Database Scoped Configuration Clear Procedure_Cache
Go

-- Passo 2 - Validar novamente a sys.dm_exec_functions_stats --
Select OBJECT_NAME(object_id) As 'Function Name', execution_count As 'Execution Count'
From Sys.dm_exec_function_stats
Where Object_Name(Object_id) IS NOT NULL
Go

-- Passo 3 - Alterar o Compatibility_Level do Banco ScalarUDFInlining2019 para a vers�o do SQL Server 2019 --
Alter Database ScalarUDFInlining2019
Set Compatibility_Level = 150
Go

-- Passo 4 - Executar novamente a UDF F_PesquisarIdiomas no Select -- Verificar as altera��es no Plano de Execu��o --
Select Top 6 CodigoEmpregado, DescricaoDoIdioma = dbo.F_PesquisarIdioma (CodigoIdioma)
From Empregados
Go

-- Explicar as mudan�as e o comportamento da Scalar UDF Inlining --
/*

1 - Basicamente, o SQL Server 2019 interpreta o c�digo a partir da fun��o escalar, e o integra no plano principal de consulta para formar um �nico plano. Assim, em vez de   chamadas de fun��o de looping, ele executa a l�gica de fun��o em linha com o resto da consulta.

2 - Fun��es escalares tamb�m d�o origem a outros problemas de desempenho. Por exemplo, o SQL Server n�o far� um bom trabalho de calcular o custo estimado do que acontece dentro da fun��o, e bloquear� efetivamente o uso de planos paralelos, o que pode ser um problema real com grandes cargas de trabalho, como trabalhos de ETL de intelig�ncia de neg�cios.

3 - Nem toda fun��o escalar � inline�vel e, mesmo quando uma fun��o *�* inline�vel, n�o necessariamente ser� inlined em todos os cen�rios. Isso muitas vezes tem a ver com a complexidade da fun��o, a complexidade da consulta envolvida, ou com a combina��o de ambos. Voc� pode verificar se uma fun��o � inline�vel na exibi��o do cat�logo sys.sql_modules:

4 - E se, por qualquer motivo, voc� n�o quiser que uma determinada fun��o (ou qualquer fun��o em um banco de dados) seja inalinada, voc� n�o precisa confiar no n�vel de compatibilidade do banco de dados para controlar esse comportamento. Eu nunca gostei desse acoplamento solto, que � semelhante a trocar de quarto para assistir a um programa de televis�o diferente em vez de simplesmente mudar o canal. Voc� pode controlar isso no n�vel do m�dulo usando a op��o INLINE:*/

-- Passo 5 - Validar novamente a sys.dm_exec_functions_stats --
Select OBJECT_NAME(object_id) As 'Function Name', execution_count As 'Execution Count'
From Sys.dm_exec_function_stats
Where Object_Name(Object_id) IS NOT NULL
Go

-- N�o dever� existir cache --

-- Passo 6 - Identificando quais UDF podem ser reconhecidas como aptas a se tornarem Inlining, atrav�s da sys.sql_modules --
SELECT Object_Name(object_id), definition, is_inlineable -- Quando o valor for 1 ela poder� ser reconhecida como Inlining --
From Sys.sql_modules
Go

-- Impedindo que uma UDF possa ser reconhecida como Inlining, utilizando a op��o With InLine = Off, no comando Altera Function --
Create or Alter Function F_PesquisarIdioma (@CodigoIdioma Int)
Returns Sysname
With InLine = Off
As
Begin
 Return (Select DescricaoIdioma From Idiomas Where CodigoIdioma = @CodigoIdioma)
End
Go

-- Realizando o controle do Database Level separado do Compatibility Level, atrav�s da diretiva TSQL_Scalar_UDF_Inlining = Off, no comando Altera Database Scoped --
Alter Database Scoped Configuration Set TSQL_Scalar_UDF_Inlining = Off
Go

-- Exemplo 2 --
-- Criando a Tabela Transacoes --
Create Table Transacoes
 (CodigoTransacao Int Primary Key Clustered,
  DataTransacao Date Not Null,
  CodigoDaMoedaTransacao TinyInt Not Null,
  DescricaoTransacao NVarchar(2048) Not Null,
  ValorMoedaTransacao Numeric(12,2) Not Null)
Go

-- Inserindo 100000 linhas de registro na Tabela Transacoes --
Insert Into Transacoes (CodigoTransacao, DataTransacao, CodigoDaMoedaTransacao, DescricaoTransacao, ValorMoedaTransacao)
Select Top 100000 Row_Number() Over (Order By (Select Null)) As CodigoTransacao,
                                 Cast(DateAdd(day, message_id % 365, {d '2020-01-01'}) As Date) As DataTransacao,
								 Message_Id % 8 As CodigoDaMoeadaTransacao,
								 Text As DescricaoTransacao,
								 1000. * (Rand(CheckSum(Text))) As ValorMoedaTransacao
From Sys.Messages
Go

-- Criando a Tabela TaxasDeCambio --
Create Table TaxasDeCambio
(CodigoMoedaTaxasDeCambio TinyInt Not Null,
 DataTaxasDeCambio Date Not Null,
 TaxasDeCambio Numeric(12,8) Not Null)
Go

-- Adicionando a Chave Prim�ria Composta na Tabela TaxasDeCambio --
Alter Table TaxasDeCambio
 Add Constraint [PK_TaxasDeCambio_CodigoMoeda_Data] Primary Key (CodigoMoedaTaxasDeCambio, DataTaxasDeCambio)
Go

-- Inserindo 250 linhas de registros na Tabela TaxasDeCambio --
Insert Into TaxasDeCambio (CodigoMoedaTaxasDeCambio, DataTaxasDeCambio, TaxasDeCambio)
Select Top 250 
           (Message_id  % 8) As CodigoMoedaTaxasDeCambio,
		   Cast(DateAdd(day, message_id % 365, {d '2020-01-01'}) As Date) As DataTaxasDeCambio,
		   0.4 * (Message_Id % 8) + 1.5 * Rand(CheckSum(Text)) As TaxasDeCambio
From Sys.Messages
Go

-- Criando a UDF Scalar F_PesquisarTaxasDeCambio --
Create or Alter Function F_PesquisarTaxasDeCambio (@CodigoMoedaTaxasDeCambio TinyInt, @DataTaxasDeCambio Date)
Returns Numeric(12,2)
As
Begin
 
  -- Declarando a Vari�vel @TaxaDeCambioAtual --
  Declare @TaxaDeCambioAtual Numeric(12,2)

  -- Pesquisando a Taxa de Cambio mais recente com base na Moeda e Data --
  Select Top 1 @TaxaDeCambioAtual = TaxasDeCambio 
  From TaxasDeCambio
  Where CodigoMoedaTaxasDeCambio = @CodigoMoedaTaxasDeCambio 
  And DataTaxasDeCambio <= @DataTaxasDeCambio
  Order By DataTaxasDeCambio Desc

  -- Devolvendo o retorno de dados para o comando Returns --
  Return(@TaxaDeCambioAtual)

End

-- Aplicar a Scalar UDF InLining --
-- Passo 1 - Alterando o Database Scoped Configurando - Limpado o Procedure_Cache --
Alter Database Scoped Configuration Clear Procedure_Cache
Go

-- Passo 2 - Validar novamente a sys.dm_exec_functions_stats --
Select OBJECT_NAME(object_id) As 'Function Name', execution_count As 'Execution Count'
From Sys.dm_exec_function_stats
Where Object_Name(Object_id) IS NOT NULL
Go

-- Passo 3 - Alterar o Compatibility_Level do Banco ScalarUDFInlining2019 para a vers�o do SQL Server 2019 --
Alter Database ScalarUDFInlining2019
Set Compatibility_Level = 150
Go

-- Ativar o Plano de Manuten��o e observar o operador Clustered Index Scan -- 

-- Passo 4 - Utilizando a UDF F_PesquisarTaxasDeCambio para calcular as taxas de cambio -- 
Select *, TaxasDeCambio * dbo.F_PesquisarTaxasDeCambio(1, GetDate()) As Taxa
From TaxasDeCambio
Go



Select dbo.F_PesquisarTaxasDeCambio(1, GetDate())
Go