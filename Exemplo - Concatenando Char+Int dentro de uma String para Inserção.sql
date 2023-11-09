Create Procedure P_MontarTextos @Linhas Int
As

Drop Table Textos

Create Table Textos
 (Codigo Int Identity(1,1),
   Valor1 VarChar(20),
   Valor2 VarChar(20),
   Valor3 VarChar(25))


Declare @String VarChar(100),
           @Comando VarChar(100),
           @Contador Int

Set @Contador=1

Truncate Table Textos

While @Contador <=@Linhas
 Begin
  Set @String='''Olá'+Convert(VarChar(4), @Contador)+''''+','+'''Oi'+Convert(VarChar(4), @Contador)+''''+','+'''Tudo Bem'+Convert(VarChar(4), @Contador)+''''
  Set @Comando= 'Insert Into Textos Values('+@String+')'

  print @comando
  
  Set @Contador = @Contador + 1

  Exec(@comando)
 End

Select * from Textos


Exec P_MontarTextos 1000

