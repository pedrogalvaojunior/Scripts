-- Declarando os Parâmetros --
Declare @NomeEntrada Varchar(20) = 'Pedro', 
               @IdadeEntrada Int = 40

-- Montando o SP_ExecuteSQL --
Execute SP_ExecuteSQL N'P_MeusDados @Nome, @Idade', -- Instrução 
                                           N'@Nome Varchar(20) Output, @Idade Int Output', -- Parâmetros Saída
										   @NomeEntrada, @IdadeEntrada -- Mapeamento Entrada x Saída
Go