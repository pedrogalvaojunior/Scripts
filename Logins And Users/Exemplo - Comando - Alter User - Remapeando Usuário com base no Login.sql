use eflex

-- Remapeando usu�rio com base no login existente --
alter user eflex 
 with login=eflex,
 default_schema=eflex

-- Adicionando o Usu�rio a RoleMember DBO --
sp_addrolemember 'db_owner','eflex'
 