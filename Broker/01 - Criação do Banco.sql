-- Cria��o do banco de dados
CREATE DATABASE WebCastServiceBroker

-- Ativa��o do recurso de Service Broker
ALTER DATABASE WebCastServiceBroker
SET ENABLE_BROKER

-- Verifica��o
SELECT
	Name, is_broker_enabled FROM sys.databases
WHERE
	Name = 'WebCastServiceBroker'