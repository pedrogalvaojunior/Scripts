USE master
Go

CREATE DATABASE BancoCorrompido
Go

USE BancoCorrompido
Go

--Configurando o Banco de Dados para não utilizar modelos de verificação de páginas. Com isso não recebermos nenhuma mensagem de erro--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY NONE
Go

CREATE TABLE Valores 
(Codigo Int IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Nome VARCHAR(200) NOT NULL)
Go

INSERT INTO Valores VALUES ('Pedro Antonio Galvão Junior')
Go

--Verificando a Consistência do Banco de Dados--
DBCC CHECKDB()

--Retorno--
/*
There are 1 rows in 1 pages for object "Dados".
CHECKDB found 0 allocation errors and 0 consistency errors in database 'BancoCorrompido'.
DBCC execution completed. If DBCC printed error messages, contact your system administrator.
*/

--Obtendo a Página de Dados do Índice--
SELECT First As 'Área de Alocação' FROM sys.sysindexes as s
where s.id = OBJECT_ID('Valores')

--Encontrando o número da página de dados--
Declare @NumPagina Varbinary

SELECT @NumPagina=First  FROM sys.sysindexes as s
where s.id = OBJECT_ID('Valores')

Select CONVERT(Int,@NumPagina)

/*
	First: 0x910000000100
	Arquivo = 1
	Página = 145 (0x91)
*/

--Ativando a Trace Flag 3604 para exibir o resultado do DBCC Page--
DBCC TRACEON(3604)

--Utilizando o DBCC Page + Número da Página de Dados
DBCC PAGE (BancoCorrompido, 1, 145, 2)

/*Vamos guardar o início da página, referenciado como Memory Dump

Memory Dump @0x44D8C000

44D8C000:   01010400 00c00001 00000000 00000800 †.....À..........         
44D8C010:   00000000 00000100 1b000000 741f8a00 †............t..         
44D8C020:   91000000 01000000 15000000 4f000000 †...........O...         
44D8C030:   16000000 00000000 00000000 00000000 †................         
44D8C040:   00000000 00000000 00000000 00000000 †................         
44D8C050:   00000000 00000000 00000000 00000000 †................         
44D8C060:   30000800 01000000 02000001 002a0050 †0............*.P         
44D8C070:   6564726f 20416e74 6f6e696f 2047616c †edro Antonio Gal         
44D8C080:   76e36f20 4a756e69 6f720000 21212121 †vão Junior..!!!!

*/

UPDATE Valores
SET Nome = 'Pedro Antonio Galvão Junior II'

--Ativando a Trace Flag 3604 para exibir o resultado do DBCC Page--
DBCC TRACEON(3604)

--Utilizando o DBCC Page + Número da Página de Dados
DBCC PAGE (BancoCorrompido, 1, 145, 2)

--Verificando o Memory Dump e Alteração dos dados--

/*Memory Dump @0x4335C000

4335C000:   01010400 00c00001 00000000 00000800 †.....À..........         
4335C010:   00000000 00000100 1b000000 711fb700 †............q.·.         
4335C020:   91000000 01000000 15000000 a6000000 †...........¦...         
4335C030:   02000000 00000000 00000000 00000000 †................         
4335C040:   01000000 00000000 00000000 00000000 †................         
4335C050:   00000000 00000000 00000000 00000000 †................         
4335C060:   30000800 01000000 02000001 002a0050 †0............*.P         
4335C070:   6564726f 20416e74 6f6e696f 2047616c †edro Antonio Gal         
4335C080:   76e36f20 4a756e69 6f723000 08000100 †vão Junior0.....         
4335C090:   00000200 0001002d 00506564 726f2041 †.......-.Pedro A         
4335C0A0:   6e746f6e 696f2047 616c76e3 6f204a75 †ntonio Galvão Ju         
4335C0B0:   6e696f72 20494900 00212121 21212121 †nior II..!!!!!!!  

*/

-- Observamos a mudança de valores nas posições--

--Encontrando o Offset dos dados dentro da estrutura binária--
Select (145*8192) -- Página 145 -> 145 * 8192 = 1187840 

Select Convert(Varbinary,1187840)-->0x00122000

--Vamos verificar os dados através do Editor no Arquivo MDF, para isso paramos o serviço do SQL Server--

--Abrir o Editor, localizar o OffSet, realizar a alterar e voltar para o SQL Server--

/*Realizar um SELECT na tabela Valores. Qual será o resultado??? 
O “Pedro Antonio Galvão Junior II” voltou a ser “Pedro Antonio Galvão Junior”. 
Até aqui não vemos nenhum erro, pois o SQL Server não estava com nenhuma verificação específica para o banco de dados, o que está para mudar…
*/

--Configurando o Banco de Dados para utilizar modelos de verificação de páginas CheckSum--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY CHECKSUM 
Go

UPDATE Valores 
SET Nome = 'Pedro Antonio Galvão Junior' 
Go 

--Verificando a Consistência do Banco de Dados--
DBCC CHECKDB() 
Go
 
DBCC results for 'Valores'. 
There are 1 rows in 1 pages for object "Dados". 
CHECKDB found 0 allocation errors and 0 consistency errors in database 'BancoCorrompido'.
 

/*Como resultado, teremos um banco de dados com CHECKSUM habilitado e a página com seu checksum calculado, pois foi executado um update na tabela.
O CHECKDB vai executar com sucesso e nenhum erro será reportado. Repetir o procedimento de alteração do nome através do do editor hexadecimal. 
Reinicie o serviço do SQL Server e tente executar a consulta abaixo:*/
 
SELECT * FROM Valores 

--Teremos o retorno de uma mensagem de erro--

--Tentar executar o DBCC Check(), vamos receber as mensagens de erro apontando as inconsistências do nosso banco de dados--
 

/*Neste caso como o problema é na página de dados, não temos como fazer uma reconstrução(Rebuild) dos índices, principalmente para indices não clusterizados, 
pois a área de alocação esta danificada, sendo assim, vamos ter que partir para o Restore do Banco de Dados.*/

