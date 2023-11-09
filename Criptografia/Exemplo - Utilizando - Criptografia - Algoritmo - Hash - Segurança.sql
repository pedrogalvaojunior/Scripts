--Declarando um variável @HashThis--
DECLARE @MeuValorCriptografado NVarChar(max);

SELECT @MeuValorCriptografado = CONVERT(nvarchar,'Pedro');

/* Utilizando a função HashBytes para converter a sentença 
com uso dos Algoritmos Hash + SHA1, SHA, MD5, MD4, MD2 */

SELECT HashBytes('SHA1', @MeuValorCriptografado) Resultado
Union 
SELECT HashBytes('SHA', @MeuValorCriptografado)
Union 
Select HashBytes('MD5', @MeuValorCriptografado)
Union 
Select HashBytes('MD4', @MeuValorCriptografado)
Union 
Select HashBytes('MD2', @MeuValorCriptografado)
Union
Select HashBytes('SHA2_256', @MeuValorCriptografado)
Union
Select HashBytes('SHA2_512', @MeuValorCriptografado)
Go