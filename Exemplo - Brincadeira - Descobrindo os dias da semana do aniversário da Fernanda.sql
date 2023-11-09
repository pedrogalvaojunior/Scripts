Set NoCount On
Set DateFirst 1

Declare @AnoNascimento SmallInt = 1981, 
             @DataNascimento Char(5) = '28/01'

Declare @Tabela Table
 (Codigo Int Primary Key Identity(1,1),
  DataNascimento Date Null,
  AnoNascimento As Year(DataNascimento))
  
While @AnoNascimento <= Year(GetDate())
Begin
 
 Insert @Tabela (DataNascimento)
 Select Convert(Date,CONCAT(@DataNascimento,'/',@AnoNascimento),103)
    
 Set @AnoNascimento +=1
End

-- Utilizando operador Union All --
 Select Concat('Minha pequena Fernanda nasceu no dia, ', Convert(Char(10),DataNascimento,103), ' era uma ',
                      Case DatePart(W,DataNascimento)
                        When 1 Then 'Segunda-Feira, '
                        When 2 Then 'Terça-Feira, em '
                        When 3 Then 'Quarta-Feira, '
                        When 4 Then 'Quinta-Feira '
                        When 5 Then 'Sexta-Feira '
                        When 6 Then 'Sábado, '
                        When 7 Then 'Domingo, '
					   End) As 'Contando uma pequena história: '
From @Tabela
Where Codigo = 1					    
Union All
Select Concat('após 12 meses de muitas descobertas ela comemorou seu primerio ano de vida em um(a) ',         
                      Case DatePart(W,DataNascimento)
                        When 1 Then 'Segunda-Feira, no ano de 1982, '
                        When 2 Then 'Terça-Feira, no ano de 1982, '
                        When 3 Then 'Quarta-Feira, no ano de 1982, '
                        When 4 Then 'Quinta-Feira, no ano de 1982, '
                        When 5 Then 'Sexta-Feira, no ano de 1982, '
                        When 6 Then 'Sábado, no ano de 1982, '
                        When 7 Then 'Domingo, no ano de 1982, '
					   End)
From @Tabela
Where Codigo = 2
Union All
Select Concat('com o passar do tempo Fernandinha foi crescendo se tornando uma linda menina, garotinha e mulher, comemorando seu aniversário de ',Convert(TinyInt, Codigo-1), ' anos no seguinte dia da semana ',
                      Case DatePart(W,DataNascimento)
                        When 1 Then Concat('Segunda-Feira, no ano de ', AnoNascimento,', ')
                        When 2 Then Concat('Terça-Feira,  no ano de ', AnoNascimento,', ')
                        When 3 Then Concat('Quarta-Feira, no ano de', AnoNascimento,', ')
                        When 4 Then Concat('Quinta-Feira, no ano de ', AnoNascimento,', ')
                        When 5 Then Concat('Sexta-Feira, no ano de ', AnoNascimento,', ')
                        When 6 Then Concat('Sábado, no ano de ', AnoNascimento,', ')
                        When 7 Then Concat('Domingo, no ano de ', AnoNascimento,', ')
					   End)
From @Tabela
Where Codigo Between 2 And 36
Union All
Select Concat('em 2017 ela vai ficar mais velhinha comemorando seu aniversário de  ',Convert(TinyInt, Codigo -1), ' anos em qual dia da semana? A resposta é: ',
               		    Case DatePart(W,DataNascimento)
						 When 1 Then 'Segunda-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 2 Then 'Terça-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 3 Then 'Quarta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 4 Then 'Quinta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 5 Then 'Sexta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 6 Then 'Sábado!!! Desejo que esta data se repita para o resto das nossas vidas.'
  						 When 7 Then 'Domingo!!! Desejo que esta data se repita para o resto das nossas vidas.' 
						End) 
From @Tabela
Where Codigo = 37

 -- Utilizando a função IIF --
 Select IIF(Codigo=1, Concat('Minha pequena Fernanda nasceu no dia, ', Convert(Char(10),DataNascimento,103), ' era uma ',
                      Case DatePart(W,DataNascimento)
                        When 1 Then 'Segunda-Feira, '
                        When 2 Then 'Terça-Feira, em '
                        When 3 Then 'Quarta-Feira, '
                        When 4 Then 'Quinta-Feira '
                        When 5 Then 'Sexta-Feira '
                        When 6 Then 'Sábado, '
                        When 7 Then 'Domingo, '
					   End), 
			 IIF(Codigo=2,Concat('após 12 meses de muitas descobertas ela comemorou seu primerio ano de vida em um(a) ',         
                      Case DatePart(W,DataNascimento)
                        When 1 Then 'Segunda-Feira, no ano de 1982, '
                        When 2 Then 'Terça-Feira, no ano de 1982, '
                        When 3 Then 'Quarta-Feira, no ano de 1982, '
                        When 4 Then 'Quinta-Feira, no ano de 1982, '
                        When 5 Then 'Sexta-Feira, no ano de 1982, '
                        When 6 Then 'Sábado, no ano de 1982, '
                        When 7 Then 'Domingo, no ano de 1982, '
					   End), 				
			IIF(Codigo>2 And Codigo <=36,Concat('com o passar do tempo Fernandinha foi crescendo se tornando uma linda menina, garotinha e mulher, comemorando seu aniversário de ',Convert(TinyInt, Codigo-1), ' anos no seguinte dia da semana ',
                      Case DatePart(W,DataNascimento)
                        When 1 Then Concat('Segunda-Feira, no ano de ', AnoNascimento,', ')
                        When 2 Then Concat('Terça-Feira,  no ano de ', AnoNascimento,', ')
                        When 3 Then Concat('Quarta-Feira, no ano de', AnoNascimento,', ')
                        When 4 Then Concat('Quinta-Feira, no ano de ', AnoNascimento,', ')
                        When 5 Then Concat('Sexta-Feira, no ano de ', AnoNascimento,', ')
                        When 6 Then Concat('Sábado, no ano de ', AnoNascimento,', ')
                        When 7 Then Concat('Domingo, no ano de ', AnoNascimento,', ')
					   End), 
			IIF(Codigo=37, Concat('em 2017 ela vai ficar mais velhinha comemorando seu aniversário de  ',Convert(TinyInt, Codigo -1), ' anos em qual dia da semana? A resposta é: ',
               		    Case DatePart(W,DataNascimento)
						 When 1 Then 'Segunda-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 2 Then 'Terça-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 3 Then 'Quarta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 4 Then 'Quinta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 5 Then 'Sexta-Feira!!! Desejo que esta data se repita para o resto das nossas vidas.'
						 When 6 Then 'Sábado!!! Desejo que esta data se repita para o resto das nossas vidas.'
  						 When 7 Then 'Domingo!!! Desejo que esta data se repita para o resto das nossas vidas.' 
						End),'')))) As 'Contando uma pequena história: '
From @Tabela
