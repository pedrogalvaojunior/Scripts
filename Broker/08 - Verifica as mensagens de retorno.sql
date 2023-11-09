USE WebCastServiceBroker
GO

SELECT cast(message_body as XML) FROM [qOrigem];

RECEIVE  
	cast(message_body as xml)
	FROM [qOrigem]