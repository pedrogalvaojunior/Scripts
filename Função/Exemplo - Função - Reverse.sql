Declare @Texto VarChar(100)

Set @Texto = 'Este é um pequeno texto para exemplificar a utilização da função Reverse'

Print 'Texto Normal'+Char(13)+@Texto


Print 'Texto Invertido'+Char(13)+Reverse(@Texto)