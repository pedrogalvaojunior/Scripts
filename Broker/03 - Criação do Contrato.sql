USE WebCastServiceBroker
GO

CREATE CONTRACT [cOrdemPagamento]
	( 
	[mtOrdemPagamento] SENT BY initiator,
	[mtRetorno] SENT BY target
	);