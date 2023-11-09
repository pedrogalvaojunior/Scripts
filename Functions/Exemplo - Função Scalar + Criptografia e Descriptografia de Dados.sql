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

--Criando Função Scalar para Criptografia de dados
Alter Function Fun_CriptografaSenha (@TxSenha VarChar(1000))
Returns VarBinary(4000)
As
 Begin
  --Chave de Criptografia
  Declare @ChaveCriptografia VarChar(1000) = 'ChaveCriptografia'
  
  Return EncryptByPassPhrase(@ChaveCriptografia, @TxSenha)
 End
Go

--Inserindo os Dados utilizando a Função Fun_CriptografaSenha
Insert Into TbUser(NomeUsuario,TxSenha) Output inserted.NomeUsuario, inserted.TxSenha
 Values ('Pedro Antonio',SQLMagazine.dbo.Fun_CriptografaSenha('MinhaSenha'))
Go 

--Criando Função Scalar para Descriptografia de dados
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

--Consultando a Senha com Nome do Usuário Incorreto
Select SQLMagazine.dbo.Fun_DescriptografaSenha('Pedro') As 'Senha'

--Consultando a Senha com Nome do Usuário Correto
Select SQLMagazine.dbo.Fun_DescriptografaSenha('Pedro Antonio') As 'Senha'

--Criando Função Scalar para Descriptografia de dados com Autenticação de Usuário
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

  --Verificando se a senha é válida em relação ID do Usuário    
  Declare @Retorno VarChar(4000)
  
  If (@Descriptogra Collate SQL_Latin1_General_CP1_CS_AS = @TxSenha)
   Select @Retorno='Usuário '+ @NomeUsuario + ' poderá usar o sistema!!!'
  Else  
   Select @Retorno='As credenciais do usuário não conferem!!!'   
   
  Return @Retorno 
 End
Go

--Utilizando a Função Scalar Fun_DescriptograSenhaAutenticada com Usuário inexistente
Declare @Usuario Varchar(30) = 'Pedro', 
        @Senha VarChar(30) = 'Senha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autenticação Usuário'

--Utilizando a Função Scalar Fun_DescriptograSenhaAutenticada com Usuário correto e senha errada
Declare @Usuario Varchar(30) = 'Pedro Antonio', 
        @Senha VarChar(30) = 'Senha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autenticação Usuário'

--Utilizando a Função Scalar Fun_DescriptograSenhaAutenticada com Usuário e senha corretos
Declare @Usuario Varchar(30) = 'Pedro Antonio', 
        @Senha VarChar(30) = 'MinhaSenha'

Select dbo.Fun_DescriptografaSenhaAutenticada(@Usuario, @Senha) As 'Autenticação Usuário'