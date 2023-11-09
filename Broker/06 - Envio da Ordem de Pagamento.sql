USE WebCastServiceBroker
GO

DECLARE @conversationHandle uniqueidentifier

Begin Transaction

-- Inicia um diálogo entre os serviços da origem e destino

BEGIN DIALOG  @conversationHandle
    FROM SERVICE    [sOrigem]
    TO SERVICE      'sDestino'
    ON CONTRACT     [cOrdemPagamento]
    WITH ENCRYPTION = OFF, LIFETIME = 600;

-- Cria o conteúdo da mensagem
DECLARE @mensagem XML
SET @mensagem = N'<?xml version="1.0"?>
<Ordem num="001">
 <CNPJ>51.678.399/0001-54</CNPJ>
 <Banco>001</Banco>
 <Agencia>1003-X</Agencia>
 <Conta>19875-1</Conta>
 <Valor>1000.00</Valor>
</Ordem>';

-- Envia uma mensagem no diálogo
SEND ON CONVERSATION @conversationHandle 
	MESSAGE TYPE [mtOrdemPagamento] 
(@mensagem)

commit