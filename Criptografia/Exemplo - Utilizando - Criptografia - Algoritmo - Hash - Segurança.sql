--Declarando um vari�vel @HashThis--
DECLARE @MeuValorCriptografado NVarChar(max);

SELECT @MeuValorCriptografado = CONVERT(nvarchar,'Pedro');

/* Utilizando a fun��o HashBytes para converter a senten�a 
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