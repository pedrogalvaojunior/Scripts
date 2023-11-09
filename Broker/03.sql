USE WebCastServiceBroker
GO

DECLARE @conversationHandle uniqueidentifier

Begin Transaction

-- Begin a dialog to the ISBN Lookup Service

BEGIN DIALOG  @conversationHandle
    FROM SERVICE    [sOrigem]
    TO SERVICE      'sDestino'
    ON CONTRACT     [cOrdemPagamento]
    WITH ENCRYPTION = OFF, LIFETIME = 600;

-- Send a message on the dialog
SEND ON CONVERSATION @conversationHandle 
	MESSAGE TYPE [mtOrdemPagamento] 
(N'<ISBNLookupRequest><ISBN>0972688838</ISBN></ISBNLookupRequest>')

commit