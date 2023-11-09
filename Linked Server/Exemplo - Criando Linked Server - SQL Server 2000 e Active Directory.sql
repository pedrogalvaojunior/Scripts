exec sp_addlinkedserver 
@server='SERVERWINDB', 
@srvproduct='Active Directory Services 2.5', 
@provider='ADsDSOObject', 
@datasrc='SERVERWINDB'

exec sp_addlinkedsrvlogin 
@rmtsrvname = 'SERVERWINDB',
@useself = false,
@locallogin = 'Junior',
@rmtuser ='CN=Administrador,CN=Users,DC=LSROQUEDB,DC=LSR,DC=COM,DC=BR',
@rmtpassword = '280480'


create view v_UsuarioAD
as
SELECT *
FROM OPENQUERY(MSAD,
'SELECT distinguishedName, sAMAccountName, userPrincipalName,
givenName, sn, telephoneNumber, l, st, userAccountControl
FROM ''LDAP://SERVERWINDB/DC=LSROQUEDB,DC=LSR,DC=com,DC=br''
WHERE objectClass = ''user''')