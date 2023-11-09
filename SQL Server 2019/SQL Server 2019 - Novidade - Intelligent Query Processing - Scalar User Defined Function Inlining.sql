-- Exemplo 1 --
-- Criando o Banco de Dados ScalarUDFInlining2019 --
Create Database ScalarUDFInlining2019
Go

-- Alterando o Nível de Compatibilidade do Banco ScalarUDFInlining2019 para o SQL Server 2017 --
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

-- Ativar o Plano de Manutenção e observar o operador Clustered Index Scan -- 

-- Utilizando a UDF F_PesquisarIdioma no Select da Tabela Empregados, exibindo a DescricaoIdioma através da UDF --
Select Top 6 CodigoEmpregado, DescricaoDoIdioma = dbo.F_PesquisarIdioma (CodigoIdioma)
From Empregados
Go

-- Argumentar sobre como processamento esta sendo realizado --
 
 -- Verificando as Estatísticas de processamento da UDF, através da sys.dm_exec_functions_stats --
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

-- Passo 3 - Alterar o Compatibility_Level do Banco ScalarUDFInlining2019 para a versão do SQL Server 2019 --
Alter Database ScalarUDFInlining2019
Set Compatibility_Level = 150
Go

-- Passo 4 - Executar novamente a UDF F_PesquisarIdiomas no Select -- Verificar as alterações no Plano de Execução --
Select Top 6 CodigoEmpregado, DescricaoDoIdioma = dbo.F_PesquisarIdioma (CodigoIdioma)
From Empregados
Go

-- Explicar as mudanças e o comportamento da Scalar UDF Inlining --
/*

1 - Basicamente, o SQL Server 2019 interpreta o código a partir da função escalar, e o integra no plano principal de consulta para formar um único plano. Assim, em vez de   chamadas de função de looping, ele executa a lógica de função em linha com o resto da consulta.

2 - Funções escalares também dão origem a outros problemas de desempenho. Por exemplo, o SQL Server não fará um bom trabalho de calcular o custo estimado do que acontece dentro da função, e bloqueará efetivamente o uso de planos paralelos, o que pode ser um problema real com grandes cargas de trabalho, como trabalhos de ETL de inteligência de negócios.

3 - Nem toda função escalar é inlineável e, mesmo quando uma função *é* inlineável, não necessariamente será inlined em todos os cenários. Isso muitas vezes tem a ver com a complexidade da função, a complexidade da consulta envolvida, ou com a combinação de ambos. Você pode verificar se uma função é inlineável na exibição do catálogo sys.sql_modules:

4 - E se, por qualquer motivo, você não quiser que uma determinada função (ou qualquer função em um banco de dados) seja inalinada, você não precisa confiar no nível de compatibilidade do banco de dados para controlar esse comportamento. Eu nunca gostei desse acoplamento solto, que é semelhante a trocar de quarto para assistir a um programa de televisão diferente em vez de simplesmente mudar o canal. Você pode controlar isso no nível do módulo usando a opção INLINE:*/

-- Passo 5 - Validar novamente a sys.dm_exec_functions_stats --
Select OBJECT_NAME(object_id) As 'Function Name', execution_count As 'Execution Count'
From Sys.dm_exec_function_stats
Where Object_Name(Object_id) IS NOT NULL
Go

-- Não deverá existir cache --

-- Passo 6 - Identificando quais UDF podem ser reconhecidas como aptas a se tornarem Inlining, através da sys.sql_modules --
SELECT Object_Name(object_id), definition, is_inlineable -- Quando o valor for 1 ela poderá ser reconhecida como Inlining --
From Sys.sql_modules
Go

-- Impedindo que uma UDF possa ser reconhecida como Inlining, utilizando a opção With InLine = Off, no comando Altera Function --
Create or Alter Function F_PesquisarIdioma (@CodigoIdioma Int)
Returns Sysname
With InLine = Off
As
Begin
 Return (Select DescricaoIdioma From Idiomas Where CodigoIdioma = @CodigoIdioma)
End
Go

-- Realizando o controle do Database Level separado do Compatibility Level, através da diretiva TSQL_Scalar_UDF_Inlining = Off, no comando Altera Database Scoped --
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

-- Adicionando a Chave Primária Composta na Tabela TaxasDeCambio --
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
 
  -- Declarando a Variável @TaxaDeCambioAtual --
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

-- Passo 3 - Alterar o Compatibility_Level do Banco ScalarUDFInlining2019 para a versão do SQL Server 2019 --
Alter Database ScalarUDFInlining2019
Set Compatibility_Level = 150
Go

-- Ativar o Plano de Manutenção e observar o operador Clustered Index Scan -- 

-- Passo 4 - Utilizando a UDF F_PesquisarTaxasDeCambio para calcular as taxas de cambio -- 
Select *, TaxasDeCambio * dbo.F_PesquisarTaxasDeCambio(1, GetDate()) As Taxa
From TaxasDeCambio
Go



Select dbo.F_PesquisarTaxasDeCambio(1, GetDate())
Go