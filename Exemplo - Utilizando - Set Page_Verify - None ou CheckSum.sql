--Configurando o Banco de Dados para n�o utilizar modelos de verifica��o de p�ginas. Com isso n�o recebermos nenhuma mensagem de erro--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY NONE
Go

--Configurando o Banco de Dados para utilizar modelos de verifica��o de p�ginas CheckSum--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY CHECKSUM 
Go