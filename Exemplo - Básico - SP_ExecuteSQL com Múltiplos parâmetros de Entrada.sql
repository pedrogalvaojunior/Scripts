-- Declarando os Par�metros --
Declare @NomeEntrada Varchar(20) = 'Pedro', 
               @IdadeEntrada Int = 40

-- Montando o SP_ExecuteSQL --
Execute SP_ExecuteSQL N'P_MeusDados @Nome, @Idade', -- Instru��o 
                                           N'@Nome Varchar(20) Output, @Idade Int Output', -- Par�metros Sa�da
										   @NomeEntrada, @IdadeEntrada -- Mapeamento Entrada x Sa�da
Go