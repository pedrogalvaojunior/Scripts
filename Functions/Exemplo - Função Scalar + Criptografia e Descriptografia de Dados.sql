USE SQLMagazine
GO

--Criando a Table TbUser
Create Table TbUser
 (IdUsuario Int Identity(1,1) Constraint [PK_IdUsuario] Primary Key Clustered,
  NomeUsuario Varchar(30) Not Null,
  TxSenha VarBinary(255) Not Null,
  DataCadastro Date Default GetDate() 
 )
Go

--Criando Fun��o Scalar para Criptografia de dados
Alter Function Fun_CriptografaSenha (@TxSenha VarChar(1000))
Returns VarBinary(4000)
As
 Begin
  --Chave de Criptografia
  Declare @ChaveCriptografia VarChar(1000) = 'ChaveCriptografia'
  
  Return EncryptByPassPhrase(@ChaveCriptografia, @TxSenha)
 End
Go

--Inserindo os Dados utilizando a Fun��o Fun_CriptografaSenha
Insert Into TbUser(NomeUsuario,TxSenha) Output inserted.NomeUsuario, inserted.TxSenha
 Values ('Pedro Antonio',SQLMagazine.dbo.Fun_CriptografaSenha('MinhaSenha'))
Go 

--Criando Fun��o Scalar para Descriptografia de dados
Create Function Fun_DescriptografaSenha (@NomeUsuario VarChar(20))
Returns VarChar(4000)
As
 Begin
  --Chave de Criptografia
  Declare @ChaveCriptografia VarChar(1000) = 'ChaveCriptografia'
  
  --Recuperando a Senha Criptografada
  Declare @SenhaCriptografada VarChar(Max)=(Select TxSenha From TbUser 
                                            Where NomeUsuario 
                                            Collate SQL_Latin1_General_CP1_CS_AS = @NomeUsuario)
  
  --Descriptografando a Senha
  Return DecryptByPassPhrase(@ChaveCriptografia,@SenhaCriptografada) 
 End
Go

--Consultando a Senha com Nome do Usu�rio Incorreto
Select SQLMagazine.dbo.Fun_DescriptografaSenha('Pedro') As 'Senha'

--Consultando a Senha com Nome do Usu�rio Correto
Select SQLMagazine.dbo.Fun_DescriptografaSenha('Pedro Antonio') As 'Senha'

--Criando Fun��o Scalar para Descriptografia de dados com Autentica��o de Usu�rio
Create Function dbo.[Fun_DescriptografaSenhaAutenticada] (@NomeUsuario VarChar(20), @TxSenha VarChar(50))
Returns VarChar(4000)
As
 Begin
 
  --Chave de Criptografia
  Declare @ChaveCriptografia VarChar(1000) = 'ChaveCriptografia'

  --Recuperando a Senha Criptografada
  Declare @SenhaCriptografada VarChar(Max)=(Select TxSenha From TbUser 
                                            Where NomeUsuario 
                                            Collate SQL_Latin1_General_CP1_CS_AS = @NomeUsuario)
    
  --Descriptografando a Senha
  Declare @Descriptogra VarChar(5000) = DecryptByPassPhrase(@ChaveCriptografia,@SenhaCriptografada)

  --Verificando se a senha � v�lida em rela��o ID do Usu�rio    
  Declare @Retorno VarChar(4000)
  
  If (@Descriptogra Collate SQL_Latin1_General_CP1_CS_AS = @TxSenha)
   Select @Retorno='Usu�rio '+ @NomeUsuario + ' poder� usar o sistema!!!'
  Else  
   Select @Retorno='As credenciais do usu�rio n�o conferem!!!'   
   
  Return @Retorno 
 End
Go

--Utilizando a Fun��o Scalar Fun_DescriptograSenhaAutenticada com Usu�rio inexistente
Declare @Usuario Varchar(30) = 'Pedro', 
        @Senha VarChar(30) = 'Senha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autentica��o Usu�rio'

--Utilizando a Fun��o Scalar Fun_DescriptograSenhaAutenticada com Usu�rio correto e senha errada
Declare @Usuario Varchar(30) = 'Pedro Antonio', 
        @Senha VarChar(30) = 'Senha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autentica��o Usu�rio'

--Utilizando a Fun��o Scalar Fun_DescriptograSenhaAutenticada com Usu�rio e senha corretos
Declare @Usuario Varchar(30) = 'Pedro Antonio', 
        @Senha VarChar(30) = 'MinhaSenha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autentica��o Usu�rio'