--cria o linkedserver ADSI
/****** Object: LinkedServer [ADSI]  Script Date: 01/04/2011 09:50:52 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'ADSI', @srvproduct=N'Active Directory Services 2.5', @provider=N'ADSDSOObject', @datasrc=N'adsdatasource'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'ADSI',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL


--script para listar os usuários
select * 
   FROM OPENQUERY( ADSI, 
     'SELECT name, userAccountControl, sAMAccountName, givenname, sn, mail, telephoneNumber, title, department, physicalDeliveryOfficeName, company, l, st, postalcode, extensionAttribute1
     FROM ''GC://corp.contoso.com.br''
     WHERE objectCategory = ''Person'' AND objectClass = ''User''')
