Create Table #Tb_Teste(

          codigo int identity(1,1), 

codigogrupo int,

codigomodel int,

Controle As (Convert(VarChar(10),codigogrupo)+Convert(VarChar(10),CodigoModel)))

Insert Into #Tb_Teste Values(1,1)


Select * from #tb_teste


