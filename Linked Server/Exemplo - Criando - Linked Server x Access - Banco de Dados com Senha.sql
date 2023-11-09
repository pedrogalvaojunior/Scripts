-- Criando o LinkedServer --
EXEC master.dbo.sp_addlinkedserver 
@server = N'Db_Produto_AD', 
@srvproduct=N'OLE DB Provider for Jet', 
@provider=N'Microsoft.Jet.OLEDB.4.0', 
@datasrc=N'\\servidor\Dados\Produto\Adinstar\Suporte\Produto.mdb'
Go

-- Criando o Login do LinkedServer - Informando a Senha do Access --
EXEC master.dbo.sp_addlinkedsrvlogin 
@rmtsrvname = N'Db_Produto_AD', 
@locallogin = NULL , 
@useself = N'False', 
@rmtuser = N'Admin', 
@rmtpassword = N'Senha'