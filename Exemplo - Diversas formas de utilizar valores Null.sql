Declare @String VarChar(100)

Set @String=''

Select IsNull(@String,'Imagem.jpg')

Set @String=Null

Select IsNull(@String,'Imagem.jpg')


Select Case @String
           When '' Then 'Teste'
          Else 'Imagem.jpg'
         End As String