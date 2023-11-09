USE WebCastServiceBroker
GO

CREATE SERVICE [sDestino] ON QUEUE [qDestino]
	( 
	[cOrdemPagamento] 
	)
CREATE SERVICE [sOrigem] ON QUEUE [qOrigem]
go