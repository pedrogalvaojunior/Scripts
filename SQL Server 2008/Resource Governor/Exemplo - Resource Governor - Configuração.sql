---DMV's Resource Governor
SELECT * FROM SYS.DM_RESOURCE_GOVERNOR_WORKLOAD_GROUPS
SELECT * FROM SYS.DM_RESOURCE_GOVERNOR_RESOURCE_POOLS
SELECT * FROM SYS.DM_RESOURCE_GOVERNOR_CONFIGURATION

--Criando os Pools
Create RESOURCE POOL PoolMarketingAdHoc
With
(
 MAX_CPU_Percent = 20,
 MIN_CPU_Percent = 5,
 MAX_Memory_Percent = 30, 
 MIN_Memory_Percent =  10
)  

CREATE RESOURCE POOL PoolVP
With
(
 MAX_CPU_Percent = 25,
 MIN_CPU_Percent = 5
)  

-- Criando Grupos de WorkLoad --
CREATE WORKLOAD GROUP GroupMarketing Using PoolMarketingAdHoc

CREATE WORKLOAD GROUP GroupAdHoc 
With (Importance = Medium) Using PoolMarketingAdHoc

CREATE WORKLOAD GROUP GroupVP 
With (Importance = Low) Using PoolVP
Go

-- Criando logins para separar os usuários dentro de diferentes grupos --
CREATE LOGIN UserMarketing With Password = 'UserMarketingPwd', Check_Policy = Off
CREATE LOGIN UserAdHoc With Password = 'UserAdHocPWD', Check_Policy = Off
CREATE LOGIN UserVP With Password = 'UserVPPwd', Check_Policy = Off

-- Criando Function para gerenciamento do pool --
Create FUNCTION [dbo].[Classifier_ConectionPool]() 
RETURNS SYSNAME 
WITH SCHEMABINDING

BEGIN

 DECLARE @WorkGrupo VarChar(32)
 SET @WorkGrupo = 'default'
 
 If 'UserVP' = SUSER_SNAME()
  SET @WorkGrupo = 'GroupVP'
 Else If 'UserMarketing' = SUSER_SNAME()
  SET @WorkGrupo = 'GroupMarketing'
 Else If 'UserAdHoc' = SUSER_SNAME()
  SET @WorkGrupo = 'GroupAdHoc'
 RETURN @WorkGrupo
End
Go

-- Alterando a configuração do Resource Governor --
Alter Resource Governor
With (Classifier_Function = dbo.classifier_conectionpool)
Go

-- Aplicando as reconfigurações no Resource Governor --
Alter Resource Governor Reconfigure
Go


-- Obtendo o nome da Classifier Function --
SELECT 
      object_schema_name(classifier_function_id) AS [schema_name],
      object_name(classifier_function_id) AS [function_name]
FROM sys.dm_resource_governor_configuration