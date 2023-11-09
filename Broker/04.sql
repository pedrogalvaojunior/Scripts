USE WebCastServiceBroker
GO

-- Procura por mensagens na fila 
select cast(message_body as nvarchar(MAX)) from [qDestino]
go

-- Declara as variáveis para recebimento dos dados da mensagem
DECLARE @conversationHandle uniqueidentifier
declare @message_body nvarchar(MAX)
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
PRINT @message_body

-- Verifica se a mensagem é uma ordem de pagamento e em caso afirmativo já envia o retorno.
if @message_type_name = N'mtOrdemPagamento'
	Begin
		SEND ON CONVERSATION @conversationHandle -- respond on the same dialog
			MESSAGE TYPE [mtRetorno] 
			(N'<ISBNLookupResponse>
					<Title>The Rational Guide to SQL Server Service Broker</Title>
				</ISBNLookupResponse>')

		-- End the conversation because we're done with it.
		END CONVERSATION @conversationHandle
	End
-- Commit the transaction
-- If we rolled back at this point, everything would be back where we started
commit
-- The queue should be empty now
select cast(message_body as nvarchar(MAX)) from [qDestino]
go

