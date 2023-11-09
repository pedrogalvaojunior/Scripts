-- Cria um login para ser acessado remotamente
IF EXISTS (SELECT * FROM Sys.Server_Principals WHERE Name='UsrLoginLK')
	DROP LOGIN UsrLoginLK

CREATE LOGIN UsrLoginLK WITH Password = 'PWD123456'

-- Concede permissões administrativas ao novo login
EXEC sp_addsrvrolemember 'UsrLoginLK','sysadmin'

-- Elimina o login
-- DROP LOGIN UserLoginLK