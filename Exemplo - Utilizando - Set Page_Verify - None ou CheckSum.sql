--Configurando o Banco de Dados para não utilizar modelos de verificação de páginas. Com isso não recebermos nenhuma mensagem de erro--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY NONE
Go

--Configurando o Banco de Dados para utilizar modelos de verificação de páginas CheckSum--
ALTER DATABASE BancoCorrompido
SET PAGE_VERIFY CHECKSUM 
Go