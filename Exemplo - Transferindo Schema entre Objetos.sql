--Consultando a relação de Schemas--
select * from sys.schemas

--Consultando o Schema de Tabelas--
select * from information_schema.tables

--Montando o Comando para Transferência do Schema dbo sobre o eflex--
select 'Alter Schema dbo Transfer ' + table_schema+'.'+table_name from information_schema.tables
where table_schema='eflex'

--Realizando a Transferência do Schema para as Tables--
Alter Schema dbo Transfer eFlex.tv_frl_fa_aliquot_state
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_NFS_NF_SEND
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_CSS_CUSTOMER_SEND
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_RMN_ROMANEIO
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_CIT_CITY
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_CST_CUSTOMER
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_LOG_LOG_ERRO
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_NPR_NF_PRINTED
Alter Schema dbo Transfer eFlex.TB_EFL_BTE_NPL_NF_PLANNED

--Consultando a relação do Stored Procedures através da system table sys.objects--
Select * from sys.objects
where type = 'P'
and schema_id=5

--Montando o Comando para Transferência do Schema dbo sobre o eflex para as SPs--
Select 'Alter Schema dbo Transfer eflex.' + name from sys.objects
where type = 'P'
and schema_id=5

--Realizando a Transferência do Schema para as SPs--
Alter Schema dbo Transfer eflex.USP_EFX_U_EC_CUSTOMER_E2E_STATUS
Alter Schema dbo Transfer eflex.List_City_ViaNet
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_LOG_LOG_ERRO
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_LOG_LOG_ERRO
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_LOG_LOG_ERRO
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_NFS_NF_SEND
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_RMN_ROMANEIO
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_RMN_ROMANEIO
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_CSS_CUSTOMER_SEND
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_CSS_CUSTOMER_SEND
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_CSS_CUSTOMER_SEND
Alter Schema dbo Transfer eflex.USP_EFL_I_BTE_IMPORT_CUSTOMER_TO_SEND
Alter Schema dbo Transfer eflex.USP_EFL_U_BTE_IMPORT_CITY
Alter Schema dbo Transfer eflex.USP_EFL_I_BTE_IMPORT_NF_PRINTED
Alter Schema dbo Transfer eflex.USP_EFL_I_BTE_IMPORT_ROMANEIO
Alter Schema dbo Transfer eflex.USP_EFL_I_BTE_IMPORT_NF_TO_SEND
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_NFS_NF_SEND
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_NFS_NF_SEND
Alter Schema dbo Transfer eflex.USP_EFL_BTE_S_LOG_ERRO
Alter Schema dbo Transfer eflex.USP_EFL_BTE_S_LOG_ERRO_ORDER
Alter Schema dbo Transfer eflex.USP_EFL_BTE_S_LOG_ERRO_CNPJ
Alter Schema dbo Transfer eflex.USP_EFL_BTE_S_LOG_ERRO_CPF
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_CIT_CITY
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_CIT_CITY
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_CIT_CITY
Alter Schema dbo Transfer eflex.USP_EFL_U_BTE_IMPORT_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_CST_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_CST_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_CST_CUSTOMER
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_NPR_NF_PRINTED
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_NPR_NF_PRINTED
Alter Schema dbo Transfer eflex.USP_HPR_U_COMMIT_TRANSACTION_UPDATE
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_NPR_NF_PRINTED
Alter Schema dbo Transfer eflex.USP_EFL_U_TB_EFL_BTE_NPL_NF_PLANNED
Alter Schema dbo Transfer eflex.USP_EFL_S_TB_EFL_BTE_NPL_NF_PLANNED
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_NPL_NF_PLANNED
Alter Schema dbo Transfer eflex.USP_EFL_I_TB_EFL_BTE_RMN_ROMANEIO