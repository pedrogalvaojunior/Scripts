USE WebCastServiceBroker
GO

CREATE MESSAGE TYPE [mtOrdemPagamento] VALIDATION = WELL_FORMED_XML 
CREATE MESSAGE TYPE [mtRetorno] VALIDATION = WELL_FORMED_XML

CREATE CONTRACT [cOrdemPagamento]
	( 
	[mtOrdemPagamento] SENT BY initiator,
	[mtRetorno] SENT BY target
	)
;


-- Create the two queues that our dialog will communicate between.  A
-- dialog requires two queues.
CREATE QUEUE [ISBNLookupTargetQueue]
CREATE QUEUE [ISBNLookupInitiatorQueue]

-- Create the services that name our dialog endpoints.  A service links
-- a conversation endpoint to a queue.
CREATE SERVICE [ISBNLookupRequestService] ON QUEUE [ISBNLookupTargetQueue]
	( 
	[cOrdemPagamento] 
	)
CREATE SERVICE [ISBNLookupResponseService] ON QUEUE [ISBNLookupInitiatorQueue]
go