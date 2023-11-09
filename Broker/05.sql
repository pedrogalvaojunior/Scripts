USE WebCastServiceBroker
GO

RECEIVE  
	cast(message_body as xml)
	FROM [qOrigem]