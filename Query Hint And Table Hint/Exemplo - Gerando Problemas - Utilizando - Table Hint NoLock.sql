-- Criando a Tabela Usuarios --
Create Table Usuarios
(Codigo SmallInt Identity(1,1) Primary Key Clustered,
 Nome Varchar(20) Not Null)
Go

-- Inserindo Dados na Tabela Usuarios --
Insert Into Usuarios Values ('Pedro'),('Junior'),('Antonio'),('Galvão')
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
/*Toda transação apresenta um comportamento atômico, ou seja, tudo ou nada. 
A transação abaixo remove os registros da tabela Usuarios e tbPedidos simultaneamente, 
na qual os registros são apagados de ambas as tabelas ou de nenhuma tabela. 
Não existe um estado transitório – no qual alguns registros ‘Galvão’ 
se encontram na tabela tbPedidos, mas já foram apagados de Usuarios. 
Isso se chama consistência de dados.*/


BEGIN TRANSACTION 
 
  DELETE Usuarios WHERE nome = 'Galvão' 
  DELETE Pedidos WHERE CodUsuario = (Select Codigo From Usuarios Where Nome = 'Galvão')
 
COMMIT TRANSACTION 

/*A garantia de consistência de dados é realizada através dos bloqueios (LOCK), 
que são mantidos até a fase de COMMIT TRANSACTION. Somente após finalizar a transação, 
os LOCKs são liberados e a leitura é permitida. Isso corresponde a uma leitura 
consistente (READ COMMITTED). 

Por outro lado, ao usar um comando com NOLOCK, estamos sinalizando ao SQL Server que 
utilize uma leitura suja (READ UNCOMMITTED). Essa leitura não espera pelo final da 
transação, ou seja, a leitura é observa todos os estados transitórios.*/

 
-- Exemplo 2
/*Ainda pensando na consistência de dados usando transação, imagine a situação na qual 
temos a seguinte operação.*/

BEGIN TRANSACTION 
 
   -- Marca o registro como temporário 
   UPDATE Usuarios SET nome = 'tmp' WHERE nome = 'Galvão' 
 
   -- Defaz a operação 
   UPDATE Usuarios SET nome = 'Galvão' WHERE nome = 'tmp' 
 
COMMIT TRANSACTION 

/*A transação efetua a modificação de Galvão –> TMP –> Galvão, ou seja, não faz 
absolutamente nenhuma mudança comparando os estados inicial e final. Isso garante que o 
simples comando abaixo sempre retorne o nome correto.*/

SELECT * FROM Usuarios
 
/*Se fosse utilizado o comando NOLOCK, existiria a remota possibilidade de observarmos 
os estados transitórios.*/


SELECT * FROM Usuarios WITH (NOLOCK)
