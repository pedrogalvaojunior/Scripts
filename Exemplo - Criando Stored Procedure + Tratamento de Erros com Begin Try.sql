-- Criando a Stored Procedure P_Calcular --
Create Procedure P_Calcular @Valor1 Int = Null, @Valor2 Int = Null, @Operador Char(1)
As
Begin
Set NoCount On

 If (@Valor1 Is Not Null And @Valor2 Is Not Null)
  Begin

  -- Bloco Begin Try --
   Begin Try
    
    Declare @Resultado Int
    Set @Resultado=0

    If @Operador = '+'
     Set @Resultado = (@Valor1 + @Valor2)
    Else
    If @Operador = '-'
     Set @Resultado = (@Valor1 - @Valor2)
    Else
    If @Operador = '*'
     Set @Resultado = (@Valor1 * @Valor2)
    Else
    If @Operador = '/'
     Set @Resultado = (@Valor1 / @Valor2)
    Else
     Select 'Operador inválido'

    Select 'O Resultado da Operação'+
            Case @Operador
		     When '+' Then ' Adição é: '+CONVERT(Varchar(5),@Resultado)
		     When '-' Then ' Subtração' +CONVERT(Varchar(5),@Resultado)
		     When '*' Then ' Multiplicação é: '+CONVERT(Varchar(5),@Resultado)
		     When '/' Then ' Divisão' +CONVERT(Varchar(5),@Resultado)
		    End As Operacao
  End Try -- Encerrando o Begin Try --

  -- Bloco Begin Catch --
  Begin Catch
 
   SELECT ERROR_NUMBER() AS ErrorNumber,
                 ERROR_SEVERITY() AS ErrorSeverity,
                 ERROR_STATE() AS ErrorState,
                 ERROR_PROCEDURE() AS ErrorProcedure,
                 ERROR_MESSAGE() AS ErrorMessage,
                 ERROR_LINE() AS ErrorLine;         
  End Catch -- Encerrando o Begin Catch --   
  End
  Else
   Select 'Informe os Valores para realizar a Operação' As 'Mensagem de Alerta'  
End

-- Executando a Stored Procedure P_Calcular --
Execute P_Calcular 10,0,'/'