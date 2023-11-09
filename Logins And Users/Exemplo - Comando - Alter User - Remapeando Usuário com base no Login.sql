use eflex

-- Remapeando usuário com base no login existente --
alter user eflex 
 with login=eflex,
 default_schema=eflex

-- Adicionando o Usuário a RoleMember DBO --
sp_addrolemember 'db_owner','eflex'
 