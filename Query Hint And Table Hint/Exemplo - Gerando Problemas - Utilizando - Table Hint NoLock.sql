-- Criando a Tabela Usuarios --
Create Table Usuarios
(Codigo SmallInt Identity(1,1) Primary Key Clustered,
 Nome Varchar(20) Not Null)
Go

-- Inserindo Dados na Tabela Usuarios --
Insert Into Usuarios Values ('Pedro'),('Junior'),('Antonio'),('Galv�o')
Go

-- Criando a Tabela Pedidos --
Create Table Pedidos
(Codigo Int Identity(1,1) Primary Key Clustered,
 CodUsuario SmallInt Not Null)
Go

Insert Into Pedidos Values (1),(1),(1),
						   (2),(2),(2),
						   (3),(3),(2),
						   (4),(3),(1)

-- Exemplo 1 --
/*Toda transa��o apresenta um comportamento at�mico, ou seja, tudo ou nada. 
A transa��o abaixo remove os registros da tabela Usuarios e tbPedidos simultaneamente, 
na qual os registros s�o apagados de ambas as tabelas ou de nenhuma tabela. 
N�o existe um estado transit�rio � no qual alguns registros �Galv�o� 
se encontram na tabela tbPedidos, mas j� foram apagados de Usuarios. 
Isso se chama consist�ncia de dados.*/


BEGIN TRANSACTION 
 
  DELETE Usuarios WHERE nome = 'Galv�o' 
  DELETE Pedidos WHERE CodUsuario = (Select Codigo From Usuarios Where Nome = 'Galv�o')
 
COMMIT TRANSACTION 

/*A garantia de consist�ncia de dados � realizada atrav�s dos bloqueios (LOCK), 
que s�o mantidos at� a fase de COMMIT TRANSACTION. Somente ap�s finalizar a transa��o, 
os LOCKs s�o liberados e a leitura � permitida. Isso corresponde a uma leitura 
consistente (READ COMMITTED). 

Por outro lado, ao usar um comando com NOLOCK, estamos sinalizando ao SQL Server que 
utilize uma leitura suja (READ UNCOMMITTED). Essa leitura n�o espera pelo final da 
transa��o, ou seja, a leitura � observa todos os estados transit�rios.*/

 
-- Exemplo 2
/*Ainda pensando na consist�ncia de dados usando transa��o, imagine a situa��o na qual 
temos a seguinte opera��o.*/

BEGIN TRANSACTION 
 
   -- Marca o registro como tempor�rio 
   UPDATE Usuarios SET nome = 'tmp' WHERE nome = 'Galv�o' 
 
   -- Defaz a opera��o 
   UPDATE Usuarios SET nome = 'Galv�o' WHERE nome = 'tmp' 
 
COMMIT TRANSACTION 

/*A transa��o efetua a modifica��o de Galv�o �> TMP �> Galv�o, ou seja, n�o faz 
absolutamente nenhuma mudan�a comparando os estados inicial e final. Isso garante que o 
simples comando abaixo sempre retorne o nome correto.*/

SELECT * FROM Usuarios
 
/*Se fosse utilizado o comando NOLOCK, existiria a remota possibilidade de observarmos 
os estados transit�rios.*/


SELECT * FROM Usuarios WITH (NOLOCK)
