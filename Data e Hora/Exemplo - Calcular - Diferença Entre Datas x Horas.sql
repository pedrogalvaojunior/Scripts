Create Trigger T_Calcular_Horas
On CTProducao_Moinho
For Insert, Update
As
Declare @TotalDias VarChar(4),
           @TotalHoras VarChar(3),
           @TotalMinutos VarChar(4),
           @NUMMO CHAR(7),
           @ValorFormatado Char(5)
  
Set @NUMMO=(Select NUMMO from Inserted)

Set @TotalDias=(Select DateDiff(Day,DataInicio,DataFinal) from CTProducao_Moinho Where NUMMO=@NUMMO)
Set @TotalHoras=(Select DateDiff(Hour,Convert(Char(20),DataInicio,103)+HoraInicio,Convert(Char(20),DataFinal,103)+HoraFinal) from CTProducao_Moinho Where NUMMO=@NUMMO)
Set @TotalMinutos=(Select DateDiff(Minute,Convert(Char(20),DataInicio,103)+HoraInicio,Convert(Char(20),DataFinal,103)+HoraFinal) from CTProducao_Moinho Where NUMMO=@NUMMO)

If @TotalDias >=2
 Begin
  Update CTProducao_Moinho
  Set TotalHoras=@TotalHoras+':00'
  Where NUMMO=@NUMMO
 End
 Else
  Begin
   If (@TotalHoras >=1) And (@TotalHoras <=24)
    Begin
      If (@TotalHoras = 1) And (@TotalMinutos < 60)
       Set @ValorFormatado='00:'+@TotalMinutos
      
      If (Len(@TotalHoras) = 1) And (@TotalMinutos > 60)
        Begin
         Set @ValorFormatado=Convert(Char(4),Convert(Int,@TotalMinutos)/Convert(Int,@TotalHoras))
         Set @ValorFormatado='0'+@TotalHoras+':'+@ValorFormatado
        End

      If (Len(@TotalHoras) = 1)
       Set @ValorFormatado='0'+@TotalHoras+':00'
      
      If (Len(@TotalHoras) = 1) And (@TotalMinutos = 60)
       Set @ValorFormatado='0'+@TotalHoras+':00'
      
      Update CTProducao_Moinho
      Set TotalHoras=@ValorFormatado
      Where NUMMO=@NUMMO
    End
    Else
     Begin
      If @TotalMinutos=60
       Begin
        Update CTProducao_Moinho
        Set TotalHoras='01:00'                            
        Where NUMMO=@NUMMO
       End
       Else
        Begin
         If Len(@TotalMinutos) = 1
          Set @ValorFormatado='00:0'+@TotalMinutos
         Else
           Set @ValorFormatado='00:'+@TotalMinutos

        Update CTProducao_Moinho
        Set TotalHoras = @ValorFormatado
        Where NUMMO=@NUMMO 
       End
      End
     End

