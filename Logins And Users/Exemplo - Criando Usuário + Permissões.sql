sp_addlogin 'ALICE','LAURA','BARRAS'

sp_droplogin 'Alice'

SP_ADDUSER 'ALICE','ALICE'

SP_DROPUSER 'ALICE'

sp_grantdbaccess 'ALICE', 'ALICE'

sp_addrolemember 'db_owner', 'ALICE'