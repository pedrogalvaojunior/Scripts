USE WebCastServiceBroker
GO

-- Procura por mensagens na fila 
select cast(message_body as xml) from qDestino
go

-- Declara as variáveis para recebimento dos dados da mensagem
DECLARE @conversationHandle uniqueidentifier
declare @message_body XML
declare @message_type_name sysname;

-- Inicia uma transação
Begin Transaction;

-- Recebe mensagens da fila
RECEIVE TOP(1) 
	@message_type_name=message_type_name,		-- Tipo de mensagem
	@conversationHandle=conversation_handle,	-- Handle
	@message_body=message_body					-- Conteúdo da Mensagem
	FROM [qDestino]

-- Imprime o corpo da mensagem
SELECT @message_body

-- Verifica se a mensagem é uma ordem de pagamento e em caso afirmativo já envia o retorno.
if @message_type_name = N'mtOrdemPagamento'
	Begin

		DECLARE @mensagemRetorno XML
		SET @mensagemRetorno = '<Retorno>A ordem de pagamento ' +
			@message_body.value('(/Ordem/@num)[1]','nvarchar(20)') +
            ' foi entregue para processamento</Retorno>';

		SEND ON CONVERSATION @conversationHandle -- Interage no mesmo diálogo
			MESSAGE TYPE [mtRetorno] 
			(@mensagemRetorno)

		-- Finaliza o diálogo já que as mensagens necessárias já foram enviadas.
		END CONVERSATION @conversationHandle
	End

COMMIT

-- As mensagens foram retiradas da fila e agora a mesma está vazia
select cast(message_body as xml) from qDestino
go