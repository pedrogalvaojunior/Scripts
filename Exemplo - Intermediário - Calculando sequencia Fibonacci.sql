-- Criando a Tabela --
Create Table NumerosFibonacci
 (Codigo Int Primary Key Identity(0,1),
  Numeros BigInt Not Null)
Go

-- Declarando as Variáveis de Controle --
Declare @Contador TinyInt = 0, @SequenciaFinobacciConcatenada Varchar(Max)

While @Contador <50
Begin

 If @Contador = 0
  Begin
   Insert Into NumerosFibonacci (Numeros) Values (0)
   Set @SequenciaFinobacciConcatenada = '0'
 End
 Else
  Begin
   Insert Into NumerosFibonacci (Numeros)
   Select IsNull(Sum(Numeros)+1,1) from NumerosFibonacci
   Where Codigo < @Contador - 1     
   
   Set @SequenciaFinobacciConcatenada = (Select Concat(@SequenciaFinobacciConcatenada,',',Numeros) from NumerosFibonacci Where Codigo = @Contador)
  End 
 
 Set @Contador +=1

End

-- Apresentando a Lista de Números no formato de Tabela --
Select Numeros 'Numeros List' From NumerosFibonacci

-- Apresentando a Lista de Números no Formato Concatenado --
Select @SequenciaFinobacciConcatenada As 'NumerosFibonacci Fibonacci'
Go

-- Limpando a Tabela --
Truncate Table NumerosFibonacci
Go