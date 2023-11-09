-- Criação do banco de dados
CREATE DATABASE WebCastServiceBroker

-- Ativação do recurso de Service Broker
ALTER DATABASE WebCastServiceBroker
SET ENABLE_BROKER

-- Verificação
SELECT
	Name, is_broker_enabled FROM sys.databases
WHERE
	Name = 'WebCastServiceBroker'