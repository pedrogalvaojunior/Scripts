Create Database MsTechDay
Go


-- Criando uma nova Tabela --
CREATE TABLE Familia
(Nomes varchar(15))
Go

INSERT INTO Familia values
('Pedro'), ('Fernanda'), ('Eduardo'), ('Jo�o Pedro'), ('Maria Lu�za')

-- Criando uma nova Sequ�ncia de Valores --
CREATE SEQUENCE Seq As INT -- Tipo
 START WITH 1 -- Valor Inicial (1)
 INCREMENT BY 1 -- Avan�a de um em um
 MINVALUE 1 -- Valor m�nimo 1
 MAXVALUE 10 -- Valor m�ximo 10000
 CACHE 10 -- Mant�m 10 posi��es em cache
 NO CYCLE -- N�o ir� reciclar

  -- Utilizando a Sequ�ncia de Valores --
SELECT Next VALUE FOR Seq AS ID, Nomes FROM Familia;

-- Reinicializando a valor da Sequ�ncia --
ALTER Sequence Seq
 RESTART WITH 1 ;

   -- Utilizando a Sequ�ncia de Valores --
SELECT Next VALUE FOR Seq AS ID, Nomes FROM Familia;

-- Exclu�ndo a Sequ�ncia --
Drop Sequence Seq