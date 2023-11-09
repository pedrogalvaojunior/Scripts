-- Habilitando o CDC para o Banco de Dados --
Use SQLMagazine
Go

Exec sys.sp_cdc_enable_db
Go

-- Desabilitando o CDC para o Banco de Dados --
Use SQLMagazine
Go

Exec sys.sp_cdc_disable_db
Go

-- Criando a Tabela de Exemplo --
Create Table Produtos
 (Codigo Int Identity(1,1),
   Descricao VarChar(20))
Go

-- Adicionando a Chave Primaria --
Alter Table Produtos
    Add Constraint [PK_Codigo_Produtos] Primary Key (Codigo)
Go

-- Inserindo a Massa de Registros para Teste --   
Declare @ContadorRegistros Int
Set @ContadorRegistros=1

While @ContadorRegistros <=1000
 Begin
 
  If @ContadorRegistros =1
   Insert Into Produtos Values ('Produto Nº: 1')
  Else
   Insert Into Produtos Values ('Produto Nº: '+Convert(VarChar(4),@@Identity+1))
   
   Set @ContadorRegistros += 1;
 End
 
-- Visualizando os Dados --   
Select * from Produtos
      
-- Habilitando o Change Data Capture para trabalhar sobre a table Produtos --
EXECUTE sys.sp_cdc_enable_table
    @source_schema = N'dbo',
    @source_name = N'Produtos',
    @role_name = N'cdc_Admin';
GO

-- Retornando todas as linhas capturadas pelo CDC --
DECLARE @from_lsn binary(10), 
                  @to_lsn binary(10)

SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_Produtos')
SET @to_lsn   = sys.fn_cdc_get_max_lsn()

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Produtos
  (@from_lsn, @to_lsn, N'all')
Go

-- Inserindo novos dados --
Insert Into Produtos Values ('Produto Nº: '+Convert(VarChar(4),@@Identity+1))
Go

-- Atualizando dados já existentes --
Update Produtos
Set Descricao= Descricao+' - Upd'
Where Codigo Between 11 And 21
Go

-- Retornando todas as linhas capturadas pelo CDC com Net Changes--
DECLARE @from_lsn binary(10), 
                  @to_lsn binary(20)

SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_Produtos')
SET @to_lsn   = sys.fn_cdc_get_max_lsn()

SELECT * FROM cdc.fn_cdc_get_net_changes_dbo_Produtos
                              (@from_lsn, @to_lsn, N'all')
GO

-- Retornando as colunas utilizadas pelo CDC para Captura --
Execute sys.sp_cdc_get_captured_columns 
                         @capture_instance = N'dbo_Produtos';
Go

-- Retornando informações de configuração da captura de dados de alteração de uma tabela específica --
Execute sys.sp_cdc_help_change_data_capture 
                          @source_schema = N'dbo', 
                          @source_name = N'Produtos';
Go

-- Retornando informações de configuração da captura de dados de alteração de todas as tabelas --
EXECUTE sys.sp_cdc_help_change_data_capture;